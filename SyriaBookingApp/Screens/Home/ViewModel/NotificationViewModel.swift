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
    var onError : ((Error)->Void)?
    var onSuccess : (([BookingHistoryModel])->Void)?
    var onBookingSuccess : (([BookingDetailsModel])->Void)?
    var onCountSuccess : ((NotificationCountModel) -> Void)?
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func fetchNotificationUser(includePast:Bool = true){
        var url = APIURL.notification.url.absoluteString
        url += "?includePast=\(includePast)&take=50"
        
        guard let url = URL(string: url) else{
            onError?(NetworkError.invalidURL)
            return
        }
        
        APIManager.shared.fetchData(from: url, requiresJWT: true, modelType: BookingHistoryResponseModel.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.BookingHistoryArray = success.data
                    
                    self.onSuccess?(success.data)
                }
            case .failure(let failure):
#if DEBUG
                print("fetchNotificationUser :", failure.localizedDescription)
#endif
                self.onError?(failure)
            }
        }
    }
    
    func fetchNotificationCount() async throws -> NotificationCountModel {
        try await apiClient.send(
            endpoint: .fetchUserNotificationCount(),
            responseType: NotificationCountModel.self
        )
    }
}

extension Endpoint{
    static func fetchUserNotificationCount() -> Endpoint{
        Endpoint(
            path: APIURL.notificationCount.url,
            method: .get,
            authentication: .jwt
        )
    }
}
