//
//  MapViewController.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 21/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet private var mapView: MKMapView!

    var city: City!

    override func viewDidLoad() {
        super.viewDidLoad()

        let pin = MKPointAnnotation()
        pin.title = city.name
        pin.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(city.coord.lat),
                                                longitude: CLLocationDegrees(city.coord.lon))
        mapView.addAnnotation(pin)

        mapView.centerCoordinate = pin.coordinate
    }

    @IBAction private func close() {
        dismiss(animated: true, completion: nil)
    }

}
