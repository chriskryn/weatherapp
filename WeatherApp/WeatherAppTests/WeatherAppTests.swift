//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Krzysztof Kryniecki on 11/3/17.
//  Copyright © 2017 Krzysztof Kryniecki. All rights reserved.
//

import XCTest
import CoreLocation
import Alamofire
import SwiftyJSON

@testable import WeatherApp

class WeatherAppTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testApiCall() {
        let expectation = self.expectation(description: "Call Expextation")
        let location = CLLocationCoordinate2D(latitude: 52.237049, longitude: 21.017532)
        WAWeatherGetter.getWeather(coordinates: location) { (response, error) in
            if response != nil {
                print("Response \(String(describing: response))")
                expectation.fulfill()
            } else {
                XCTFail("Error \(String(describing: error?.localizedDescription))")
            }
        }
        self.waitForExpectations(timeout: 5) { (error) in
            if error != nil {
                XCTAssert(false)
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
