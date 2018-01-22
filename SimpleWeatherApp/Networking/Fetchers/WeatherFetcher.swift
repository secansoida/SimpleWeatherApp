//
//  WeatherFetcher.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 20/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import Foundation

final class WeatherFetcher {

    private let fetcher: Fetcher
    init(fetcher: Fetcher) {
        self.fetcher = fetcher
    }

    func fetchWeather(forCityID cityID: CityID, completion: @escaping (Weather?) -> Void) {
        let path = "weather"
        let parameters = ["id": "\(cityID)"]

        fetcher.fetch(path: path, parameters: parameters) { (data) in
            guard let data = data else {
                completion(nil)
                return
            }
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                completion(weather)
            } catch (let decodingError) {
                print(decodingError)
                completion(nil)
            }
        }

    }
}
