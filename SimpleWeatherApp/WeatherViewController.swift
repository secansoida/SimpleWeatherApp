//
//  WeatherViewController.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 21/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import UIKit


private let minTemperature: Float = 210 // K
private let maxTemperature: Float = 340 // K


final class WeatherViewController: UIViewController {

    var city: City!

    private var weatherFetcher: WeatherFetcher!

    private var weather: Weather?

    @IBOutlet private var thermometerView: ThermometerView!
    @IBOutlet private var temperatureLabel: UILabel!
    @IBOutlet private var humidityLabel: UILabel!
    @IBOutlet private var pressureLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = city.name

        let networkFetcher = NetworkFetcher(configuration: Configuration.fromPlist)
        weatherFetcher = WeatherFetcher(fetcher: networkFetcher)

        temperatureLabel.text = nil
        humidityLabel.text = nil
        pressureLabel.text = nil
        thermometerView.animate()
        weatherFetcher.fetchWeather(forCityID: city.id) { (weather) in
            DispatchQueue.main.async {
                self.thermometerView.stopAnimating()
            }
            guard let weather = weather else {
                return
            }
            DispatchQueue.main.async {
                self.setup(withWeather: weather)
            }
        }
    }

    private func setup(withWeather weather: Weather) {
        self.weather = weather
        let percentage = CGFloat((weather.mainConditions.temp - minTemperature) / (maxTemperature - minTemperature))
        thermometerView.animateFill(toPercentage: min(1, max(0, percentage)))
        thermometerView.fillColor = color(forTemperature: weather.mainConditions.temperatureInCelcius, defaultColor: .darkGray)
        temperatureLabel.text = "\(Int(weather.mainConditions.temperatureInCelcius))℃"
        temperatureLabel.textColor = color(forTemperature: weather.mainConditions.temperatureInCelcius)
        humidityLabel.text = "\(weather.mainConditions.humidity)%"
        pressureLabel.text = "\(Int(weather.mainConditions.pressure)) hPa"
    }

    private func color(forTemperature temperature: Float, defaultColor: UIColor = .black) -> UIColor {
        switch temperature {
        case ..<10:
            return .blue
        case 10...20:
            return defaultColor
        default:
            return .red
        }
    }
}
