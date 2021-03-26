//
//  APIConstants.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 26.03.2021.
//  Copyright © 2021 Андрей Ушаков. All rights reserved.
//

import Foundation

enum APIConstants {
  
  struct Server {
    
    static let apiLink = "https://api.openweathermap.org/data/2.5/weather?q="
    static let apiDailyLink = "https://api.openweathermap.org/data/2.5/onecall?"
    static let apiKey = "&appid=9754f1dcdd163d57f0a1b5346df28be3"
    static let units = "&units=metric"
  }

}
