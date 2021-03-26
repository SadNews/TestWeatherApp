//
//  DateFormatter.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 26.03.2021.
//  Copyright © 2021 Андрей Ушаков. All rights reserved.
//

import Foundation

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
