//
//  ViewController.swift
//  WeatherApp
//
//  Created by Gleb Kulik on 6/8/18.
//  Copyright © 2018 Sandpiper Software. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import RealmSwift


class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ReachabilityTest.isConnectedToNetwork() {
            print("Internet connection available")
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
        else {
            print("No Internet connection available")
            DBProvider.getData()
            updateUI()
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            let locationData : [String : String] = ["lat" : String(location.coordinate.latitude), "lon" : String(location.coordinate.longitude), "appid" : Const.APP_ID]
            fetchData(locationData: locationData)
        }
    }
    
    
    private func fetchData(locationData: Dictionary<String, String>) {
        DataFetcher.getData(url: Const.WEATHER_URL, parameters: locationData) {
            returnJSON in
            self.parseData(dataJSON: returnJSON)
        }
    }
    
    
    private func parseData(dataJSON: JSON) {
        print(dataJSON)
        do {
            try dbRealm.write({
                WeatherModel.instance.humidity = dataJSON["main"]["humidity"].intValue
                WeatherModel.instance.location_name = dataJSON["name"].stringValue
                WeatherModel.instance.pressure = dataJSON["main"]["pressure"].intValue
                WeatherModel.instance.temp = dataJSON["main"]["temp"].intValue - 273
                WeatherModel.instance.temp_max = dataJSON["main"]["temp_max"].intValue - 273
                WeatherModel.instance.temp_min = dataJSON["main"]["temp_min"].intValue - 273
                WeatherModel.instance.visibility = dataJSON["visibility"].intValue / 1000
                WeatherModel.instance.wind_deg = dataJSON["wind"]["deg"].intValue
                WeatherModel.instance.wind_speed = dataJSON["wind"]["speed"].intValue
                WeatherModel.instance.sunrise = dataJSON["sys"]["sunrise"].intValue
                WeatherModel.instance.sunset = dataJSON["sys"]["sunset"].intValue
                dbRealm.add(WeatherModel.instance, update: true)
                print(" Data stored.")
            })
        }
        catch let error {
            print(error)
        }
        
        updateUI()
        
    }
    
    
    private func updateUI() {
        locationLabel.text = WeatherModel.instance.location_name
        temperatureLabel.text = "\(WeatherModel.instance.temp)°"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

