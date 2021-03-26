//
//  HoursWeatherCollectionViewCell.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 26.03.2021.
//  Copyright © 2021 Андрей Ушаков. All rights reserved.
//

import UIKit

class HoursWeatherCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
