//
//  Event.swift
//  AstroChannels
//
//  Created by Candice H on 9/18/17.
//  Copyright © 2017 nhunghuynhthihong. All rights reserved.
//

import Foundation
struct Event {
    
    var eventID: Double?
    var channelId: Int?
    var channelStbNumber: String?
    var channelTitle: String?
    var displayDateTimeUtc: String?
    var displayDateTime: String?
    var displayDuration: String?
    var programmeTitle: String?
    
    var displayHour: String?
    var displayLocalDateTime: Date?
    var section: String?
}
extension Event {
    private enum Keys: String, SerializationKey {
        case eventID = "eventID"
        case channelId = "channelId"
        case channelStbNumber = "channelStbNumber"
        case channelTitle = "channelTitle"
        case displayDateTimeUtc = "displayDateTimeUtc"
        case displayDateTime = "displayDateTime"
        case displayDuration = "displayDuration"
        case programmeTitle
    }
    
    init(serialization: Serialization) {
        eventID = serialization.value(forKey: Keys.eventID)
        channelId = serialization.value(forKey: Keys.channelId)
        channelStbNumber = serialization.value(forKey: Keys.channelStbNumber)
        channelTitle = serialization.value(forKey: Keys.channelTitle)
        displayDateTimeUtc = serialization.value(forKey: Keys.displayDateTimeUtc)
        displayDateTime = serialization.value(forKey: Keys.displayDateTime)
        displayDuration = serialization.value(forKey: Keys.displayDuration)
        programmeTitle = serialization.value(forKey: Keys.programmeTitle)
        
        if let dateStringFromServer = displayDateTimeUtc {
            
            let dateFormatter =  DateFormatter()
            displayLocalDateTime = dateFormatter.date(fromSwapiString: dateStringFromServer)

            let secondDateFormatter = DateFormatter()
            secondDateFormatter.dateFormat = "h:mm a"
            displayHour = secondDateFormatter.string(from: displayLocalDateTime!)

            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: displayLocalDateTime!)
            let minutes = calendar.component(.minute, from: displayLocalDateTime!)
            if minutes < 30 {
                section = hours[hour]
            } else {
                section = halfHours[hour]
            }
            
        }
    }
}
extension DateFormatter {
    func date(fromSwapiString dateString: String) -> Date? {
        self.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
        self.timeZone = TimeZone(abbreviation: "UTC")
        self.locale = Locale.current
        return self.date(from: dateString)
    }
}
extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
}
