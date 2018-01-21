//
//  Array+Convenience.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 21/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {

    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
