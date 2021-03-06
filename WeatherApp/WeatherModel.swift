//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Gleb Kulik on 6/8/18.
//  Copyright © 2018 Sandpiper Software. All rights reserved.
//

import Foundation
import RealmSwift


class WeatherModel: Object {
    
    static let instance = WeatherModel()
    
    @objc dynamic var id: Int = 0
    @objc dynamic var humidity: Int = 0
    @objc dynamic var temp: Int = 0
    @objc dynamic var pressure: Int = 0
    @objc dynamic var location_name: String = ""
    @objc dynamic var wind_deg: Int = 0
    @objc dynamic var wind_speed: Int = 0
    @objc dynamic var condition: Int = 0
    @objc dynamic var weatherConditionImage: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

