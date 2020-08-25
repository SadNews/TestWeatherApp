//
//  DailyWeatherModel.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 22.08.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//

struct DailyWeatherModel: Decodable {
    let daily: [Daily]
}

struct Daily: Decodable {
    let temp: Temp
    let dt: Int
    let weather: [DaiylyWeather]
    
}

struct DaiylyWeather: Decodable {
    let id: Int
}

struct Temp: Decodable {
    let day: Double
}
