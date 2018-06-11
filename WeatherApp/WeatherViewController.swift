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


class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        assignBackground()
        
        DBProvider.getData()
        
        updateUI()
        
        startLocationManagerSession()
        
    }

    
    func startLocationManagerSession() {
        if ReachabilityTest.isConnectedToNetwork() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
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
    
    
    func fetchData(locationData: Dictionary<String, String>) {
        DataFetcher.getData(url: Const.WEATHER_URL, parameters: locationData) {
            returnJSON in
            self.parseData(dataJSON: returnJSON)
        }
    }
    
    
    func parseData(dataJSON: JSON) {
        print(dataJSON)
        do {
            try dbRealm.write({
                WeatherModel.instance.humidity = dataJSON["main"]["humidity"].intValue
                WeatherModel.instance.location_name = dataJSON["name"].stringValue
                WeatherModel.instance.pressure = dataJSON["main"]["pressure"].intValue
                WeatherModel.instance.temp = dataJSON["main"]["temp"].intValue - 273
                WeatherModel.instance.wind_deg = dataJSON["wind"]["deg"].intValue
                WeatherModel.instance.wind_speed = dataJSON["wind"]["speed"].intValue
                WeatherModel.instance.condition = dataJSON["weather"][0]["id"].intValue
                WeatherModel.instance.weatherConditionImage = Converter.updateWeatherConditionImage(condition: WeatherModel.instance.condition)
                dbRealm.add(WeatherModel.instance, update: true)
                print(" Data stored.")
            })
        }
        catch let error {
            print(error)
        }
        
        updateUI()
        
    }
    
    
    func updateUI() {
        locationLabel.text = WeatherModel.instance.location_name
        temperatureLabel.text = "\(WeatherModel.instance.temp)°"
        weatherConditionImage.image = UIImage(named: WeatherModel.instance.weatherConditionImage)
        humidityLabel.text = "Humidity: \(WeatherModel.instance.humidity)%"
        pressureLabel.text = "Pressure: \(WeatherModel.instance.pressure) hPa"
        windLabel.text = "Wind: \(Converter.windDirection(deg: WeatherModel.instance.wind_deg)) \(WeatherModel.instance.wind_speed) mps "
    }
    
    
    func assignBackground(){
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "background")
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

