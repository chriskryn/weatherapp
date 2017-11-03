//
//  WANetworking.swift
//  WeatherApp
//
//  Created by Krzysztof Kryniecki on 11/3/17.
//  Copyright © 2017 Krzysztof Kryniecki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias WAApiResponse = ((_ response: JSON?, _ error: Error?) -> Void)

struct WANetworking {

    static func performAuthenticatedRequest(
        path: String,
        completionHandler: @escaping WAApiResponse
    ) {

        let url = WASettings.apiAddress + "?APPID=\(WASettings.apiOWMKey)&&" + path
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                DispatchQueue.main.async {
                    completionHandler(JSON(value), nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
    }
}
