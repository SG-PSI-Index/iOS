//
//  AppDelegate.swift
//  PSIMap
//
//  Created by Kevin Lo on 27/10/2019.
//  Copyright © 2019 Zuhlke Engineering HK Limited. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        let mainWindow = UIWindow(frame: UIScreen.main.bounds)
        mainWindow.rootViewController = MapConfigurator.makeViewController()
        mainWindow.makeKeyAndVisible()
        window = mainWindow
        return true
    }

}
