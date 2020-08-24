//
//  WeatherData+CoreDataProperties.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 24.08.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//
//

import Foundation
import CoreData


extension WeatherData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherData> {
        return NSFetchRequest<WeatherData>(entityName: "WeatherData")
    }

    @NSManaged public var attribute: Int32
    @NSManaged public var city: String?
    @NSManaged public var dt: Int64
    @NSManaged public var feelsLike: Int32
    @NSManaged public var humidity: Int16
    @NSManaged public var id: Int32
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var main: String?
    @NSManaged public var pressure: Int32
    @NSManaged public var temperature: Int32
    @NSManaged public var cityId: Int32
    @NSManaged public var weatherDescription: String?
    @NSManaged public var dailyDataAvailable: Bool
    @NSManaged public var dailyWeather: DailyWeather?

}
