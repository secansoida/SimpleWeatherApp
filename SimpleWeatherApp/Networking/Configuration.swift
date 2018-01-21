//
//  Configuration.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 21/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import Foundation

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
