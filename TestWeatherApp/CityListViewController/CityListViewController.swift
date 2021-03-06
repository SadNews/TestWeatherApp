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
    
    let getCurrentWeather = GetCurrentWeather()
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    let request: NSFetchRequest<WeatherData> = WeatherData.fetchRequest()
    var result: [WeatherData]?
    var refreshControl: UIRefreshControl {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(refreshWeather(sender:)), for: .valueChanged)
        return refControl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
    
    private func setup() {
        if launchedBefore  {
            loadCityInfo(city: "", isNewCity: false)
        } else {
            loadCityInfo(city: "Moscow", isNewCity: true)
            loadCityInfo(city: "Saint Petersburg", isNewCity: true)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CityCell", bundle: nil), forCellReuseIdentifier: "customCityCell")
        tableView.rowHeight = 100
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
}

extension CityListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCityCell", for: indexPath) as! CustomCityCell
        guard let result = result else {return cell}
        cell.cityLabel.text = result[indexPath.row].city
        cell.tempLabel.text = String("\(result[indexPath.row].temperature)°")
        cell.weatherBackgroundImage.loadGif(name: Constans.shared.updateWeatherIcon(condition: Int(result[indexPath.row].id)))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let context = ContextSingltone.shared.context
        let result = try? context?.fetch(request)
        if indexPath.row == 0 {
            let viewController = DetailsViewController(nibName: "DetailsView", bundle: nil)
            viewController.selectedCity = result?[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let viewController = ForecastViewController()
            viewController.selectedCity = result?[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension CityListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.result?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = ContextSingltone.shared.context
            let city = result?[indexPath.row].cityId
            context?.delete((result?[indexPath.row])!)
            try? context?.save()
            result?.remove(at: indexPath.row)
            DeleteFromDB.deleteFromDB(city: Int(city!))
            self.tableView.reloadData()
        }
    }
}
