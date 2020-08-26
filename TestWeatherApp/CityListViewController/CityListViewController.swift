//
//  ViewController.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 20.08.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//

import UIKit
import CoreData

final class CityListViewController: UIViewController, AddCityDelegate {
    @IBOutlet weak var tableView: UITableView!
    let context = ContextSingltone.shared.context
    let request: NSFetchRequest<WeatherData> = WeatherData.fetchRequest()
    var result: [WeatherData]?
    var refreshControl: UIRefreshControl {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(refreshWeather(sender:)), for: .valueChanged)
        return refControl
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadCityInfo(city: "", isNewCity: false)
        tableView.refreshControl = refreshControl
        setupView()
    }
    
    @objc func refreshWeather(sender: UIRefreshControl) {
        loadCityInfo(city: "", isNewCity: false)
        sender.endRefreshing()
    }
    
    func loadCityInfo(city: String, isNewCity: Bool) {
        if isNewCity {
            fetchWeather(city: city, isNewCity: isNewCity)
        } else {
                let context = ContextSingltone.shared.context
                guard let citiesArray = try? context?.fetch(request) else {return}
                for cityWeather in citiesArray {
                    if let cityName = cityWeather.city {
                        fetchWeather(city: cityName, isNewCity: false)
                    }
                }
        }
    }

    func fetchWeather(city: String, isNewCity: Bool) {
        DispatchQueue.global().async {
            GetCurrentWeather.shared.getDataWith(city: city, isNewCity: isNewCity) { result in
                switch result {
                case .Success( _):
                    let context = ContextSingltone.shared.context
                    self.result = try? context?.fetch(self.request)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case .Error(let message):
                    DispatchQueue.main.async {
                        self.processErrors(errorMessage: message)
                    }
                }
            }
        }
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CityCell", bundle: nil), forCellReuseIdentifier: "customCityCell")
        tableView.rowHeight = 170
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "AddCity", style: .plain, target: self, action: #selector(addTapped))
        
        navigationItem.title = "Current weather"
    }
    
    @objc func addTapped() {
        let viewController = AddNewCityViewController(nibName: "AddNewCity", bundle: nil)
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func processErrors(errorMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func userAddedANewCityName(city: String) {
        fetchWeather(city: city, isNewCity: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.result?.count ?? 0
    }
    
}

extension CityListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCityCell", for: indexPath) as! CustomCityCell
        if self.result != nil {
            cell.cityLabel.text = result![indexPath.row].city
            cell.temperatureLabel.text = String("Температура \(result![indexPath.row].temperature)°")
            cell.feelsLikeLabel.text = String("Ощущается как \(result![indexPath.row].feelsLike)°")
            cell.humidityLabel.text = String("Влажность \(result![indexPath.row].humidity)%")
            cell.pressureLabel.text = String("Давление \(result![indexPath.row].pressure) мм")
            cell.weatherIcon.image =  UIImage(named: Constans.shared.updateWeatherIcon(condition: Int(result![indexPath.row].id)))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = DetailsViewController(nibName: "DetailsView", bundle: nil)
        if let indexPath = tableView.indexPathForSelectedRow {
            let context = ContextSingltone.shared.context
            let result = try? context?.fetch(request)
            viewController.selectedCity = result?[indexPath.row]
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension CityListViewController: UITableViewDelegate {
    
}
