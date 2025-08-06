//
//  CountryCodeDataSource.swift
//  HotelBooking
//
//  Created by praveenkumar on 14/07/25.
//

import Foundation

class CountryCodeDataSourceViewModel {
    
    private(set) var countries: [CountryCodeDataSource] = []
    
    var onDataUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    func fetchCountries() {
        guard let url = URL(string: "https://52a2eb6f-6a3c-4e1a-b20a-e35635f88f97.mock.pstmn.io/countries_phone_number_length") else {
            print("❌ Invalid URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    print("❌ Network error: \(error.localizedDescription)")
                    self.onError?(error)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    print("❌ No data received")
                    self.onError?(NSError(domain: "DataNilError", code: -1001, userInfo: nil))
                }
                return
            }
            
            do {
                let decodedCountries = try JSONDecoder().decode([CountryCodeDataSource].self, from: data)
                DispatchQueue.main.async {
                    print("✅ Successfully decoded \(decodedCountries.count) countries.")
                    self.countries = decodedCountries
                    self.onDataUpdated?()
                }
            } catch {
                DispatchQueue.main.async {
                    print("❌ Decoding error: \(error.localizedDescription)")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("📦 Raw JSON: \(jsonString)")
                    }
                    self.onError?(error)
                }
            }
        }
        
        task.resume()
    }
}
