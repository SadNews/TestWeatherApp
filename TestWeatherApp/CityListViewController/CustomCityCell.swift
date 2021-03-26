//
//  WeatherManager.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 20.08.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//

import UIKit

final class CustomCityCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherBackgroundImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


