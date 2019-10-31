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
            let tabIndex = self?.detailView.tabView.selectedSegmentIndex ?? 0
            self?.showAnnotationsWithItems(items, tabIndex: tabIndex)
            self?.detailView.isHidden = false
            self?.errorView.isHidden = true
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
            self?.detailView.additionalViews = [airQualityView, outdoorAdviseView]
        }
    }

    func showRefreshTime(_ refreshTimeText: String) {
        DispatchQueue.main.async { [weak self] in
            self?.mainContainerView.refreshTimeLabel.text = "Last updated \(refreshTimeText)"
        }
    }

    func showError() {
        DispatchQueue.main.async { [weak self] in
            self?.errorView.isHidden = false
            self?.detailView.isHidden = true
        }
    }

    func startLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.detailView.refreshControl?.beginRefreshing()
            self?.detailView.isUserInteractionEnabled = false
            self?.errorView.startLoading()
        }
    }

    func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.detailView.refreshControl?.endRefreshing()
            self?.detailView.isUserInteractionEnabled = true
            self?.errorView.stopLoading()
        }
    }

    // MARK: Private properties

    private let detailView = MapDetailsView()

    private let errorView = MapErrorView()

    private var displayedItems = [MapPSIIndexItem]()

}

extension MapViewController {

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        view.tintColor = .lightGray

        detailView.mapView.delegate = self
        detailView.refreshControl = UIRefreshControl()
        detailView.refreshControl?.addTarget(
            self,
            action: #selector(performRefresh),
            for: .valueChanged
        )
        detailView.tabView.addTarget(
            self,
            action: #selector(selectTab),
            for: .valueChanged
        )
        detailView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailView)
        detailView.isHidden = true

        errorView.errorMessage = "Something went wrong. Please try again."
        errorView.retryHandler = { [weak self] in
            self?.performRefresh()
        }
        errorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorView)
        errorView.isHidden = false

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: detailView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: detailView.trailingAnchor),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: detailView.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: detailView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: errorView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: errorView.trailingAnchor),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: errorView.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: errorView.bottomAnchor)
        ])

        if #available(iOS 13, *) {
            view.overrideUserInterfaceStyle = .dark
        }

        self.view = view
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
        detailView.mapView.removeAnnotations(detailView.mapView.annotations)
        detailView.mapView.addAnnotations(annotations)
    }

    private func zoomToAnnotations(_ annotations: [MKAnnotation]) {
        let mapRect = annotations.reduce(MKMapRect.null) { rect, annotation in
            let newRect = MKMapRect(
                origin: MKMapPoint(annotation.coordinate),
                size: MKMapSize(width: 1, height: 1)
            )
            return rect.union(newRect)
        }
        let horizontalPadding = detailView.mapView.frame.width * 0.3 / 2 + 8
        detailView.mapView.setVisibleMapRect(
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
