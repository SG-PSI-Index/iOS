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
        displayedItems = items

        DispatchQueue.main.async { [weak self] in
            let tabIndex = self?.mainContainerView.tabView.selectedSegmentIndex ?? 0
            self?.showAnnotationsWithItems(items, tabIndex: tabIndex)
        }
    }

    func showAirQualitySummary(
        airQuality: MapPSIAirQuality,
        outdoorActivityAdvise: MapOutdoorActivityAdvise
    ) {
        DispatchQueue.main.async { [weak self] in
            let airQualityView = ListItemView()
            airQualityView.title = "Air Quality Forecast"
            airQualityView.subtitle = "(24h PSI)"
            airQualityView.rightDetails = airQuality.indicatorText
            airQualityView.rightDetailsColor = airQuality.indicatorColor
            let outdoorAdviseView = ListItemView()
            outdoorAdviseView.title = "Health Advisory"
            outdoorAdviseView.subtitle = "Outdoor activity (Healthy person)"
            outdoorAdviseView.rightDetails = outdoorActivityAdvise.description
            self?.mainContainerView.additionalViews = [airQualityView, outdoorAdviseView]
        }
    }

    func showRefreshTime(_ refreshTimeText: String) {
        DispatchQueue.main.async { [weak self] in
            self?.mainContainerView.refreshTimeLabel.text = "Last updated \(refreshTimeText)"
        }
    }

    func showError() {

    }

    func startLoading() {
        DispatchQueue.main.async {
            self.mainContainerView.refreshControl?.beginRefreshing()
            self.mainContainerView.isUserInteractionEnabled = false
        }
    }

    func stopLoading() {
        DispatchQueue.main.async {
            self.mainContainerView.refreshControl?.endRefreshing()
            self.mainContainerView.isUserInteractionEnabled = true
        }
    }

    // MARK: Private properties

    private let mainContainerView = MapDetailsView()

    private var displayedItems = [MapPSIIndexItem]()

}

extension MapViewController {

    override func loadView() {
        let mainView = UIView(frame: UIScreen.main.bounds)
        mainView.backgroundColor = .black
        mainView.tintColor = .lightGray

        mainContainerView.mapView.delegate = self
        mainContainerView.refreshControl = UIRefreshControl()
        mainContainerView.refreshControl?.addTarget(
            self,
            action: #selector(performRefresh),
            for: .valueChanged
        )
        mainContainerView.tabView.addTarget(
            self,
            action: #selector(selectTab),
            for: .valueChanged
        )
        mainContainerView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(mainContainerView)

        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            mainView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
            mainView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor)
        ])

        if #available(iOS 13, *) {
            mainView.overrideUserInterfaceStyle = .dark
        }

        view = mainView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.fetchPSIData()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

// MARK: - Private methods

extension MapViewController {

    private func showAnnotations(_ annotations: [MKAnnotation]) {
        mainContainerView.mapView.removeAnnotations(mainContainerView.mapView.annotations)
        mainContainerView.mapView.addAnnotations(annotations)
    }

    private func zoomToAnnotations(_ annotations: [MKAnnotation]) {
        let mapRect = annotations.reduce(MKMapRect.null) { rect, annotation in
            let newRect = MKMapRect(
                origin: MKMapPoint(annotation.coordinate),
                size: MKMapSize(width: 1, height: 1)
            )
            return rect.union(newRect)
        }
        let horizontalPadding = mainContainerView.mapView.frame.width * 0.3 / 2 + 8
        mainContainerView.mapView.setVisibleMapRect(
            mapRect,
            edgePadding: UIEdgeInsets(top: 40, left: horizontalPadding, bottom: 40, right: horizontalPadding),
            animated: false
        )
    }

    private func showAnnotationsWithItems(_ items: [MapPSIIndexItem], tabIndex: Int) {
        let annotations: [MKAnnotation] = items.map {
            let annotation = MapAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            annotation.name = $0.name
            switch tabIndex {
            case 0:
                annotation.value = String(format: "%.0f", $0.psiTwentyFourHourly)
                annotation.valueColor = $0.psiAirQuality.indicatorColor
            case 1:
                annotation.value = String(format: "%.0f", $0.pm25Hourly)
            default:
                break
            }
            return annotation
        }

        showAnnotations(annotations)
        zoomToAnnotations(annotations)
    }

    @objc private func performRefresh() {
        interactor?.fetchPSIData()
    }

    @objc private func selectTab(_ segmentedControl: UISegmentedControl) {
        showAnnotationsWithItems(displayedItems, tabIndex: segmentedControl.selectedSegmentIndex)
    }

}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "PSI"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MapAnnotationView
        if view != nil {
            view?.annotation = annotation
        } else {
            view = MapAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        view?.frame.size.width = mapView.frame.width * 0.3
        view?.frame.size.height = view?.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        ).height ?? 0
        return view
    }

}

private extension MapPSIAirQuality {

    var indicatorColor: UIColor {
        switch self {
        case .good:
            return .systemGreen
        case .moderate:
            return .systemBlue
        case .unhealthy:
            return .systemYellow
        case .veryUnhealthy:
            return .systemOrange
        case .hazardous:
            return .systemRed
        }
    }

    var indicatorText: String {
        switch self {
        case .good:
            return "Good"
        case .moderate:
            return "Moderate"
        case .unhealthy:
            return "Unhealthy"
        case .veryUnhealthy:
            return "Very unhealthy"
        case .hazardous:
            return "Hazardous"
        }
    }

}

private extension MapOutdoorActivityAdvise {

    var description: String {
        switch self {
        case .normal:
            return "Normal"
        case .reduceProlonged:
            return "Reduce Prolonged"
        case .avoid:
            return "Avoid"
        case .minimise:
            return "Minimise"
        }
    }

}
