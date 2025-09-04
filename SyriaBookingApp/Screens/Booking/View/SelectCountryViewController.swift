//
//  SelectCountryViewController.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 04/09/25.
//

import UIKit

protocol SelectCountryDelegate: AnyObject {
    func didSelectCountry(_ country: CountryModel)
}

class SelectCountryViewController: UIViewController {
    
    var countryList: [CountryModel] = []
    var filteredList: [CountryModel] = []
    
    weak var delegate: SelectCountryDelegate?
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        searchBar.placeholder = "Search Country"
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        filteredList = countryList
    }

}

extension SelectCountryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredList = countryList
        } else {
            filteredList = countryList.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.code.contains(searchText)
            }
        }
        tableView.reloadData()
    }
}

extension SelectCountryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = filteredList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(country.flag) \(country.name) \(country.code)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = filteredList[indexPath.row]
        delegate?.didSelectCountry(country)
        dismiss(animated: true)
    }
}
