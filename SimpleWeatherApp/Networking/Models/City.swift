//
//  City.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 21/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import Foundation

typealias CityID = Int

struct City: Codable {
    let id: CityID
    let name: String
    let country: String
}
