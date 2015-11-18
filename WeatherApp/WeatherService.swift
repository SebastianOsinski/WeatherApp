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
    
    func getWeather(completionHandler: ([Weather]?) -> Void) {
        Alamofire.request(.GET, WeatherService.sourceURL)
            .responseJSON { response in
                
                var weathers: [Weather]?
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let jsonWeathers = json["data"].arrayValue
                        
                        weathers = jsonWeathers.filter{ $0["_country"]["_name"].stringValue == "Australia" }
                                                .map { Weather(json: $0) }
                    }
                case .Failure(let error):
                    print(error)
                }
            
                completionHandler(weathers)
        }
    }
}