//
//  Events.swift
//  AstroChannels
//
//  Created by Candice H on 9/18/17.
//  Copyright © 2017 nhunghuynhthihong. All rights reserved.
//

import Foundation
struct Events {
    
    var events:[Event]?
}
extension Events {
    private enum Keys: String, SerializationKey {
        case events = "getEvents"
    }
    
    init(serialization: Serialization) {
        events = serialization.value(forKey: Keys.events)
    }
}
