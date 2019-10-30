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
        let items: [MapPSIIndexItem] = response.regionMetadata.map { region -> MapPSIIndexItem? in
            guard
                let readingItem = response.items.max(by: { $0.updateTimestamp < $1.updateTimestamp }),
                let psiTwentyFourHourly = readingItem.readings.psiTwentyFourHourly[region.name],
                let pm25Hourly = readingItem.readings.pm25TwentyFourHourly[region.name]
                else {
                    return nil
            }

            if region.labelLocation.longitude == 0 && region.labelLocation.latitude == 0 {
                return nil
            }

            return MapPSIIndexItem(
                longitude: region.labelLocation.longitude,
                latitude: region.labelLocation.latitude,
                name: region.name,
                psiTwentyFourHourly: psiTwentyFourHourly,
                pm25Hourly: pm25Hourly
            )
        }
        .compactMap { $0 }
        view?.showPSIIndex(with: items)
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
