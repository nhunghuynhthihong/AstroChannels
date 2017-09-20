//
//  ChannelsViewController.swift
//  AstroChannels
//
//  Created by Candice H on 9/15/17.
//  Copyright © 2017 nhunghuynhthihong. All rights reserved.
//

import UIKit

class ChannelsViewController: UIViewController {
    
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var request: AnyObject?
    var channels: [Channel]?
    var favoriteChannels: [Int]?
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortSegmentedControl.tintColor = UIColor.electricViolet
        self.title = "Channels"
        collectionView.register(UINib(nibName: "ChannelCell", bundle: nil), forCellWithReuseIdentifier: "ChannelCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        if let favoriteChannels  = userDefaults.array(forKey: "Favorites") {
            self.favoriteChannels = favoriteChannels  as? [Int]
        }
        
        fetchChannels()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    @IBAction func onSortAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            channels = channels?.sorted (by: {$0.channelTitle! < $1.channelTitle!})
        } else {
            channels = channels?.sorted (by: {$0.channelStbNumber! < $1.channelStbNumber!})
        }
        collectionView.reloadData()
    }
    
    func fetchChannels() {
        let channelsResource = ChannelsResource()
        let channelsRequest = ApiRequest(resource: channelsResource)
        request = channelsRequest
        channels = []
        channelsRequest.load { (channels) in
            self.channels = channels?.sorted (by: {$0.channelTitle! < $1.channelTitle!})
            if self.favoriteChannels != nil && (self.favoriteChannels?.count)! > 0 {
                for (index, item) in (self.channels?.enumerated())! {
                    if (self.favoriteChannels?.contains(item.channelId!))! {
                        self.channels?[index].isFavorite = true
                    }
                }
            }
            self.collectionView.reloadData()
        }
    }
}
extension ChannelsViewController: UICollectionViewDelegate {
    
}
extension ChannelsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.channels?.count ?? 0)!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCell", for: indexPath) as! ChannelCell
        let channel = self.channels?[indexPath.row]
        if indexPath.row % 2 != 0 {
            cell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.white
        }
        cell.bottomRightButton.tag = indexPath.row
        cell.delegate = self
        cell.titleLabel.text = channel?.channelTitle
        cell.descriptionLabel.text = channel?.channelStbNumber
        cell.setFavorite((channel?.isFavorite)!)
        return cell
    }
}
extension ChannelsViewController: ChannelCellDelegate {
    func onFavoriteAction(_ index: Int, isFavorite: Bool) {
        self.channels?[index].isFavorite = isFavorite
    }
}
