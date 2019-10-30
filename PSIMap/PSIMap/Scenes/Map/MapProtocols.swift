//
//  MapProtocols.swift
//  PSIMap
//
//  Created by Kevin Lo on 28/10/2019.
//  Copyright © 2019 Zuhlke Engineering HK Limited. All rights reserved.
//

import Foundation

struct MapPSIIndexItem {

    let longitude: Double

    let latitude: Double

    let name: String

    let psiTwentyFourHourly: Double

    let psiAirQuality: MapPSIAirQuality

    let pm25Hourly: Double

}

enum MapPSIAirQuality {
    case good, moderate, unhealthy, veryUnhealthy, hazardous
}

protocol MapViewProtocol: class {

    var interactor: MapInteractorProtocol? { get set }

    func showPSIIndex(with items: [MapPSIIndexItem])

    func showNationalAirQuality(_ quality: MapPSIAirQuality)

    func showError()

    func startLoading()

    func stopLoading()

}

protocol MapInteractorProtocol: class {

    var presenter: MapPresenterProtocol? { get set }

    var apiService: PSIAPIServiceProtocol? { get set }

    func fetchPSIData()

}

protocol MapPresenterProtocol: class {

    var view: MapViewProtocol? { get set }

    func presentData(with response: PSIAPIResponse)

    func presentError()

    func presentLoadingState(isLoading: Bool)

}
