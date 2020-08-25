//
//  WeatherManager.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 20.08.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//

import Foundation
import CoreData

final class WeatherManager: NSObject {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherData")
    private let fetchDailyWeather = FetchDailyWeather()
    private var currentWeather: WeatherDataModel?
    private var context = ContextSingltone.shared.context
    var forecastArray : [WeatherData]?
    
    
    static let shared = WeatherManager()
    
    func getDataWith(city: String, isNewCity: Bool, completion: @escaping (Result<String>) -> Void) {
        
        if city != "" {
            
            let fullUrl =             ("\(Constans.shared.weatherURL)\(Constans.shared.currentWeather)\(city)\(Constans.shared.apiKey)\(Constans.shared.units)\(Constans.shared.weatherLang)")
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
                        do {
                            let results = try self.context?.fetch(self.request)
                            self.updateWeather(city: city, results: results!)
                        } catch {
                            return completion(.Error(error.localizedDescription))
                        }
                    }
                    completion(.Success(""))
                } catch {
                    print(error.localizedDescription)
                    return completion(.Error(error.localizedDescription))
                }
                
            }.resume()
            
        } else {
            return completion(.Error("Неверное название города"))
        }
        
    }
    
    func addNewCity (city: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: "WeatherData", in: context!) else {return}
        let cityEntity = NSManagedObject(entity: entity, insertInto: context) as! WeatherData
        saveToDB(entity: cityEntity, city: city)
        Thread.printCurrent()
        DispatchQueue.global(qos: .background).async {
            Thread.printCurrent()

            self.fetchDailyWeather.fetchForecast(lon: (self.currentWeather?.coord.lon)!, lat: (self.currentWeather?.coord.lat)!, cityWeatherInfo: cityEntity)
        }
    }
    
    
    func updateWeather (city: String, results: [Any]) {
        for result in results as! [WeatherData] {
            let cityResult = result.value(forKey: "city") as? String
            if cityResult == city {
                saveToDB(entity: result, city: city)
                forecastArray?.append(result)
                Thread.printCurrent()

                DispatchQueue.global(qos: .background).sync {
                    Thread.printCurrent()

                    self.fetchDailyWeather.fetchForecast(lon: (self.currentWeather?.coord.lon)!, lat: (self.currentWeather?.coord.lat)!, cityWeatherInfo: result)
                }
                
            }
        }
        
    }
    func saveToDB(entity: NSManagedObject, city: String) {
        
        entity.setValue(city, forKey: "city")
        entity.setValue(currentWeather?.weather[0].description.capitalizingFirstLetter(), forKey: "weatherDescription")
        entity.setValue(currentWeather?.id, forKey: "cityId")
        entity.setValue(currentWeather?.coord.lat, forKey: "lat")
        entity.setValue(currentWeather?.coord.lon, forKey: "lon")
        entity.setValue(currentWeather?.main.humidity, forKey: "humidity")
        entity.setValue(currentWeather?.main.feelsLike, forKey: "feelsLike")
        entity.setValue(currentWeather?.main.pressure, forKey: "pressure")
        entity.setValue(currentWeather?.main.temp, forKey: "temperature")
        entity.setValue(currentWeather?.weather[0].id, forKey: "id")
        try? context?.save()
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

extension Thread {
    class func printCurrent() {
        print("\r⚡️: \(Thread.current)\r" + ": \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r")
    }
}
