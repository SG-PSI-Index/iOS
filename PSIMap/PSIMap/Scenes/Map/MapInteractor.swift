//
//  MapInteractor.swift
//  PSIMap
//
//  Created by Kevin Lo on 28/10/2019.
//  Copyright © 2019 Zuhlke Engineering HK Limited. All rights reserved.
//

import Foundation

class MapInteractor: MapInteractorProtocol {

    var presenter: MapPresenterProtocol?

    var apiService: PSIAPIServiceProtocol?

    func fetchPSIData() {
        presenter?.presentLoadingState(isLoading: true)
        apiService?.getPSI { [weak self] result in
            self?.presenter?.presentLoadingState(isLoading: false)
            switch result {
            case .success(let response):
                self?.presenter?.presentData(with: response)
            case .failure:
                self?.presenter?.presentError()
            }
        }
    }

}
