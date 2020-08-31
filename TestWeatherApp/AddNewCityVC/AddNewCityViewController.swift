//
//  AddNewCityViewController.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 21.08.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//

import UIKit
import MapKit

protocol AddCityDelegate {
    func userAddedANewCityName (city : String)
}

final class AddNewCityViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var delegate : AddCityDelegate?
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.resultTypes = .address
        tableView.dataSource = self
        tableView.delegate = self
        searchCompleter.delegate = self
    }
    func getNewCityData(cityName: String) {
        delegate?.userAddedANewCityName(city: cityName)
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddNewCityViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.resultTypes = .address
        
        searchCompleter.queryFragment = searchText
    }
}

extension AddNewCityViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
}

extension AddNewCityViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
}

extension AddNewCityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearch.Request(completion: completion)
        searchRequest.resultTypes = .address
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if completion.subtitle != "" {
                self.getNewCityData(cityName: completion.subtitle)
            } else {
                self.getNewCityData(cityName: completion.title)
            }
        }
    }
}
