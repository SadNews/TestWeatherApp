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

class AddNewCityViewController: UIViewController {
    var delegate : AddCityDelegate?
        
    @IBOutlet weak var searchBar: UISearchBar!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func getWeather(_ sender: Any) {
        if let cityName = searchBar.text {
            delegate?.userAddedANewCityName(city: cityName)
        }
        self.navigationController?.popViewController(animated: true)
    }
 
}

extension  AddNewCityViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
