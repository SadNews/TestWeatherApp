//
//  Constants.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 20.08.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//

struct Constans {
    static let shared = Constans()
    let weatherURL = "https://api.openweathermap.org/data/2.5/"
    let dailyURL = "https://api.openweathermap.org/data/2.5/onecall?"
    let apiKey = "&appid=9754f1dcdd163d57f0a1b5346df28be3"
    var units = "&units=metric"
    let currentWeather = "weather?q="
    let weatherLang = "&lang=ru"
    
    func updateWeatherIcon(condition: Int) -> String {
        switch (condition) {
        case 0...300:
            return "tstorm1"
        case 301...500:
            return "light_rain"
        case 501...600:
            return "shower3"
        case 601...700:
            return "snow4"
        case 701...771:
            return "fog"
        case 772...799:
            return "tstorm3"
        case 800:
            return "sunny"
        case 801...804:
            return "cloudy2"
        case 900...903, 905...1000:
            return "tstorm3"
        case 903:
            return "snow5"
        case 904:
            return "sunny"
        default:
            return "dunno"
        }
    }
}
