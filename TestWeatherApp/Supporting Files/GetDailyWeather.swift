//
//  AddFor.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 22.08.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//

import Foundation
import CoreData

class GetDailyWeather {
    var forecastArray : [DailyWeather]?
    let context = ContextSingltone.shared.context
    
    func fetchForecast(lon: Double, lat: Double, cityWeatherInfo: WeatherData, forrequest: NSFetchRequest<DailyWeather> = DailyWeather.fetchRequest()) {

        let cityPredicate = NSPredicate(format: "cityId MATCHES %@", String(cityWeatherInfo.cityId))
        forrequest.predicate = cityPredicate
        do {
            forecastArray = try context!.fetch(forrequest)
        } catch {
            print("Error fetching data from contextForecast \(error)")
        }
        
        fetchData(lon: lon, lat: lat, cityWeatherInfo: cityWeatherInfo)
    }
    
    func fetchData(lon: Double, lat: Double, cityWeatherInfo: WeatherData) {

        var dayForecast: Int = 0
        let fullurl =
        "\(Constans.shared.dailyURL)lat=\(lat)&lon=\(lon)&exclude=current&\(Constans.shared.apiKey)\(Constans.shared.units)"
        guard let url = URL(string: fullurl) else {return}
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else {return}
            do{
                let currentWeather = try JSONDecoder().decode(DailyWeatherModel.self, from: data)

                for item in currentWeather.daily {
                   
                    guard let forecastArr = self.forecastArray else {return}
                    var forecast: DailyWeather
                    if cityWeatherInfo.dailyDataAvailable == false || forecastArr.isEmpty {
                        forecast = DailyWeather(context: self.context!)
                    } else {
                        
                        forecast = forecastArr[dayForecast]
                    }
                    forecast.cityId = cityWeatherInfo.cityId
                    forecast.temperature = Int32(item.temp.day)
                    forecast.id = Int32(item.weather[0].id)
                    forecast.dayOfWeek = self.getDayOfWeek(increaseDayBy: dayForecast + 1)
                    dayForecast = dayForecast + 1
                    self.forecastArray?.append(forecast)
                }
                
                cityWeatherInfo.dailyDataAvailable = true
                self.saveForecastInfo()
            } catch {
                
            }
        }.resume()
        
    }
    
    func getDayOfWeek(increaseDayBy: Int) -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        var dateComponents = DateComponents()
        var dayOfWeekString = ""
        
        dateFormatter.dateFormat = "dd"
        dateFormatter.dateFormat = "EEEE"
        dateComponents.setValue(increaseDayBy, for: .day)
        if let date = Calendar.current.date(byAdding: dateComponents, to: now) {
            dayOfWeekString = dateFormatter.string(from: date)
        }
        return dayOfWeekString
    }
    
    
    func saveForecastInfo() {
        let context = ContextSingltone.shared.context
        try? context?.save()
        
    }
    
}
