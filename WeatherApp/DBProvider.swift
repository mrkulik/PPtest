//
//  DBProvider.swift
//  WeatherApp
//
//  Created by Gleb Kulik on 6/9/18.
//  Copyright © 2018 Sandpiper Software. All rights reserved.
//

import Foundation
import RealmSwift

class DBProvider {
    
    static func getData() {
        let data = dbRealm.object(ofType: WeatherModel.self, forPrimaryKey: WeatherModel.instance.id)
        if data != nil {
            WeatherModel.instance.humidity = (data?.humidity)!
            WeatherModel.instance.location_name = (data?.location_name)!
            WeatherModel.instance.pressure = (data?.pressure)!
            WeatherModel.instance.temp = (data?.temp)!
            WeatherModel.instance.wind_deg = (data?.wind_deg)!
            WeatherModel.instance.wind_speed = (data?.wind_speed)!
            WeatherModel.instance.weatherConditionImage = (data?.weatherConditionImage)!
        }
    }

}
