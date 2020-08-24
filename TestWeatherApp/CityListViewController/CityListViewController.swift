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
    let request: NSFetchRequest<WeatherData> = WeatherData.fetchRequest()
    @IBOutlet weak var tableView: UITableView!
    var result: [WeatherData]?

    var refreshControl: UIRefreshControl {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(refreshWeather(sender:)), for: .valueChanged)
        return refControl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCityInfo()
        tableView.refreshControl = refreshControl
        setupView()
    }
    
    @objc func refreshWeather(sender: UIRefreshControl) {
        loadCityInfo()
        sender.endRefreshing()
    }
    
    func loadCityInfo() {
        
        let context = ContextSingltone.shared.context
        do {
            guard let citiesArray = try context?.fetch(request) else {return}
            
            for cityWeather in citiesArray {
                if let cityName = cityWeather.city {
                    DispatchQueue.global().async {
                        WeatherManager.shared.getDataWith(city: cityName, isNewCity: false) { (result) in
                            let context = ContextSingltone.shared.context
                            self.result = try? context?.fetch(self.request)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CityCell", bundle: nil), forCellReuseIdentifier: "customCityCell")
        tableView.rowHeight = 170
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        
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
    
    func fetchWeather(city: String, isNewCity: Bool) {
        DispatchQueue.global().async {
            WeatherManager.shared.getDataWith(city: city, isNewCity: isNewCity) { result in
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
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let context = ContextSingltone.shared.context else {return 0 }
        let result = try? context.fetch(request)
        return result?.count ?? 0
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
