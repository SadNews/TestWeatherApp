//
//  WeatherData.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 20.08.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//

import Foundation

struct WeatherDataModel: Decodable {
    let name: String
    let id: Int
    let main: Main
    let coord: Coord
    let weather: [Weather]
}

struct Coord: Decodable {
    let lon: Double
    let lat: Double
}
struct Main: Decodable {
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case feelsLike = "feels_like"
        case pressure = "pressure"
        case humidity = "humidity"
    }
}

struct Weather: Decodable {
    let description: String
    let id: Int
    let main: String
}

struct Wind: Decodable {
    let speed: Double
}

struct Clouds: Decodable {
    let all: Double
}

