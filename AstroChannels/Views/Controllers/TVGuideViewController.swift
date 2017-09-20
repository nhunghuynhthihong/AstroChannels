//
//  TVGuideViewController.swift
//  AstroChannels
//
//  Created by Candice H on 9/16/17.
//  Copyright © 2017 nhunghuynhthihong. All rights reserved.
//

import UIKit

let times = ["12AM", "12.5AM", "1AM", "1.5AM", "2AM", "2.5AM", "3AM", "3.5AM", "4AM", "4.5AM", "5AM", "5.5AM", "6AM", "6.5AM", "7AM", "7.5AM", "8AM", "8.5AM", "9AM", "9.5AM", "10AM", "10.5AM", "11AM", "11.5AM", "12PM", "12.5PM", "1PM", "1.5PM", "2PM", "2.5PM", "3PM", "3.5PM", "4PM", "4.5PM", "5PM", "5.5PM", "6PM", "6.5PM", "7PM", "7.5PM", "8PM", "8.5PM", "9PM", "9.5PM", "10PM", "10.5PM","11PM", "11.5PM", "12AM"]
let hours = ["12AM", "1AM", "2AM", "3AM", "4AM", "5AM", "6AM", "7AM", "8AM", "9AM", "10AM", "11AM", "12PM", "1PM", "2PM", "3PM", "4PM", "5PM", "6PM", "7PM", "8PM", "9PM", "10PM", "11PM", "12AM"]
let halfHours = ["12.5AM", "1.5AM", "2.5AM", "3.5AM", "4.5AM", "5.5AM", "6.5AM", "7.5AM", "8.5AM", "9.5AM", "10.5AM", "11.5AM", "12.5PM", "1.5PM", "2.5PM", "3.5PM", "4.5PM", "5.5PM", "6.5PM", "7.5PM", "8.5PM", "9.5PM", "10.5PM", "11.5PM"]
class TVGuideViewController: UIViewController {

    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
        
