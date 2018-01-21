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

    private enum Mode {
        case recent
        case searchResults
    }

    private var mode: Mode = .recent

    private var recentSearchesProvider: RecentSearchesPersistance = UserDefaults.standard
    private let cityListProvider: CityListProvider = SQLiteCityListProvider.default
    private var recentlySearchedCities: [City] = []
    private var filteredCities: [City] = []
    private let searchController = UISearchController(searchResultsController: nil)
    private var lastQuery: String = "."

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cities"
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true

        recentlySearchedCities = recentSearchesProvider.recentlySearchedCities ?? []
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        recentSearchesProvider.recentlySearchedCities = recentlySearchedCities
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let weatherVC = segue.destination as? WeatherViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            let city: City
            switch mode {
            case .recent:
                city = recentlySearchedCities[indexPath.row]
            case .searchResults:
                city = filteredCities[indexPath.row]
            }
            weatherVC.city = city
            recentlySearchedCities.remove(object: city)
            recentlySearchedCities.insert(city, at: 0)
            if recentlySearchedCities.count > 10 {
                recentlySearchedCities.removeLast()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mode {
        case .recent:
            return recentlySearchedCities.count
        case .searchResults:
            return filteredCities.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        let city: City
        switch mode {
        case .recent:
            city = recentlySearchedCities[indexPath.row]
            cell.textLabel?.textColor = UIColor.darkGray.withAlphaComponent(1.0 - CGFloat(indexPath.row)/CGFloat(recentlySearchedCities.count) * 0.5)
        case .searchResults:
            city = filteredCities[indexPath.row]
            cell.textLabel?.textColor = .black
        }
        cell.textLabel?.text = "\(city.name), \(city.country)"
        return cell
    }
}

extension ViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        mode = (searchText?.isEmpty ?? true) ? .recent : .searchResults
        guard let query = searchText?.trimmingCharacters(in: .whitespaces).lowercased(),
            query.count > 2 else {
                filteredCities = []
                lastQuery = ""
                tableView.reloadData()
                return
        }
        if !lastQuery.isEmpty && query.contains(lastQuery) {
            filteredCities = filteredCities.filter{ $0.name.lowercased().contains(query) }
        } else {
            filteredCities = cityListProvider.cities(matchingQuery: query)
        }
        lastQuery = query
        tableView.reloadData()
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.rangeOfCharacter(from: CharacterSet.letters.union(.whitespaces).inverted) != nil {
            return false
        }
        return true
    }
}
