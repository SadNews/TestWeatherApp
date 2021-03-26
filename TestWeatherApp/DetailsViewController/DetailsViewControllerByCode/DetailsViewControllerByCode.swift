//
//  DetailsViewControllerByCode.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 26.03.2021.
//  Copyright © 2021 Андрей Ушаков. All rights reserved.
//

import UIKit
import CoreData

class ForecastViewController: UIViewController {
    
    //    private let location: String
    
    
    private let cityLabel = UILabel()
    private let currentTempLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    private let segmentedControl = UISegmentedControl()
    private var forecastArray: [DailyWeather]?
    private var hourlyWeather: [Hourly]?
    private var rowCount = 3
    var selectedCity: WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        fetchData()
        
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
}

private extension ForecastViewController {
    func setupSubviews() {
        navigationItem.title = "ViewController by code"
        [cityLabel, currentTempLabel, collectionView, tableView, segmentedControl].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setupLabels()
        setupCollectionView()
        setupSegmentedControl()
        setupTableView()
    }
    
    private func setupLabels() {
        currentTempLabel.font = UIFont.boldSystemFont(ofSize: 60)
        currentTempLabel.textColor = .black
        cityLabel.font = UIFont.systemFont(ofSize: 30)
        cityLabel.textColor = .black
        NSLayoutConstraint.activate([
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentTempLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
            currentTempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: currentTempLabel.bottomAnchor, constant: 10),
        ])
        currentTempLabel.text = String("\(selectedCity?.temperature ?? 0) C°")
        cityLabel.text = selectedCity?.city
    }
    
    private func setupCollectionView() {
        layout.scrollDirection = .horizontal
        collectionView.register(UINib(nibName: "HoursWeatherCell", bundle: nil), forCellWithReuseIdentifier: "HoursWeatherCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupSegmentedControl() {
        segmentedControl.insertSegment(withTitle: "3 days", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "More than 3 days", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlValueChanged(_:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
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
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "CustomDetailsViewCell", bundle: nil), forCellReuseIdentifier: "CustomDetailsViewCell")
        tableView.separatorInset = UIEdgeInsets()
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.bounces = false
        tableView.separatorStyle = .none
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomDetailsViewCell", for: indexPath) as? CustomDetailsViewCell else {
            return UITableViewCell()
        }
        guard let forecast = forecastArray?[indexPath.row] else {return cell}
        cell.dayOfWeekLabel.text = forecast.dayOfWeek
        cell.temperatureLabel.text = String("\(forecast.temperature)°")
        return cell
    }
}

extension ForecastViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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

extension ForecastViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeWith = collectionView.bounds.width / 8
        let sizeHight = collectionView.bounds.height
        return CGSize(width: sizeWith, height: sizeHight)
    }
}
