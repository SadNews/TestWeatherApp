//
//  DetailsViewController.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 21.08.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//

import UIKit
import CoreData

final class DetailsViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLable: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!
    @IBOutlet weak var pressureValueLabel: UILabel!
    
    private var forecastArray : [DailyWeather]?
    
    var selectedCity : WeatherData?
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedCity != nil {
            loadFetchData()
        }
        setupView()
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomDetailsViewCell", bundle: nil), forCellReuseIdentifier: "CustomDetailsViewCell")
        tableView.rowHeight = 70
        navigationItem.title = "Weekly forecast"
        
        descriptionLabel.text = selectedCity?.weatherDescription
        cityLabel.text = selectedCity?.city
        temperatureLabel.text = String("\(selectedCity?.temperature ?? 0) C°")
        humidityLable.text = "Влажность"
        pressureLabel.text = "Давление"
        humidityValueLabel.text = String("\(selectedCity!.humidity)%")
        pressureValueLabel.text = String("\(selectedCity!.pressure) мм")
    }
    
    func loadFetchData() {
        let context = ContextSingltone.shared.context
        let request: NSFetchRequest<DailyWeather> = DailyWeather.fetchRequest()
        request.predicate  = NSPredicate(format: "cityId MATCHES %@", String(selectedCity!.cityId))
        forecastArray = try? context?.fetch(request)
        
    }
    
}
extension DetailsViewController: UITableViewDelegate {
    
}

extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomDetailsViewCell", for: indexPath) as! CustomDetailsViewCell
        cell.dayOfWeekLabel.text = forecastArray![indexPath.row].dayOfWeek
        cell.temperatureLabel.text = String("\(forecastArray![indexPath.row].temperature)°")
        cell.temperatureIcon.image =  UIImage(named: Constans.shared.updateWeatherIcon(condition: Int(forecastArray![indexPath.row].id)))
        return cell
    }
    
}
