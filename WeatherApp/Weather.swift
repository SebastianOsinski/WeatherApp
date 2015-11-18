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
    var condition: String
    var wind: String
    var humidity: String
    var temperature: Int
    var feelsLike: Int
    var lastUpdated: NSDate?
    
    
    init(json: JSON) {
        name = json["_name"].stringValue
        condition = json["_weatherCondition"].stringValue
        wind = json["_weatherWind"].stringValue
        humidity = json["_weatherHumidity"].stringValue
        temperature = json["_weatherTemp"].intValue
        feelsLike = json["_weatherFeelsLike"].intValue
        lastUpdated = NSDate(timeIntervalSince1970: json["_weatherLastUpdated"].doubleValue)
    }
    
    var debugDescription: String {
        return "District Name: \(name)\n" +
                "Weather condition: \(condition)\n" +
                "Wind: \(wind)\n" +
                "Humidity: \(humidity)\n" +
                "Temperature: \(temperature)\n" +
                "Feels like: \(feelsLike)\n" +
                "Last updated: \(lastUpdated)"
    }
    
}