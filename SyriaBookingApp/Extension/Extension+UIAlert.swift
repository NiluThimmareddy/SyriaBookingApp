//
//  Extension+UIAlert.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 05/08/25.
//


import Foundation
import UIKit
import ObjectiveC

extension UIViewController{
    enum AlertType{
        case success
        case error
        case info
    }
    
    func showAlert(title:String,message:String,type: AlertType = .info,OkButtonTitle: String = "OK",cancelButtonTitle:String? = nil,onOK : (()-> Void)? = nil,onCancel: (()-> Void)? = nil){
        var finalTitle = title
        switch type {
        case .success : finalTitle =  "✅ " + title
        case .error : finalTitle = "❌ " + title
        case .info: finalTitle = "ℹ️ " + title
        }
        
        let alert = UIAlertController(title: finalTitle, message: message, preferredStyle: .alert)
        
        //Ok button Action
        alert.addAction(UIAlertAction(title: OkButtonTitle  , style: .default) { _ in
            onOK?()
        })
        //Optional Delete Button Action
        
        if let cancel = cancelButtonTitle {
            alert.addAction(UIAlertAction(title: cancel, style: .cancel) { _ in
                self.dismiss(animated: true)
            })
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "SyriaBooking", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}


extension Error {
    var userMessage: String {
        if let apiError = self as? APIError {
            switch apiError {
            case .userNotFound:
                return "User not found"
            case .invalidURL:
                return "Something went wrong. Please try again."
            case .noData:
                return "No data available."
            case .serverError:
                return "Server error. Please try later."
            case .invalidResponse:
                return "Invalid response from server."
            case .decodingFailed:
                return "Something went wrong. Please try again."
            case .EnterValidData:
                return "Enter valid data"
            }
        }
        return "Something went wrong. Please try again."
    }
}
