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

final class WAMapViewController: UIViewController {
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var mapView: MKMapView!

    final private let kWAshowDetailScreen = "kWAShowDetails"
    final private var selectedCoordinates: CLLocationCoordinate2D?
    final private func setupErrors() {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        CLLocationManager().requestWhenInUseAuthorization()
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.tapGestureRecognizer.numberOfTapsRequired = 2
        self.tapGestureRecognizer.addTarget(self, action: #selector(self.didDoupleTapedMap))
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

extension WAMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let coordinates = mapView.userLocation.location?.coordinate {
            self.mapView.setCenter(coordinates, animated: true)
        }
    }

    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        print("Error \(error.localizedDescription)")
    }
}