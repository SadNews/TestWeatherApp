//
//  Networking.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 26.03.2021.
//  Copyright © 2021 Андрей Ушаков. All rights reserved.
//

import Foundation

class Networking {
    
    static let shared = Networking()
    
    func fetchData(lon: Double, lat: Double, finished: @escaping (HourlyWeather) -> Void) {
        let fullurl =
            "\(APIConstants.Server.apiDailyLink)lat=\(lat)&lon=\(lon)&exclude=minutely\(APIConstants.Server.apiKey)\(APIConstants.Server.units)"
        guard let url = URL(string: fullurl) else {return}
        print(url)
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else {return}
            do{
                let currentWeather = try JSONDecoder().decode(HourlyWeather.self, from: data)
                finished(currentWeather)
            } catch {
            }
        }.resume()
    }
}
