//
//  Concerter.swift
//  WeatherApp
//
//  Created by Gleb Kulik on 6/10/18.
//  Copyright © 2018 Sandpiper Software. All rights reserved.
//

import Foundation


class Converter {
    
    static func updateWeatherConditionImage(condition: Int) -> String {
        switch (condition) {
            
        case 200...232:
            return "thunder"
        case 300...622:
            return "rain"
        case 800:
            return "sun"
        default:
            return "cloud"
            
        }
    }
    
    static func windDirection(deg: Int) -> String {
        switch deg {
        case 0...45:
            return "N"
        case 46...135:
            return "W"
        case 136...225:
            return "S"
        case 226...315:
            return "E"
        case 316...360:
            return "N"
        default:
            return "Incorrect Value"
        }
    }
}
