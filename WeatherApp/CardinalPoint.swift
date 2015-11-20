//
//  CardinalPoint.swift
//  WeatherApp
//
//  Created by Sebastian Osiński on 20.11.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

enum CardinalPoint: Int {
    
    case N = 0, NNE, NE, ENE, E, ESE, SE, SSE, S, SSW, SW, WSW, W, WNW, NW, NNW
    
    init?(withString string: String) {
        switch string {
        case "North": self = N
        case "NNE": self = NNE
        case "NE": self = NE
        case "ENE": self = ENE
        case "East": self = E
        case "ESE": self = ESE
        case "SE": self = SE
        case "SSE": self = SSE
        case "South": self = S
        case "SSW": self = SSW
        case "SW": self = SW
        case "WSW": self = WSW
        case "West": self = W
        case "WNW": self = WNW
        case "NW": self = NW
        case "NNW": self = NNW
        default: return nil
        }
    }
    
    
}