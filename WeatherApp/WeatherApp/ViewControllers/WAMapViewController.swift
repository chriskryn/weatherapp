//
//  WAMapViewController.swift
//  WeatherApp
//
//  Created by Krzysztof Kryniecki on 11/3/17.
//  Copyright © 2017 Krzysztof Kryniecki. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftMessages

final class WAMapViewController: UIViewController {
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet final private weak var mapView: MKMapView!
    final private var launch = false
    final private let kWAshowDetailScreen = "kWAShowDetails"
    final private var selectedCoordinates: CLLocationCoordinate2D?
    final private var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tapGestureRecognizer.numberOfTapsRequired = 2
        self.tapGestureRecognizer.addTarget(self, action: #selector(self.didDoupleTapedMap))
        self.tapGestureRecognizer.delegate = self
        self.mapView.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            self.mapView.showsUserLocation = true
        default:
            self.locationManager.requestWhenInUseAuthorization()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc final private func didDoupleTapedMap(sender: UIGestureRecognizer) {
        guard sender.state != UIGestureRecognizerState.began else { return }
        let touchLocation = sender.location(in: self.mapView)
        self.selectedCoordinates = self.mapView.convert(touchLocation, toCoordinateFrom: self.mapView)
        self.performSegue(withIdentifier: self.kWAshowDetailScreen, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.kWAshowDetailScreen,
            let detailController = segue.destination as? WADetailScreenController {
            detailController.coordinates = self.selectedCoordinates
        }
    }
}

extension WAMapViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
        ) -> Bool {
        return true
    }
}

extension WAMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let coordinates = mapView.userLocation.location?.coordinate, self.launch == false {
            self.launch = true
            self.mapView.setCenter(coordinates, animated: true)
        }
    }

    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        func showError() {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.error)
            view.configureContent(title: "Error", body: "Failed showing user location")
            SwiftMessages.show(view: view)
        }
    }
}

extension WAMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.mapView.showsUserLocation = true
    }
}
