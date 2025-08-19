//
//  NetworkRetryManager.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 13/08/25.
//
import UIKit


class NetworkRetryManager {
    
    static func executeWithNetworkRetry(
        observerKey: String,
        noInternetMessage: String = "No internet connection",
        showAlertOnFail: Bool = true,
        onError: ((Error) -> Void)? = nil,
        action: @escaping () -> Void
    ) {
        
        if NetworkMonitor.shared.isConnected {
            action()
        } else {
            if showAlertOnFail && HotelDataMaganer.shared.allHotels.isEmpty {
                UIApplication.showNetworkLostAlertAndRetry(observerKey: observerKey, action: action)
            } else {
                onError?(NSError(
                    domain: "",
                    code: -1009,
                    userInfo: [NSLocalizedDescriptionKey: noInternetMessage]
                ))
                NetworkMonitor.shared.addStatusObserver(observerKey) { isConnected in
                    if isConnected {
                        NetworkMonitor.shared.removeStatusObserver(observerKey)
                        action()
                    }
                }
            }
        }
    }
}
