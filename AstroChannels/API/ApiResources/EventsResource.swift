//
//  EventsResource.swift
//  AstroChannels
//
//  Created by Candice H on 9/19/17.
//  Copyright © 2017 nhunghuynhthihong. All rights reserved.
//

import Foundation
struct EventsResource: ApiResource {
    var methodPath = "getEvents"
    
    func makeModel(serialization: Serialization) -> Event {
        return Event(serialization: serialization)
    }
}
