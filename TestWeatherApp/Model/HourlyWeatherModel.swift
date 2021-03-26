//
//  HourlyWeatherModel.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 26.03.2021.
//  Copyright © 2021 Андрей Ушаков. All rights reserved.
//

import Foundation

struct HourlyWeather: Decodable {
    let hourly: [Hourly]
}

struct Hourly: Decodable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
}
