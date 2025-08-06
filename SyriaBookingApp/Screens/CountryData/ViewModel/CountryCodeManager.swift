//
//  CountryCodeManager.swift
//  HotelBooking
//
//  Created by praveenkumar on 30/05/25.
//


import Foundation

class CountryCodeManager {
    static let shared = CountryCodeManager()
    private(set) var nameToCode: [String: String] = [:]

    private init() {}

    func fetchCountryCodes(completion: @escaping () -> Void) {
        guard let url = URL(string: "https://flagcdn.com/en/codes.json") else {
            print("❌ Invalid URL")
            return
        }
       
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("❌ Error fetching codes: \(error)")
                return
            }

            guard let data = data,
                  let codeMap = try? JSONDecoder().decode([String: String].self, from: data) else {
                print("❌ Error decoding country code data")
                return
            }

            // Reverse the map: name -> code
            let reversed = codeMap.reduce(into: [String: String]()) { dict, pair in
                dict[pair.value.lowercased()] = pair.key.lowercased()
            }

            self.nameToCode = reversed
            completion()
        }.resume()
    }
}
