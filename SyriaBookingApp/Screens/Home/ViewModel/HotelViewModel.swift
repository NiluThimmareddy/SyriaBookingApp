//
//  HotelViewModel.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 27/07/25.
//

import Foundation

//import Foundation
//
//class HotelViewModel {
//    
//    var hotels: HotelResponse?
//    var filteredHotels: [Hotel] = []
//    var recentlyViewdHotels : [Hotel] = []
//    var onDataLoaded: (() -> Void)?
//    var onError: ((Error) -> Void)?
//    
//    func fetchHotels(){
//        
//        if NetworkMonitor.shared.isReachable() {
//            
//           
//                guard let url = APIURL.HotelURL.url else {
//                    print("invalid hotel url")
//                    return
//                }
//                
//                APIManager.shared.fetchData(from: url, modelType: HotelResponse.self) { [weak self] result in
//                    switch result {
//                    case .success(let response):
//                        self?.hotels = response
//                        self?.filteredHotels = response.data
//                        HotelDataMaganer.shared.allHotels = response.data
//                        
//                        
//                        self?.onDataLoaded?()
//                    case .failure(let error):
//                        self?.onError?(error)
//                    }
//                }
//             
//        }else {
//            self.onError?(NSError(domain: "", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No internet connection"]))
//        }
//        
//    }
//    
//    
//    func fetchRecentlyViewedHotels(completion: () -> Void) {
//        var ids = HotelDataMaganer.shared.recentlyViewedHotelIds
//            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
//        
//        guard let allHotels = self.hotels?.data else {
//            self.recentlyViewdHotels = []
//            completion()
//            return
//        }
//        
//        // Match hotels in order
//        self.recentlyViewdHotels = ids.compactMap { id in
//            allHotels.first {
//                $0.id.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == id
//            }
//        }
//        
//        // Remove missing hotels
//        let validIDs = self.recentlyViewdHotels.map {
//            $0.id.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
//        }
//        ids = ids.filter { validIDs.contains($0) }
//        
//        // Enforce max 10
//        if ids.count > 10 {
//            ids = Array(ids.prefix(10))
//            self.recentlyViewdHotels = Array(self.recentlyViewdHotels.prefix(10))
//        }
//        
//        // Save cleaned IDs
//        HotelDataMaganer.shared.recentlyViewedHotelIds = ids
//        UserDefaults.standard.set(ids, forKey: "RecentlyViewedHotelIDs")
//        
//        completion()
//    }
//}

class HotelViewModel {
    
    var hotels: HotelResponse?
    var filteredHotels: [Hotel] = []
    var recentlyViewdHotels : [Hotel] = []
    var onDataLoaded: (() -> Void)?
    var onError: ((Error) -> Void)?
 
    
    func fetchHotels() {
        NetworkRetryManager.executeWithNetworkRetry(
            observerKey: "FetchHotelsRetry",
            showAlertOnFail: true,
            onError: onError
        ) { [weak self] in
            guard let self = self else { return }
            guard let url = APIURL.HotelURL.url else {
                print("Invalid hotel URL")
                return
            }
 
            APIManager.shared.fetchData(from: url, modelType: HotelResponse.self) { result in
                switch result {
                case .success(let response):
                    self.hotels = response
                    self.filteredHotels = response.data
                    HotelDataMaganer.shared.allHotels = response.data
                    self.onDataLoaded?()
                case .failure(let error):
                    self.onError?(error)
                }
            }
        }
    }
 
    
    func fetchRecentlyViewedHotels(completion: () -> Void) {
        var ids = HotelDataMaganer.shared.recentlyViewedHotelIds
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
        
        guard let allHotels = self.hotels?.data else {
            self.recentlyViewdHotels = []
            completion()
            return
        }
        
        // Match hotels in order
        self.recentlyViewdHotels = ids.compactMap { id in
            allHotels.first {
                $0.id.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == id
            }
        }
        
        // Remove missing hotels
        let validIDs = self.recentlyViewdHotels.map {
            $0.id.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        }
        ids = ids.filter { validIDs.contains($0) }
        
        // Enforce max 10
        if ids.count > 10 {
            ids = Array(ids.prefix(10))
            self.recentlyViewdHotels = Array(self.recentlyViewdHotels.prefix(10))
        }
        
        // Save cleaned IDs
        HotelDataMaganer.shared.recentlyViewedHotelIds = ids
        UserDefaults.standard.set(ids, forKey: "RecentlyViewedHotelIDs")
        
        completion()
    }
}
 
