//
//  PSIData.swift
//  PSIMap
//
//  Created by Kevin Lo on 27/10/2019.
//  Copyright © 2019 Zuhlke Engineering HK Limited. All rights reserved.
//

import Foundation

struct PSIAPIResponse: Codable {

    let regionMetadata: [PSIAPIResponseRegion]

    let items: [PSIAPIResponseItem]

}

struct PSIAPIResponseRegion: Codable {

    struct LabelLocation: Codable {

        let longitude: Double

        let latitude: Double

    }

    let name: String

    let labelLocation: LabelLocation

}

struct PSIAPIResponseItem: Codable {

    let updateTimestamp: String

    let timestamp: String

    let readings: PSIReadings

}

struct PSIReadings: Codable {

    let psiTwentyFourHourly: PSIReadingByRegion

    let psiThreeHourly: PSIReadingByRegion?

    let pm10SubIndex: PSIReadingByRegion

    let pm25SubIndex: PSIReadingByRegion

    let so2SubIndex: PSIReadingByRegion

    let o3SubIndex: PSIReadingByRegion

    let coSubIndex: PSIReadingByRegion

    let pm10TwentyFourHourly: PSIReadingByRegion

    let pm25TwentyFourHourly: PSIReadingByRegion

    let no2OneHourMax: PSIReadingByRegion

    let so2TwentyFourHourly: PSIReadingByRegion

    let coEightHourMax: PSIReadingByRegion

    let o3EightHourMax: PSIReadingByRegion

}

struct PSIReadingByRegion: Codable {

    let national: Double

    let north: Double

    let south: Double

    let east: Double

    let west: Double

    let central: Double

}
