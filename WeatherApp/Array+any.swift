//
//  Array+any.swift
//  WeatherApp
//
//  Created by Sebastian Osiński on 19.11.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

extension Array {
    
    /**
     Checks if any of array's elements satisfies given predicate.
     
     - returns: True if any of the elements satisfies the predicate, false otherwise.
     */
    func any(predicate: (Element) -> Bool) -> Bool {
        for element in self {
            if predicate(element) {
                return true
            }
        }
        return false
    }
}