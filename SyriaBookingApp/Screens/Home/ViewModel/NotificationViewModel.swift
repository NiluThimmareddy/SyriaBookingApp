//
//  NotificationViewModel.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 18/09/25.
//

import Foundation
class NotificationViewModel {
    var BookingHistoryArray = [BookingHistoryModel]()
    var BookingListArray = [BookingDetailsModel]()
    var filteredHistoryArray =  [BookingHistoryModel]()
    var onError : ((String)->Void)?
    var onSuccess : (([BookingHistoryModel])->Void)?
    var onBookingSuccess : (([BookingDetailsModel])->Void)?
    var onCountSuccess : ((NotificationCountModel) -> Void)?
    
    func fetchNotificationUser(userId:String,includePast:Bool = false){
        guard var url = APIURL.notification.url?.absoluteString else { return }
        
        url += "\(userId)?includePast=\(includePast)&take=50"
        
        guard let url = URL(string: url) else{
            onError?("Invalid Url")
            return
        }
        
        APIManager.shared.fetchData(from: url, modelType: BookingHistoryResponseModel.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.BookingHistoryArray = success.data
                self.onSuccess?(success.data)
            case .failure(let failure):
                self.onError?(failure.localizedDescription)
            }
        }
    }
    
    func fetchUserBookings(userId:String,includePast:Bool = false){
        guard var url = APIURL.notification.url?.absoluteString else { return }
        
        url += "\(userId)"
        
        guard let url = URL(string: url) else{
            onError?("Invalid Url")
            return
        }
        
        APIManager.shared.fetchData(from: url, modelType: BookingDetailsResponseModel.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.BookingListArray = success.data
                self.onBookingSuccess?(success.data)
            case .failure(let failure):
                self.onError?(failure.localizedDescription)
            }
        }
    }
    
    func fetchNotificationCount(userId:String){
        guard var url = APIURL.notificationCount.url?.absoluteString else { return }        
        url += "\(userId)"
        
        guard let url = URL(string: url) else{
            onError?("Invalid Url")
            return
        }
        
        
        APIManager.shared.fetchData(from: url, modelType: NotificationCountModel.self) { [weak self] result in            
            guard let self = self else { return }
            switch result {
            case .success(let success):
              print(success)
                self.onCountSuccess?(success)
            case .failure(let failure):
                self.onError?(failure.localizedDescription)
            }
        }
        
    }
}
