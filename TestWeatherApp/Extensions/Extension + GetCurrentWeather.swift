//
//  Extension + GetCurrentWeather.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 05.09.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//

import Foundation
import CoreData

extension GetCurrentWeather {
    
    func addNewCity(city: String) {
        if let context = context {
            guard let entity = NSEntityDescription.entity(forEntityName: "WeatherData", in: context) else {return}
            guard let cityEntity = NSManagedObject(entity: entity, insertInto: context) as? WeatherData else {return}
            saveToDB(entity: cityEntity, city: city)
            DispatchQueue.global().async {
                self.fetchDailyWeather.fetchForecast(lon: (self.currentWeather?.coord.lon) ?? 0, lat: (self.currentWeather?.coord.lat) ?? 0, cityWeatherInfo: cityEntity)
            }
        }
    }
    
    func updateWeather(city: String, results: [Any]) {
        if let results = results as? [WeatherData] {
        for result in results {
            let cityResult = result.value(forKey: "city") as? String
            if cityResult == city {
                saveToDB(entity: result, city: city)
                DispatchQueue.global().async {
                    self.fetchDailyWeather.fetchForecast(lon: (self.currentWeather?.coord.lon) ?? 0, lat: (self.currentWeather?.coord.lat) ?? 0, cityWeatherInfo: result)
                }
            }
        }
        }
    }
    
    func saveToDB(entity: NSManagedObject, city: String) {
        entity.setValue(currentWeather?.name, forKey: "city")
        entity.setValue(currentWeather?.weather.first?.description.capitalizingFirstLetter(), forKey: "weatherDescription")
        entity.setValue(currentWeather?.id, forKey: "cityId")
        entity.setValue(currentWeather?.coord.lat, forKey: "lat")
        entity.setValue(currentWeather?.coord.lon, forKey: "lon")
        entity.setValue(currentWeather?.main.humidity, forKey: "humidity")
        entity.setValue(currentWeather?.main.feelsLike, forKey: "feelsLike")
        entity.setValue(currentWeather?.main.pressure, forKey: "pressure")
        entity.setValue(currentWeather?.main.temp, forKey: "temperature")
        entity.setValue(currentWeather?.weather.first?.id, forKey: "id")
        try? context?.save()
    }
    
    func convertToEnglish(city: String) -> String{
        guard let urlString = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return ""}
        return urlString
    }
}

enum Result<T> {
    case Success(T)
    case Error(String)
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}

