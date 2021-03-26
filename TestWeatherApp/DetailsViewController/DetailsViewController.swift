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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    private var forecastArray : [DailyWeather]?
    private var hourlyWeather: [Hourly]?
    private var rowCount = 3
    var selectedCity : WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupView()
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.register(UINib(nibName: "CustomDetailsViewCell", bundle: nil), forCellReuseIdentifier: "CustomDetailsViewCell")
        collectionView.register(UINib(nibName: "HoursWeatherCell", bundle: nil), forCellWithReuseIdentifier: "HoursWeatherCell")
        tableView.rowHeight = 70
        navigationItem.title = "ViewController by IB"
        
        cityLabel.text = selectedCity?.city
        temperatureLabel.text = String("\(selectedCity?.temperature ?? 0) C°")
        
    }
    
    func fetchData() {
        let context = ContextSingltone.shared.context
        let request: NSFetchRequest<DailyWeather> = DailyWeather.fetchRequest()
        guard let city = selectedCity else {return}
        request.predicate = NSPredicate(format: "cityId MATCHES %@", String(city.cityId))
        do {
            guard let context = context else {return}
            forecastArray = try context.fetch(request)
            tableView.reloadData()
            Networking.shared.fetchData(lon: city.lon, lat: city.lon) { result in
                self.hourlyWeather = result.hourly
                DispatchQueue.main.async {
                    self.reload()
                }
                
            }
        } catch {
        }
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    @IBAction func segmentedControlDidTap(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            rowCount = 3
        case 1:
            rowCount = forecastArray?.count ?? 0
        default:
            print("Провалились в дефолт, опять забыл добавить кейс")
        }
        tableView.reloadData()
    }
}
extension DetailsViewController: UITableViewDelegate {
    
}

extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomDetailsViewCell", for: indexPath) as! CustomDetailsViewCell
        guard let weather = forecastArray?[indexPath.row] else {return cell}
        cell.dayOfWeekLabel.text = weather.dayOfWeek
        cell.temperatureLabel.text = String("\(weather.temperature)°")
        return cell
    }
    
}

extension DetailsViewController: UICollectionViewDelegate {
    
}

extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // я бы хотел сделать разделение по дням, как у приложения в айфона, но у меня не хватит времени(
        // поэтому просто 12, хорошая цифра на мой взгляд
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HoursWeatherCell", for: indexPath) as! HoursWeatherCollectionViewCell
        guard let weather = hourlyWeather?[indexPath.row] else {return cell}
        let temp = String(weather.temp)
        let date = Date(timeIntervalSince1970: TimeInterval(weather.dt))
        let formate = date.getFormattedDate(format: "HH")
        cell.hour.text = formate
        cell.temperatureLabel.text = temp.components(separatedBy: ".")[0] + "°"
        cell.weatherIcon.image =  UIImage(named: Constans.shared.updateWeatherIcon(condition: weather.weather.first?.id ?? 0))
        return cell
    }
}

extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeWith = collectionView.bounds.width / 8
        let sizeHight = collectionView.bounds.height
        return CGSize(width: sizeWith, height: sizeHight)
    }
}
