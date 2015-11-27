//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Sebastian Osiński on 18.11.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import Alamofire
import SwiftyJSON

class WeatherService {
    
    static let sourceURL = "http://dnu5embx6omws.cloudfront.net/venues/weather.json"
    
    func getWeather(completionHandler: ([Weather]?, NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(NSURL(string: WeatherService.sourceURL)!) { (data, response, error) -> Void in
            if let data = data {
                let json = JSON(data: data)
                let jsonWeathers = json["data"].arrayValue
                
                let weathers = jsonWeathers.filter{ $0["_country"]["_name"].stringValue == "Australia" }
                    .map { Weather(json: $0) }
                
                completionHandler(weathers, nil)
            } else {
                completionHandler(nil, error)
            }
        }
        
        task.resume()
    }
}