//
//  ViewControllerTests.swift
//  WeatherAppTests
//
//  Created by Gleb Kulik on 6/10/18.
//  Copyright © 2018 Sandpiper Software. All rights reserved.
//

import XCTest
import Alamofire
import RealmSwift
import SwiftyJSON

@testable import WeatherApp


class WeatherViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetData() {
        let ex = expectation(description: "Expecting a JSON data not nil")
        let url = Const.WEATHER_URL
        let parameters = ["lat" : "50", "lon" : "50", "appid" : Const.APP_ID]
            
        DataFetcher.getData(url: url, parameters: parameters) {
            returnJSON in
            XCTAssertNotNil(returnJSON)
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
