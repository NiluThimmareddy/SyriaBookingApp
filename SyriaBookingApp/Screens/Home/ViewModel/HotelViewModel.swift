//
//  HotelViewModel.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 27/07/25.
//

import Foundation
class HotelViewModel{
    var Hotels: HotelResponse?
    var onDataLoaded: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    func fetchHotels(){
        guard let url = APIURL.HotelURL.url else {
            print("invalid hotel url")
            return
        }
        
        APIManager.shared.fetchData(from: url, modeltType: HotelResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.Hotels = response
                self?.onDataLoaded?()
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
}
