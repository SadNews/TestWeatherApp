//
//  AddFor.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 23.08.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//

import Foundation
import CoreData

class FetchDailyWeather {
    var context = ContextSingltone.shared.context
    var forecastArray : [DailyWeather]?
    let forrequest: NSFetchRequest<DailyWeather> = DailyWeather.fetchRequest()
    
    func fetchForecast(lon: Double, lat: Double, cityWeatherInfo: WeatherData) {
        forrequest.predicate  = NSPredicate(format: "cityId MATCHES %@", String(cityWeatherInfo.cityId))
               forecastArray = try? context?.fetch(forrequest)
        var dayForecast: Int = 0
        let qq = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=current&appid=9754f1dcdd163d57f0a1b5346df28be3&units=metric&lang=ru"
        
        guard let url = URL(string: qq) else {return}
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else {return}
            do{
                
                let currentWeather = try JSONDecoder().decode(DailyWeatherModel.self, from: data)
                for item in currentWeather.daily {
                    
                    var forecast: DailyWeather
                    if cityWeatherInfo.dailyDataAvailable == false {
                        forecast = DailyWeather(context: self.context!)
                    } else {
                        forecast = self.forecastArray![dayForecast]
                    }
                    forecast.cityId = cityWeatherInfo.cityId
                    forecast.parentCity = cityWeatherInfo
                    forecast.temperature = item.temp.day
                    dayForecast = dayForecast + 1
                    
                    //forecast.dayOfWeek = Int32(item.dt)
                    if (cityWeatherInfo.dailyDataAvailable == false) {
                        self.forecastArray?.append(forecast)
                    }
                }
                cityWeatherInfo.dailyDataAvailable = true
                self.saveForecastInfo()
                //self.reloadTableView()
            } catch {
                
            }
        }.resume()
        
    }
    
    func saveForecastInfo() {
        do {
            try context!.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
//
//
//
//    let forecast = DailyWeather(context: self.context!)
//
//    let qq = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=current&appid=9754f1dcdd163d57f0a1b5346df28be3"
//    //  let fullUrl =
//    //      ("\(Constans.shared.weatherURL)\(Constans.shared.forecastWeather)\(city)\(Constans.shared.apiKey)\(Constans.shared.units)")
//    guard let url = URL(string: qq) else {return}
//    URLSession.shared.dataTask(with: url) { (data, _, _) in
//    guard let data = data else {return}
//    do{
//    let currentWeather = try JSONDecoder().decode(DailyWeatherModel.self, from: data)
//    for item in currentWeather.daily {
//    forecast.parentCity = cityWeatherInfo
//    forecast.temperature = item.temp.day
//    print(self.forecastArray?.count)
//    self.forecastArray?.append(forecast)
//    //                          //  dayForecast = dayForecast + 1
//    //                            //forecast.dayOfWeek = Int32(item.dt)
//
//    }
//    //  self.saveForecastInfo()
//
//
//    //             //   print(forecast.temperature)
//    } catch {
//    print(44)
//    }
//    }.resume()
//
//}
//
//func saveForecastInfo() {
//    do {
//        print(12121)
//        try context!.save()
//    } catch {
//        print("Error saving context \(error)")
//    }
//    //forecastCollectionView.reloadData()
//}
//
//func ww(lon: Double, lat: Double, cityWeatherInfo: WeatherData) {
//    forecastArray = try? context?.fetch(forrequest)
//    print(forecastArray)
//    fetchForecast(lon: lon, lat: lat, cityWeatherInfo: cityWeatherInfo)
//}
}
