//
//  WAWeatherGetter.swift
//  WeatherApp
//
//  Created by Krzysztof Kryniecki on 11/3/17.
//  Copyright © 2017 Krzysztof Kryniecki. All rights reserved.
//

import Foundation
import CoreLocation

enum WAMetricType: String {
    case celsius    = "metric"
    case fahrenheit = "imperial"
}

struct WAWeatherGetter {

    static func getWeather(
        coordinates: CLLocationCoordinate2D,
        metric: WAMetricType = .celsius,
        completionHandler: @escaping ((WACondition?, Error?) -> Void)
    ) {
        let path = "lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&units=\(metric.rawValue)"
        WANetworking.performAuthenticatedRequest(path: path) { (response, error) in
            if response != nil, let json = response {
                completionHandler(WACondition(response: json), nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
}
