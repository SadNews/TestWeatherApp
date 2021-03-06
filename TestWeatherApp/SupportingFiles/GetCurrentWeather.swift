//
//  WeatherManager.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 20.08.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//

import Foundation
import CoreData

final class GetCurrentWeather: NSObject {
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherData")
    let fetchDailyWeather = GetDailyWeather()
    var currentWeather: WeatherDataModel?
    var context = ContextSingltone.shared.context
    static let shared = GetCurrentWeather()
    
    func getDataWith(city: String, isNewCity: Bool, completion: @escaping (Result<String>) -> Void) {
        if city != "" {
            let fullUrl = ("\(APIConstants.Server.apiLink)\(convertToEnglish(city: city))\(APIConstants.Server.apiKey)\(APIConstants.Server.units)")
            guard let url = URL(string: fullUrl) else {return}
           
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    completion(.Error(error?.localizedDescription ?? "Some problems"))
                }
                guard let data = data else {return}
                do {
                    let currentWeather = try JSONDecoder().decode(WeatherDataModel.self, from: data)
                    self.currentWeather = currentWeather
                    
                    if isNewCity {
                        self.addNewCity(city: city)
                    } else {
                        guard let results = try self.context?.fetch(self.request) else {return}
                        self.updateWeather(city: city, results: results)
                    }
                    completion(.Success(""))
                } catch {
                    return completion(.Error(error.localizedDescription))
                }
            }.resume()
        } else {
            return completion(.Error("Неверное название города"))
        }
    }
}

