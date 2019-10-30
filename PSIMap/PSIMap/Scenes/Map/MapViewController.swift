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
        let annotations: [MKAnnotation] = items.map {
            let annotation = MapAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            annotation.name = $0.name
            annotation.value = $0.psiTwentyFourHourly
            return annotation
        }

        DispatchQueue.main.async { [weak self] in
            self?.showAnnotations(annotations)
            self?.zoomToAnnotations(annotations)
        }
    }

    func showError() {

    }

    func startLoading() {

    }

    func stopLoading() {

    }

    // MARK: Private properties

    private var mapView = MKMapView()

}

extension MapViewController {

    override func loadView() {
        let mainView = UIView(frame: UIScreen.main.bounds)

        mapView.delegate = self
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.fetchPSIData()
    }

}

// MARK: - Private methods

extension MapViewController {

    private func showAnnotations(_ annotations: [MKAnnotation]) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }

    private func zoomToAnnotations(_ annotations: [MKAnnotation]) {
        let mapRect = annotations.reduce(MKMapRect.null) { rect, annotation in
            let newRect = MKMapRect(
                origin: MKMapPoint(annotation.coordinate),
                size: MKMapSize(width: 1, height: 1)
            )
            return rect.union(newRect)
        }
        mapView.setVisibleMapRect(
            mapRect,
            edgePadding: UIEdgeInsets(top: 40, left: 60, bottom: 40, right: 60),
            animated: false
        )
    }

}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let psiAnnotation = annotation as? MapAnnotation else {
            return nil
        }
        let identifier = "PSI"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MapAnnotationView
        if view != nil {
            view?.annotation = psiAnnotation
        } else {
            view = MapAnnotationView(annotation: psiAnnotation, reuseIdentifier: identifier)
        }
        view?.name = psiAnnotation.name
        view?.value = psiAnnotation.value
        view?.frame.size.width = 110
        view?.frame.size.height = view?.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        ).height ?? 0
        return view
    }

}
