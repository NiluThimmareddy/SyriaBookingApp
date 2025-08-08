//
//  HotelViewModel.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 27/07/25.
//

import Foundation

class HotelViewModel {
    
    var hotels: HotelResponse?
    var filteredHotels: [Hotel] = []
    var recentlyViewdHotels : [Hotel] = []
    var onDataLoaded: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    func fetchHotels(){
        
        if NetworkMonitor.shared.isReachable() {
            
           
                guard let url = APIURL.HotelURL.url else {
                    print("invalid hotel url")
                    return
                }
                
                APIManager.shared.fetchData(from: url, modelType: HotelResponse.self) { [weak self] result in
                    switch result {
                    case .success(let response):
                        self?.hotels = response
                        self?.filteredHotels = response.data
                        HotelDataMaganer.shared.allHotels = response.data
                        
                        
                        self?.onDataLoaded?()
                    case .failure(let error):
                        self?.onError?(error)
                    }
                }
             
        }else {
            self.onError?(NSError(domain: "", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No internet connection"]))
        }
        
    }
    
    func fetchRecentlyVieeHotels(completion : () -> Void){
        var ids = [String]()
      
        for  i in HotelDataMaganer.shared.RecentlyViewdHotelIds{
            let id = i.object(forKey: "HotelId") as? String
            if let id = id {
                ids.append(id)
            }
            
        }
        
        self.recentlyViewdHotels = self.hotels?.data.filter({ hotel in
             return ids.contains(hotel.id)
        }) ?? []
        
    print("Recently viewd Hotels....: \(recentlyViewdHotels)")
        completion()
    }
}
