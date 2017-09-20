//
//  Channel.swift
//  AstroChannels
//
//  Created by Candice H on 9/16/17.
//  Copyright © 2017 nhunghuynhthihong. All rights reserved.
//

import Foundation

struct Channel {
    
    var channelId: Int?
    var channelTitle: String?
    var channelStbNumber: String?
    var channelDescription: String?
    var channelCategory: String?
    var isFavorite: Bool = false
    var events: [Event] = []
}
extension Channel {
    private enum Keys: String, SerializationKey {
        case channelId = "channelId"
        case channelTitle = "channelTitle"
        case channelStbNumber = "channelStbNumber"
        case channelDescription
        case channelCategory
    }
    
    init(serialization: Serialization) {
        channelId = serialization.value(forKey: Keys.channelId)
        channelTitle = serialization.value(forKey: Keys.channelTitle)
        channelStbNumber = serialization.value(forKey: Keys.channelStbNumber)
    }
}
