//
//  UIColor+Assets.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 21/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import UIKit

extension UIColor {
    static var coolBlue: UIColor {
        if #available(iOS 11, *) {
            return UIColor(named: "coolBlue")!
        }
        return .blue
    }
    static var coolRed: UIColor {
        if #available(iOS 11, *) {
            return UIColor(named: "coolRed")!
        }
        return .red
    }
    static var coolWhite: UIColor {
        if #available(iOS 11, *) {
            return UIColor(named: "coolWhite")!
        }
        return .white
    }
}
