//
//  WeatherViewController.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 21/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import UIKit


private let minTemperature: Float = 240 // K
private let maxTemperature: Float = 320 // K


final class WeatherViewController: UIViewController {

    var city: City!

    private var weatherFetcher: WeatherFetcher!

    private var weather: Weather?

    @IBOutlet private var thermometerView: ThermometerView!
    @IBOutlet private var temperatureLabel: UILabel!
    @IBOutlet private var humidityLabel: UILabel!
    @IBOutlet private var pressureLabel: UILabel!

    private var viewStartedAppearing: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = city.name

        let networkFetcher = NetworkFetcher(configuration: Configuration.fromPlist)
        weatherFetcher = WeatherFetcher(fetcher: networkFetcher)

        temperatureLabel.alpha = 0
        humidityLabel.alpha = 0
        pressureLabel.alpha = 0
        thermometerView.animate()
        weatherFetcher.fetchWeather(forCityID: city.id) { (weather) in
            DispatchQueue.main.async {
                self.thermometerView.stopAnimating()
                guard let weather = weather else {
                    return
                }
                self.weather = weather
                // Ufortunately this does not animate properly when called immedaitely
                // after stopAnimating; Could not find any other way aroud this
                self.setup(withWeather: weather, animated: self.viewStartedAppearing, thermometerAnimationDelay: 0.1)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewStartedAppearing = true
    }

    private func setup(withWeather weather: Weather, animated: Bool, thermometerAnimationDelay: TimeInterval?) {
        self.weather = weather
        let percentage = CGFloat((weather.mainConditions.temp - minTemperature) / (maxTemperature - minTemperature))
        if animated {
            thermometerView.animateFill(toPercentage: min(1, max(0, percentage)), afterDelay: thermometerAnimationDelay)
        } else {
            thermometerView.fillPercentage = percentage
        }
        thermometerView.fillColor = color(forTemperature: weather.mainConditions.temperatureInCelcius, defaultColor: .darkGray)
        temperatureLabel.text = "\(Int(weather.mainConditions.temperatureInCelcius))℃"
        temperatureLabel.textColor = color(forTemperature: weather.mainConditions.temperatureInCelcius)
        humidityLabel.text = "\(weather.mainConditions.humidity)%"
        pressureLabel.text = "\(Int(weather.mainConditions.pressure)) hPa"

        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.temperatureLabel.alpha = 1
            self.humidityLabel.alpha = 1
            self.pressureLabel.alpha = 1
        }
    }

    private func color(forTemperature temperature: Float, defaultColor: UIColor = .black) -> UIColor {
        switch temperature {
        case ..<10:
            return .coolBlue
        case 10...20:
            return defaultColor
        default:
            return .coolRed
        }
    }
}
