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
    var windDirection: String?
    var windSpeed: Double?
    var temperatureInC: Int?
    var feelsLikeInC: Int?
    var lastUpdateTimeStamp: Int
    var lastUpdate: NSDate?
    
    var temperatureInF: Int? {
        guard let temperatureInC = temperatureInC else {
            return nil
        }
        return Int(round(Double(temperatureInC) * 1.8 + 32.0))
    }
    
    var feelsLikeInF: Int? {
        guard let feelsLikeInC = feelsLikeInC else {
            return nil
        }
        return Int(round(Double(feelsLikeInC) * 1.8 + 32.0))
    }
    
    init(json: JSON) {
        name = json["_name"].stringValue
        
        if let _ = json["_weatherCondition"].string {
            condition = json["_weatherCondition"].stringValue
        }
        if let _ = json["_weatherWind"].string {
            wind = json["_weatherWind"].stringValue
            
            let temp = wind!.stringByReplacingOccurrencesOfString("Wind: ", withString: "")
            let windComponents = temp.componentsSeparatedByString(" at ")
            windDirection = windComponents[0]
            windSpeed = Double(windComponents[1].stringByReplacingOccurrencesOfString("kph", withString: ""))
        }
        if let _ = json["_weatherTemp"].string {
            temperatureInC = json["_weatherTemp"].intValue
        }
        if let _ = json["_weatherFeelsLike"].string {
            feelsLikeInC = json["_weatherFeelsLike"].intValue
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
                "Temperature in C: \(temperatureInC)\n" +
                "Feels like in C: \(feelsLikeInC)\n" +
                "Last updated: \(lastUpdate)"
    }
    
}