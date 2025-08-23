//
//  Constant.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import Foundation

enum APIURL{
   
    case BaseURL
    case HotelURL
    case BookingURL
   
     var baseURL: String {
        return "https://syriabookingcacheapi.azurewebsites.net/api/"
    }
    
    //= "https://syriabookingcacheapi.azurewebsites.net/api/HotelPublic/aggregates/"
    
    var url : URL? {
        switch self {
            
        case .BaseURL:
            return  URL(string: baseURL)
        case .HotelURL:
            return  URL(string: baseURL + "HotelPublic/aggregates/")
        case .BookingURL:
            return URL(string: baseURL + "UserPublic")
            
       
        }
    }
    
    
}
