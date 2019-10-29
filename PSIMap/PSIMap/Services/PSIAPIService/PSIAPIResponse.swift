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

    let updateTimestamp: Date

    let timestamp: Date

    let readings: PSIReadings

}

struct PSIReadings: Codable {

    let psiTwentyFourHourly: [String: Double]

    let psiThreeHourly: [String: Double]?

    let pm10SubIndex: [String: Double]

    let pm25SubIndex: [String: Double]

    let so2SubIndex: [String: Double]

    let o3SubIndex: [String: Double]

    let coSubIndex: [String: Double]

    let pm10TwentyFourHourly: [String: Double]

    let pm25TwentyFourHourly: [String: Double]

    let no2OneHourMax: [String: Double]

    let so2TwentyFourHourly: [String: Double]

    let coEightHourMax: [String: Double]

    let o3EightHourMax: [String: Double]

}

extension PSIAPIResponse {

    static func make(jsonData: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(self, from: jsonData)
    }

}
