//
//  DataFetcher.swift
//  WeatherApp
//
//  Created by Gleb Kulik on 6/8/18.
//  Copyright © 2018 Sandpiper Software. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class DataFetcher {
    
    static func getData(url: String, parameters: [String: String], completionClosure: @escaping (JSON) -> ()) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                completionClosure(JSON(response.result.value!))
            }
            else {
                print("Error \(String(describing: response.result.error))")
            }
        }
        
    }
    
}
