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

    }

    func presentError() {

    }

    func presentLoadingState(isLoading: Bool) {

    }

}
