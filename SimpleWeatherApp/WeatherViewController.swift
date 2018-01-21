//
//  WeatherViewController.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 21/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import UIKit

final class WeatherViewController: UIViewController {

    var city: City!

    private var weatherFetcher: WeatherFetcher!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = city.name

        let networkFetcher = NetworkFetcher(configuration: Configuration.fromPlist)
        self.weatherFetcher = WeatherFetcher(fetcher: networkFetcher)
    }
}
