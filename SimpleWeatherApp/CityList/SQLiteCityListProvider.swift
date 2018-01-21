//
//  SQLiteCityListProvider.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 21/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import Foundation


final class SQLiteCityListProvider: CityListProvider {

    private let sqlite: SQLite

    static let `default` = SQLiteCityListProvider()

    private convenience init() {
        guard let defaultDatabasePath = Bundle.main.path(forResource: "citylist", ofType: "sqlite3") else {
            fatalError("Missing citylist database")
        }
        self.init(databasePath: defaultDatabasePath)
    }

    init(databasePath: String) {
        guard let sqlite = SQLite(path: databasePath) else {
            fatalError("Could not open connetion to \(databasePath)")
        }
        self.sqlite = sqlite
    }

    func cities(matchingQuery query: String) -> [City] {
        var foundCities: [City] = []
        let escapedQuery = query.replacingOccurrences(of: "'", with: "''")
        guard let dbCities = sqlite.fetchAll(query: "SELECT * FROM cities WHERE name LIKE '%\(escapedQuery)%' ORDER BY name") else {
            return []
        }
        let decoder = JSONDecoder()
        for dbCity in dbCities {
            if let data = (dbCity["json"] as? String)?.data(using: .utf8),
                let city = try? decoder.decode(City.self, from: data) {
                foundCities.append(city)
            }
        }
        return foundCities
    }
}
