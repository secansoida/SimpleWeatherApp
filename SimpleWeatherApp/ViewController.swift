//
//  ViewController.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 19/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!

    private lazy var allCities: [City] = {
        let cityData = FileManager.default.contents(atPath: Bundle.main.path(forResource: "city.list", ofType: "json")!)!
        return try! JSONDecoder().decode([City].self, from: cityData)
    }()

    private var filteredCities: [City] = []
    private let searchController = UISearchController(searchResultsController: nil)
    private var lastQuery: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cities"
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let weatherVC = segue.destination as? WeatherViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            weatherVC.city = filteredCities[indexPath.row]
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        let city = filteredCities[indexPath.row]
        cell.textLabel?.text = "\(city.name), \(city.country)"
        return cell
    }
}

extension ViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, query.count > 2 else {
            filteredCities = []
            tableView.reloadData()
            return
        }
        if query.contains(lastQuery) {
            filteredCities = filteredCities.lazy.filter{ $0.name.contains(query) }
        } else {
            filteredCities = allCities.lazy.filter{ $0.name.contains(query) }
        }
        tableView.reloadData()
    }
}
