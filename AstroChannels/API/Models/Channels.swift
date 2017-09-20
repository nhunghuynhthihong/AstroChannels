//
//  Channels.swift
//  AstroChannels
//
//  Created by Candice H on 9/17/17.
//  Copyright © 2017 nhunghuynhthihong. All rights reserved.
//

import Foundation
struct Channels {
    
    var channels:[Channel]?
}
extension Channels {
    private enum Keys: String, SerializationKey {
        case channels = "channel"
    }
    
    init(serialization: Serialization) {
        channels = serialization.value(forKey: Keys.channels)
    }
}
