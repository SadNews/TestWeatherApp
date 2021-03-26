//
//  Constants.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 20.08.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//

import Foundation

struct Constans {
    
    static let shared = Constans()
    
    let date = NSDate()

    func updateWeatherIcon(condition: Int) -> String {
        switch (condition) {
        case 0...300:
            return "Thunderstorm"
        case 301...500:
            return "Drizzle"
        case 501...600:
            return "Rain"
        case 601...700:
            return "Snow"
        case 701...771:
            return "Fog"
        case 772...799:
            return "Thunderstorm"
        case 800:
            return "Sunny"
        case 801...804:
            return "Cloudy"
        case 900...903, 905...1000:
            return "Thunderstorm"
        case 903:
            return "Snow"
        case 904:
            return "Sunny"
        default:
            return "Sunny"
        }
    }
}
