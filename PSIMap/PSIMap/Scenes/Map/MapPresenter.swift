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
        let displayItems = response.displayItems
        let itemsWithoutNational = displayItems.filter { $0.latitude != 0 || $0.longitude != 0 }
        view?.showPSIIndex(with: itemsWithoutNational)

        if let nationalItem = displayItems.first(where: { $0.latitude == 0 && $0.longitude == 0 }) {
            view?.showAirQualitySummary(
                airQuality: nationalItem.psiAirQuality,
                outdoorActivityAdvise: MapOutdoorActivityAdvise.make(
                    psiValue: Int(nationalItem.psiTwentyFourHourly)
                )
            )
        }

        if let updateTimestamp = response.readingItem?.updateTimestamp {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            formatter.locale = Locale(identifier: "en")
            formatter.timeZone = TimeZone(abbreviation: "SGT")
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

private extension MapOutdoorActivityAdvise {

    static func make(psiValue: Int) -> Self {
        switch psiValue {
        case 0...100:
            return .normal
        case 101...200:
            return .reduceProlonged
        case 201...300:
            return .avoid
        default:
            return .minimise
        }
    }

}

private extension PSIAPIResponse {

    var readingItem: PSIAPIResponseItem? {
        return items.max(by: { $0.updateTimestamp < $1.updateTimestamp })
    }

    var displayItems: [MapPSIIndexItem] {
        return regionMetadata.map { region -> MapPSIIndexItem? in
            guard
                let psiTwentyFourHourly = self.readingItem?.readings.psiTwentyFourHourly[region.name],
                let pm25Hourly = self.readingItem?.readings.pm25TwentyFourHourly[region.name]
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
    }

}
