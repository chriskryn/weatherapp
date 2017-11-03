//
//  WADetailScreenController.swift
//  WeatherApp
//
//  Created by Krzysztof Kryniecki on 11/3/17.
//  Copyright © 2017 Krzysztof Kryniecki. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftMessages

final class WADetailScreenController: UIViewController {
    var coordinates: CLLocationCoordinate2D?

    @IBOutlet private weak var weatherIcon: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var hiLoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityLabel.text = "Loading..."
        self.temperatureLabel.isHidden = true
        self.weatherIcon.isHidden = true
        if let cords = coordinates {
            WAWeatherGetter.getWeather(coordinates: cords) {[weak self] (condition, _) in
                if let weatherCondition = condition {
                    self?.updateWeatherView(condition: weatherCondition)
                } else {
                    self?.showError()
                }
            }
        }
    }

    final private func updateWeatherView(condition: WACondition) {
        let formatter = MeasurementFormatter()
        let measurement = Measurement(value: Double(condition.temperature), unit: UnitTemperature.celsius)
        self.temperatureLabel.isHidden = false
        self.weatherIcon.isHidden = false
        self.weatherIcon.image = UIImage(named: condition.icon)
        self.cityLabel.text = condition.locationName
        self.temperatureLabel.text = "\(formatter.string(from: measurement))"
        let high = Measurement(value: Double(condition.tempHigh), unit: UnitTemperature.celsius)
        let low = Measurement(value: Double(condition.tempLow), unit: UnitTemperature.celsius)
        self.hiLoLabel.text = "\(formatter.string(from: high)) / \(formatter.string(from: low))"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    final private func showError() {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.error)
        view.configureContent(title: "Error", body: "Network Request failed.")
        SwiftMessages.show(view: view)
    }
}
