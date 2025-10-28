//  Constant.swift
//  SyriaBookingApp
//  Created by ToqSoft on 25/07/25.

import Foundation

enum APIURL{
    case BaseURL
    case HotelURL
    case BookingURL
    case PostReview
    case fetchHotelReviews
    case postReportAnApp
    case postForOTP
    case verifyOTP
    case postBooking
    case notification
    case notificationCount
    case updateProfile
        
    //Production URL
//    var baseURL: String {
//        return "https://syriabookingcacheapi.azurewebsites.net/api/"
//
//    }
    
   //Development URL
    var baseURL: String {
        return "https://syriabookingstage.azurewebsites.net/public-api/api/"
    }
    
    var url : URL? {
        switch self {
        case .BaseURL:
            return  URL(string: baseURL)
        case .HotelURL:
            return  URL(string: baseURL + "HotelPublic/aggregates/")
        case .BookingURL:
            return URL(string: baseURL + "UserPublic")
        case .PostReview :
            return URL(string: baseURL + "HotelReviewPublic/")
        case .fetchHotelReviews:
            return URL(string: baseURL + "/HotelReviewPublic/")
        case .postReportAnApp:
            return URL(string: baseURL + "/ContactPublic")
        case .postForOTP:
            return URL(string: baseURL + "UserPublic/send-otp")
        case .verifyOTP:
            return URL(string: baseURL + "UserPublic/verify-otp")
        case .postBooking:
            return URL(string: baseURL + "BookingPublic/")
        case .notification:
            return URL(string: baseURL + "BookingPublic/Notifications-by-user/")
        case . notificationCount:
            return URL(string: baseURL + "BookingPublic/Notifications-count-by-user/")
        case .updateProfile:
            return URL(string: baseURL + "UserPublic/")
        }
    }
}

