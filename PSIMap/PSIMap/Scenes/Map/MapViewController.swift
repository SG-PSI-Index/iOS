//
//  MapViewController.swift
//  PSIMap
//
//  Created by Kevin Lo on 28/10/2019.
//  Copyright © 2019 Zuhlke Engineering HK Limited. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MapViewProtocol {

    var interactor: MapInteractorProtocol?

    func showPSIIndex(with items: [MapPSIIndexItem]) {

    }

    func showError() {

    }

    func startLoading() {

    }

    func stopLoading() {

    }

    private var mapView = MKMapView()

}

extension MapViewController {

    override func loadView() {
        let mainView = UIView(frame: UIScreen.main.bounds)

        mapView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(mapView)
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            mainView.topAnchor.constraint(equalTo: mapView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor)
        ])

        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        focusMapToSingapore()
    }

}

extension MapViewController {

    private func focusMapToSingapore() {
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 1.35, longitude: 103.8),
            latitudinalMeters: 60000,
            longitudinalMeters: 60000
        )
        mapView.setRegion(region, animated: false)
    }

}
