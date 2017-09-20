//
//  ChannelsResource.swift
//  AstroChannels
//
//  Created by Candice H on 9/17/17.
//  Copyright © 2017 nhunghuynhthihong. All rights reserved.
//

import Foundation
struct ChannelsResource: ApiResource {
    let methodPath = "getChannels"
    
    func makeModel(serialization: Serialization) -> Channel {
        return Channel(serialization: serialization)
    }
}
