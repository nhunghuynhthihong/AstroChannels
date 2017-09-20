//
//  ApiWrapper.swift
//  AstroChannels
//
//  Created by Candice H on 9/16/17.
//  Copyright © 2017 nhunghuynhthihong. All rights reserved.
//

import Foundation
struct ApiWrapper {
    let items: [Serialization]
    let responseCode: Int
    let responseMessage: String
    let channel: [Serialization]
    let events: [Serialization]
}
extension ApiWrapper {
    private enum Keys: String, SerializationKey {
        case items
        case responseCode = "status"
        case responseMessage = "message"
        case channel = "channel"
        case events = "getevent"
    }
    init(serialization: Serialization) {
        items = serialization.value(forKey: Keys.items) ?? []
        responseCode = serialization.value(forKey: Keys.responseCode) ?? 0
        responseMessage = serialization.value(forKey: Keys.responseMessage) ?? ""
        channel = serialization.value(forKey: Keys.channel) ?? []
        events = serialization.value(forKey: Keys.events) ?? []
    }
}
