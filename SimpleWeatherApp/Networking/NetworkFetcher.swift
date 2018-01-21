//
//  NetworkFetcher.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 21/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import Foundation

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
