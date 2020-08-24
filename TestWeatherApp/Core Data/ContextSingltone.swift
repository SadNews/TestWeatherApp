//
//  ContextSingltone.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 20.08.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//

import CoreData

final class ContextSingltone {
    static let shared = ContextSingltone()
    var context: NSManagedObjectContext?
}
