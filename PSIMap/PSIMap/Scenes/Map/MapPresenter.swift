//
//  MapPresenter.swift
//  PSIMap
//
//  Created by Kevin Lo on 28/10/2019.
//  Copyright © 2019 Zuhlke Engineering HK Limited. All rights reserved.
//

import Foundation

class MapPresenter: MapPresenterProtocol {

    weak var view: MapViewProtocol?

    func presentData(with response: PSIAPIResponse) {
        let readingItem = response.items.max(by: { $0.updateTimestamp < $1.updateTimestamp })

        let items: [MapPSIIndexItem] = response.regionMetadata.map { region -> MapPSIIndexItem? in
            guard
                let psiTwentyFourHourly = readingItem?.readings.psiTwentyFourHourly[region.name],
                let pm25Hourly = readingItem?.readings.pm25TwentyFourHourly[region.name]
                else {
                    return nil
            }

            let pSiAirQuality: MapPSIAirQuality = {
                switch Int(round(psiTwentyFourHourly)) {
                case 0...50:
                    return .good
                case 51...100:
                    return .moderate
                case 101...200:
                    return .unhealthy
                case 201...300:
                    return .veryUnhealthy
                default:
                    return .hazardous
                }
            }()

            return MapPSIIndexItem(
                longitude: region.labelLocation.longitude,
                latitude: region.labelLocation.latitude,
                name: region.name,
                psiTwentyFourHourly: psiTwentyFourHourly,
                psiAirQuality: pSiAirQuality,
                pm25Hourly: pm25Hourly
            )
        }
        .compactMap { $0 }

        let itemsWithoutNational = items.filter { $0.latitude != 0 || $0.longitude != 0 }
        view?.showPSIIndex(with: itemsWithoutNational)

        if let nationalItem = items.first(where: { $0.latitude == 0 && $0.longitude == 0 }) {
            view?.showNationalAirQuality(nationalItem.psiAirQuality)
        }

        if let updateTimestamp = readingItem?.updateTimestamp {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            formatter.locale = Locale(identifier: "en")
            let displayTime = formatter.string(from: updateTimestamp)
            view?.showRefreshTime(displayTime)
        }
    }

    func presentError() {
        view?.showError()
    }

    func presentLoadingState(isLoading: Bool) {
        if isLoading {
            view?.startLoading()
        } else {
            view?.stopLoading()
        }
    }

}
