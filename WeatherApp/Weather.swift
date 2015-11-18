//
//  Weather.swift
//  WeatherApp
//
//  Created by Sebastian Osiński on 18.11.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import SwiftyJSON

class Weather: CustomDebugStringConvertible {
    
    var name: String
    var condition: String?
    var wind: String?
    var temperature: Int?
    var feelsLike: Int?
    var lastUpdateTimeStamp: Int
    var lastUpdate: NSDate?
    
    
    init(json: JSON) {
        name = json["_name"].stringValue
        
        if let _ = json["_weatherCondition"].string {
            condition = json["_weatherCondition"].stringValue
        }
        if let _ = json["_weatherWind"].string {
            wind = json["_weatherWind"].stringValue
        }
        if let _ = json["_weatherTemp"].string {
            temperature = json["_weatherTemp"].intValue
        }
        if let _ = json["_weatherFeelsLike"].string {
            feelsLike = json["_weatherFeelsLike"].intValue
        }
        
        lastUpdateTimeStamp = json["_weatherLastUpdated"].intValue
        
        if lastUpdateTimeStamp > 0 {
            lastUpdate = NSDate(timeIntervalSince1970: Double(lastUpdateTimeStamp))
        }
    }
    
    var debugDescription: String {
        return "District Name: \(name)\n" +
                "Weather condition: \(condition)\n" +
                "Wind: \(wind)\n" +
                "Temperature: \(temperature)\n" +
                "Feels like: \(feelsLike)\n" +
                "Last updated: \(lastUpdate)"
    }
    
}