//
//  WACondition.swift
//  WeatherApp
//
//  Created by Krzysztof Kryniecki on 11/3/17.
//  Copyright © 2017 Krzysztof Kryniecki. All rights reserved.
//

import Foundation
import SwiftyJSON

struct WACondition {
    let date: Date
    let humidity: Float
    let temperature: Int
    let tempHigh: Int
    let tempLow: Int
    let locationName: String
    let icon: String

    init(response: JSON) {
        var iconMap = [
            "01d": "weather-clear",
            "02d": "weather-few",
            "03d": "weather-few",
            "04d": "weather-broken",
            "09d": "weather-shower",
            "10d": "weather-rain",
            "11d": "weather-tstorm",
            "13d": "weather-snow",
            "50d": "weather-mist",
            "01n": "weather-moon",
            "02n": "weather-few-night",
            "03n": "weather-few-night",
            "04n": "weather-broken",
            "09n": "weather-shower",
            "10n": "weather-rain-night",
            "11n": "weather-tstorm",
            "13n": "weather-snow",
            "50n": "weather-mist"
        ]
        date =  Date(timeIntervalSince1970: TimeInterval(response["dt"].intValue))
        locationName = response["name"].stringValue
        humidity = response["main"]["humidity"].floatValue
        temperature = Int(response["main"]["temp"].floatValue)
        tempHigh = Int(response["main"]["temp_max"].floatValue)
        tempLow = Int(response["main"]["temp_min"].floatValue)
        if let index = response["weather"].array?.first?["icon"].stringValue, let value = iconMap[index] {
            icon = value
        } else {
            icon = ""
        }
    }
}