    fileprivate var request: AnyObject?
    var channels: [Channel]?
    var favoriteChannels: [Int]?
    let userDefaults = UserDefaults.standard
    var currentChannelIndex: Int?
    var currentChannels: [Channel] = []
    var currentHourIndex: Int?
    var channelIDs: String = ""
    var numberIndexs: Int = 10
    var isEventsLoading:Bool = false
    var visibleCurrentCell: IndexPath? {
        for cell in self.collectionView.visibleCells {
            let indexPath = self.collectionView.indexPath(for: cell)
            return indexPath
        }
        
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortSegmentedControl.tintColor = UIColor.electricViolet
        self.title = "TV Guide"
        setCurrentHourIndex()
        collectionView.register(UINib(nibName: "ChannelCell", bundle: nil), forCellWithReuseIdentifier: "ChannelCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        if let favoriteChannels  = userDefaults.array(forKey: "Favorites") {
            self.favoriteChannels = favoriteChannels  as? [Int]
        }
        fetchChannels()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isEventsLoading = false
        if self.channels == nil {
            return
        }
        self.favoriteChannels = []
        for channel in self.channels! {
            if channel.isFavorite {
                self.favoriteChannels?.append(channel.channelId!)
            }
        }
        userDefaults.set(self.favoriteChannels, forKey: "Favorites")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSortAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            channels = channels?.sorted (by: {$0.channelTitle! < $1.channelTitle!})
        } else {
            channels = channels?.sorted (by: {$0.channelStbNumber! < $1.channelStbNumber!})
        }
        collectionView.reloadData()
    }
    func setCurrentHourIndex() {
        let now = Date()
        let secondDateFormatter = DateFormatter()
        secondDateFormatter.dateFormat = "h:mm a"
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minutes = calendar.component(.minute, from: now)
        var currentHour:String?
        if minutes < 30 {
            currentHour = hours[hour]
        } else {
            currentHour = halfHours[hour]
        }
        currentHourIndex = times.index(where: {$0 == currentHour })
    }
    func fetchChannels() {
        let channelsResource = ChannelsResource()
        let channelsRequest = ApiRequest(resource: channelsResource)
        request = channelsRequest
        channels = []
        channelsRequest.load { (channels) in
            guard let channels = channels else {
                return
            }
            self.channels = channels.sorted (by: {$0.channelTitle! < $1.channelTitle!})
            if self.favoriteChannels != nil && (self.favoriteChannels?.count)! > 0 {
                for (index, item) in (self.channels?.enumerated())! {
                    if (self.favoriteChannels?.contains(item.channelId!))! {
                        self.channels?[index].isFavorite = true
                    }
                }
            }
            self.collectionView.reloadData()
            self.currentChannelIndex = 0
            // Fetch first 10 events
            self.numberIndexs = 10
            self.setChannelIDs()
            self.fetchEvents()
        }
    }
    func setChannelIDs() {
        isEventsLoading = true
        self.channelIDs = ""
        let maxNumber = self.numberIndexs
        for (index, currentChannel) in (self.channels?.enumerated())! {
            if currentChannel.events.count > 0 {
                continue
            }
            if index >= maxNumber {
                break
            }
            if index < maxNumber - 10 {
                continue
            }
            self.channelIDs = self.channelIDs + ",\(currentChannel.channelId!)"
        }
        if self.channelIDs.characters.count > 1 {
            self.channelIDs = String(channelIDs.characters.dropFirst())
        }
    }
    func fetchEvents() {
        if channelIDs.characters.count < 1 {
            isEventsLoading = false
            return
        }
        print("fetchEvents \(channelIDs)")
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let periodStart = ("\(dateFormatter.string(from: now.yesterday))" + " 00:00").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let periodEnd = ("\(dateFormatter.string(from: now.tomorrow))" + " 23:59").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        var eventsResource = EventsResource()
        
        eventsResource.methodPath = eventsResource.methodPath + "?channelId=[" + "\(self.channelIDs)" + "]&periodStart=" + periodStart! + "&periodEnd=" + periodEnd!
        let eventsRequest = ApiRequest(resource: eventsResource)
        request = eventsRequest
        var tempEvents:[Event] = []
        eventsRequest.load { (events) in
            guard let events = events else {
                self.isEventsLoading = false
                return
            }
            for event in events {
                if Calendar.current.isDateInToday(event.displayLocalDateTime!) {
                   tempEvents.append(event)
                }
            }
            tempEvents = tempEvents.sorted { $0.displayLocalDateTime! < $1.displayLocalDateTime! }
            
            for (index, channel) in (self.channels?.enumerated())! {
                let channelEvents = tempEvents.filter({$0.channelId == channel.channelId})
                if channelEvents.count > 0 {
                    self.channels?[index].events = channelEvents
                    self.isEventsLoading = false
                    self.collectionView.reloadData()
                }
            }
        }
    }
}
// MARK: - UICollectionViewDataSource
extension TVGuideViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (channels?.count ?? 0)! + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return times.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCell", for: indexPath) as! ChannelCell
        
        if indexPath.section % 2 != 0 {
            cell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.white
        }
        cell.descriptionLabel.text = ""
        cell.bottomRightButton.isHidden = true
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.titleLabel.text = "On Now"
            } else {
                if indexPath.row % 2 != 0 {
                    cell.titleLabel.text = times[indexPath.row - 1]
                } else {
                    cell.titleLabel.text = ""
                }
            }
        } else {
            if indexPath.row == 0 {
                cell.bottomRightButton.tag = indexPath.section - 1
                cell.delegate = self
                cell.titleLabel.text = channels?[indexPath.section - 1].channelTitle
                cell.descriptionLabel.text = "\(indexPath.section - 1)"
                    //channels?[indexPath.section - 1].channelStbNumber
                cell.bottomRightButton.isHidden = false
                cell.setFavorite((channels?[indexPath.section - 1].isFavorite)!)
            } else {
                let channel = channels?[indexPath.section - 1]
                if let currentIndex = channel?.events.index(where: {$0.section! == times[indexPath.row - 1]}) {
                    if let currentEvent = channel?.events[currentIndex] {
                        cell.titleLabel.text = currentEvent.programmeTitle
                        cell.descriptionLabel.text = currentEvent.displayHour
                    }
                } else {
                    cell.titleLabel.text = ""
                }
            }
        }
        if indexPath.row - 1 == currentHourIndex {
            cell.backgroundColor = UIColor(white: 200/255.0, alpha: 1.0)
            if indexPath.section == 0 {
                cell.descriptionLabel.text = "NOW"
            }
        }
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension TVGuideViewController: UICollectionViewDelegate {
   
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint)!
        
        if isEventsLoading {
            return
        } else {
            self.numberIndexs = visibleIndexPath.section + 5
            self.setChannelIDs()
            self.fetchEvents()
        }
        
    }
}
extension TVGuideViewController: ChannelCellDelegate {
    func onFavoriteAction(_ index: Int, isFavorite: Bool) {
        self.channels?[index].isFavorite = isFavorite
    }
}
