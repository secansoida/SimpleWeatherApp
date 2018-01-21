//
//  Weather.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 21/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let locationID: CityID
    let locationName: String

    enum CodingKeys: String, CodingKey {
        case locationID = "id"
        case locationName = "name"
        case mainConditions = "main"
    }

    let mainConditions: Conditions

    struct Conditions: Codable {
        let temp: Float
        let pressure: Int
        let humidity: Int
    }
}
