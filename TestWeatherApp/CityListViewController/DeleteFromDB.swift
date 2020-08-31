//
//  DeleteFromDB.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 28.08.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//

import Foundation
import CoreData
class DeleteFromDB {
   static func deleteFromDB(city: Int) {
        let context = ContextSingltone.shared.context
        let forrequest: NSFetchRequest<DailyWeather> = DailyWeather.fetchRequest()
        let cityPredicate = NSPredicate(format: "cityId MATCHES %@", String(city))
        forrequest.predicate = cityPredicate
        let forecastArray = try? context!.fetch(forrequest)
        for item in forecastArray! {
            context?.delete(item)
        }
        try? context?.save()
    }
}
