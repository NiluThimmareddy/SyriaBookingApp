//
//  Constant.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import Foundation

enum APIURL{
   
    case HotelURL
    
   
    private var baseURL: String {
        return "https://syriabookingcacheapi.azurewebsites.net/api/HotelPublic/aggregates/"
    }
    
    //= "https://syriabookingcacheapi.azurewebsites.net/api/HotelPublic/aggregates/"
    
    var url : URL? {
        switch self {
        case .HotelURL:
            return  URL(string: baseURL)
        }
    }
}
