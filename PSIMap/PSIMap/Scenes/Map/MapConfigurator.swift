//
//  MapConfigurator.swift
//  PSIMap
//
//  Created by Kevin Lo on 28/10/2019.
//  Copyright © 2019 Zuhlke Engineering HK Limited. All rights reserved.
//

import UIKit

final class MapConfigurator {

    class func makeViewController() -> UIViewController {
        let viewController = MapViewController()

        let view: MapViewProtocol = viewController
        let interactor: MapInteractorProtocol = MapInteractor()
        let presenter: MapPresenterProtocol = MapPresenter()
        let apiService: PSIAPIServiceProtocol = PSIAPIService()
        view.interactor = interactor
        interactor.presenter = presenter
        interactor.apiService = apiService
        presenter.view = view

        return viewController
    }

}
