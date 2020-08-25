//
//  CustommDetailsVIewCell.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 21.08.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//

import UIKit

final class CustomDetailsViewCell: UITableViewCell {

    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var temperatureIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
