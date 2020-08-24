//
//  DailyWeather+CoreDataProperties.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 24.08.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//
//

import Foundation
import CoreData


extension DailyWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyWeather> {
        return NSFetchRequest<DailyWeather>(entityName: "DailyWeather")
    }

    @NSManaged public var condition: Int32
    @NSManaged public var dayOfWeek: String?
    @NSManaged public var temperature: Double
    @NSManaged public var cityName: String?
    @NSManaged public var cityId: Int32
    @NSManaged public var parentCity: WeatherData?

}
