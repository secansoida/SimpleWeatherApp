//
//  LocationFetcher.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 20/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import Foundation

typealias LocationID = Int

struct City: Codable {
    let id: LocationID
    let name: String
    let country: String
}

struct Weather: Codable {
    let locationID: LocationID
    let locationName: String

    enum CodingKeys: String, CodingKey {
        case locationID = "id"
        case locationName = "name"
        case main
    }
    let main: Main

    struct Main: Codable {
        let temp: Float
        let pressure: Int
        let humidity: Int
    }
}

final class NetworkFetcher: Fetcher {
    let session = URLSession.shared
    let configuration: Configuration
    init(configuration: Configuration) {
        self.configuration = configuration
    }
    func fetch(path: String, parameters: [String: String], completion: @escaping (Data?) -> Void) {

        let url = configuration.hostURL.appendingPathComponent(path)
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { fatalError() }
        components.queryItems = parameters.map(URLQueryItem.init)
        components.queryItems?.append(URLQueryItem(name: "appid", value: configuration.apiKey))
        print(components.url?.absoluteString ?? "no url")
        let task = session.dataTask(with: components.url!) { (data, response, error) in
            completion(data)
        }
        task.resume()
    }
}

struct Configuration {
    let hostURL: URL
    let apiKey: String

    static var fromPlist: Configuration {
        guard let configPath = Bundle.main.path(forResource: "config", ofType: "plist") else {
            fatalError("Missing config file")
        }
        guard let configDictionary = NSDictionary(contentsOfFile: configPath) as? [String: Any] else {
            fatalError("Invalid format of config file")
        }
        guard let hostname = configDictionary["hostname"] as? String,
            let hostURL = URL(string: hostname) else {
                fatalError("Invalid value for hostname")
        }
        guard let apiKey = configDictionary["apiKey"] as? String else {
            fatalError("Invalid value for apiKey")
        }
        return Configuration(hostURL: hostURL, apiKey: apiKey)
    }
}

protocol Fetcher {
    func fetch(path: String, parameters: [String: String], completion: @escaping (Data?) -> Void)
}

final class LocationFetcher {

    let fetcher: Fetcher
    init(fetcher: Fetcher) {
        self.fetcher = fetcher
    }

    func fetchWeather(forCityID cityID: String, completion: @escaping (Weather?) -> Void) {
        let path = "weather"
        let parameters = ["id": cityID]

        fetcher.fetch(path: path, parameters: parameters) { (data) in
            guard let data = data else {
                completion(nil)
                return
            }
            print(String(data: data, encoding: .utf8) ?? "no")
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
