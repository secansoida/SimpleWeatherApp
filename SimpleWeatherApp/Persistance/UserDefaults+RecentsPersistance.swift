//
//  UserDefaults+RecentsPersistance.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 21/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import Foundation

private let recentlySearchedCitiesKey = "recentlySearchedCitiesKey"

extension UserDefaults: RecentSearchesPersistance {
    var recentlySearchedCities: [City]? {
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.set(nil, forKey: recentlySearchedCitiesKey)
                return
            }
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: recentlySearchedCitiesKey)
        }
        get {
            guard let data = UserDefaults.standard.data(forKey: recentlySearchedCitiesKey) else {
                return nil
            }
            return try? JSONDecoder().decode([City].self, from: data)
        }
    }
}
