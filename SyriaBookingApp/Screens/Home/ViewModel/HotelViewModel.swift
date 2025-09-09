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
 
    
    var onSuccess: ((Review) -> Void)?
    var onReporAnAppSucess : ((ReporAnAppModel)->Void)?
    var onReviewError: ((String) -> Void)?
    
    var filteredHotelsCopy : [Hotel] = []
    
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
                    self.filteredHotelsCopy = response.data
                    HotelDataMaganer.shared.allHotels = response.data
                    self.onDataLoaded?()
                case .failure(let error):
                    self.onError?(error)
                }
            }
        }
    }
    
    func   fetchReviewsOfHotel(hotelId:String,reviewId:String = ""){
      NetworkRetryManager.executeWithNetworkRetry(
          observerKey: "FetchHotelsRetry",
          showAlertOnFail: true,
          onError: onError
      ) { [weak self] in
          guard let self = self else { return }
          
          guard let urlstr = APIURL.fetchHotelReviews.url?.absoluteString else { return }
          let getUrl = urlstr + "/\(hotelId)/\(reviewId)"
          let url = URL(string: getUrl)
         
        
          guard let url = url else {
              print("Invalid hotel URL")
              return
          }
          
          

          APIManager.shared.fetchData(from: url, modelType: Review.self) { result in
              switch result {
              case .success(let response):
                  self.onSuccess?(response)
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
    
    
    
    func filterHotelsBasedOnSearch(searchText: String){
        
        if searchText.isEmpty{
            filteredHotels = filteredHotelsCopy
        }else{
            filteredHotels = filteredHotelsCopy.filter{ hotel in
                
                hotel.name.lowercased().contains(searchText.lowercased()) || hotel.city.lowercased().contains(searchText.lowercased())
                
            } 
        }
    }
    
    
    func SubmitReview(HotelId: String, reviewerName: String, rating: Int , reviewText: String)
    {

        let params: [String: Any] = [
            "hotelId": HotelId,
            "reviewerName": reviewerName,
            "rating": rating,
            "reviewText": reviewText
        ]
        
        guard let url =  APIURL.PostReview.url else {
            self.onReviewError?("Invalid URL")
            return
        }
        
        APIManager.shared.postRequest(urlString: url , body: params, responseType: ReviewResponse.self) { result in
            DispatchQueue.main.async{
                switch result {
                case .success(let response):
                    self.onSuccess?(response.data)
                case .failure(let failure):
                    self.onReviewError?(failure.localizedDescription)
                }
            }
        }
    }
    
    func submitReporAnApp(subject:String,message:String,userName:String,UserEmail:String,userPhone:String){
       
        let params: [String: Any] = [
            "type": "",
            "subject": subject,
            "message": message,
            "hotelId": "",
            "hotelName": "",
            "bookingId": "",
            "userName": userName,
            "userEmail": UserEmail,
            "userPhone": userPhone
        ]
        
        guard let url =  APIURL.postReportAnApp.url else {
            self.onReviewError?("Invalid URL")
            return
        }
        
        APIManager.shared.postRequest(urlString: url , body: params, responseType: ReporAnAppModel.self) { result in
            DispatchQueue.main.async{
                switch result {
                case .success(let response):
                    self.onReporAnAppSucess?(response)
                case .failure(let failure):
                    self.onReviewError?(failure.localizedDescription)
                }
            }
        }
    }
}
 
