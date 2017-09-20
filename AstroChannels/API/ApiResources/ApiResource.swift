//
//  ApiResource.swift
//  AstroChannels
//
//  Created by Candice H on 9/17/17.
//  Copyright © 2017 nhunghuynhthihong. All rights reserved.
//

import Foundation
protocol ApiResource {
    associatedtype Model
    var methodPath: String {get}
    func makeModel(serialization: Serialization) -> Model
}
extension ApiResource {
    var url: URL {
        let baseUrl = "http://ams-api.astro.com.my/ams/v3/"
        let url = baseUrl + methodPath
        
        return URL(string: url)!
    }
    
    func makeModel(data: Data) -> [Model]? {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
            return nil
        }
        guard let jsonSerialization = json as? Serialization else {
            return nil
        }
        let wrapper = ApiWrapper(serialization: jsonSerialization)
        if methodPath == "getChannels" {
            return wrapper.channel.map(makeModel(serialization: ))
        }
        return wrapper.events.map(makeModel(serialization: ))
    }
}
