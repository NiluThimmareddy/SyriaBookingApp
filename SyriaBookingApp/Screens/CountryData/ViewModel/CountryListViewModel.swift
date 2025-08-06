//
//  CountryListViewModel.swift
//  HotelBooking
//
//  Created by praveenkumar on 30/05/25.
//

import Foundation

class CountryListViewModel {

    var countries: [Country] = []

    var onDataUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?

    func fetchCountries() {
        guard let url = URL(string: "https://flagcdn.com/en/codes.json") else {
            return
        }
       
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.onError?(error)
                }
                return
            }

            guard let data = data else { return }

            do {
                let countryDict = try JSONDecoder().decode([String: String].self, from: data)

                self.countries = countryDict.map { Country(code: $0.key, name: $0.value) }
                    .sorted { $0.name < $1.name }

                DispatchQueue.main.async {
                    self.onDataUpdated?()
                }
            } catch {
                DispatchQueue.main.async {
                    self.onError?(error)
                }
            }
        }.resume()
    }
}
