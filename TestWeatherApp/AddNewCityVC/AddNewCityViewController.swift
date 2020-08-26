//
//  AddNewCityViewController.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 21.08.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//

import UIKit

protocol AddCityDelegate {
    func userAddedANewCityName (city : String)
}

final class AddNewCityViewController: UIViewController {
    var delegate : AddCityDelegate?
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        getNewCityData()
        
    }
    
    
    @IBAction func getWeather(_ sender: UIButton) {
        getNewCityData()
    }
    
    func getNewCityData() {
        if let cityName = searchBar.text {
            delegate?.userAddedANewCityName(city: cityName)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension  AddNewCityViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getNewCityData()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
