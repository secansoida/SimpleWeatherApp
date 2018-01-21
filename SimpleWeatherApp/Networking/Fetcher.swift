//
//  Fetcher.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 21/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import Foundation

protocol Fetcher {
    func fetch(path: String, parameters: [String: String], completion: @escaping (Data?) -> Void)
}
