//
//  CityListProvider.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 21/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import Foundation

protocol CityListProvider {
    func cities(matchingQuery query: String) -> [City]
}
