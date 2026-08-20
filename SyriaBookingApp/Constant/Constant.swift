
//
//  Constant.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import Foundation

enum APIConstants {

    static let baseURL: URL = {

        var dnm : String {
                return "v}wohjxyvuqk"
            }
        
        var sb : String{
            return "vfu{itrml|l"
        }

            var sy : String {
                return "v}"
            }
            
            var plik : String {
                return "sygrpk"
            }
            
            var apy : String {
                return "dtn"
            }
            
            var tg : String {
                return "vxfml"
            }
            
            var azwest : String {
                return "d~zxl nl~uwix"
            }
            
            var nt : String {
                return "qiy"
            }
        
       //MARK: PRODUCTION
       let decryptedURL =
        "https://" +
        URLCrypto.decrypt(sb) +
        "." +
        URLCrypto.decrypt(azwest) +
        "." +
        URLCrypto.decrypt(nt) +
        "/" +
        
        URLCrypto.decrypt(apy) +
        "/"
        
        //MARK: STAG
//            let decryptedURL  =
//                 "https://sbstage2.azurewebsites.net/public-api/api/"

                guard let url = URL(string: decryptedURL) else {
                    fatalError("❌ Cannot create URL from decrypted API URL")
                }
                return url  
    }()
    
    static let headerAPIKey = "X-API-KEY"
    
    static let apiKey: String = {
        guard let value = Bundle.main.object(forInfoDictionaryKey: headerAPIKey) as? String else {
            fatalError("❌ HOTELBOOKING_API_KEY is missing")
        }
        return value
    }()
}

enum APIURL {

    case baseURL
    case hotelURL
    case bookingURL
    case postReview
    case fetchHotelReviews
    case postReportAnApp
    case postForOTP
    case postForEmailOTP
    case verifyOTP
    case verifyEmailOTP
    case postForNewUserOTP
    case verifyNewUserOTP
    case postBooking
    case notification
    case notificationCount
    case updateProfile
    case applyCareer
    case checkMobile

    var url: URL {

        switch self {
        case .baseURL:
            return APIConstants.baseURL

        case .hotelURL:
            return APIConstants.baseURL
                .appendingPathComponent("HotelPublic")
                .appendingPathComponent("aggregates")

        case .bookingURL:
            return APIConstants.baseURL
                .appendingPathComponent("UserPublic")

        case .postReview:
            return APIConstants.baseURL
                .appendingPathComponent("HotelReviewPublic")

        case .fetchHotelReviews:
            return APIConstants.baseURL
                .appendingPathComponent("HotelReviewPublic")

        case .postReportAnApp:
            return APIConstants.baseURL
                .appendingPathComponent("ContactPublic")

        case .postForOTP:
            return APIConstants.baseURL
                .appendingPathComponent("UserPublic")
                .appendingPathComponent("send-otp")

        case .postForEmailOTP:
            return APIConstants.baseURL
                .appendingPathComponent("UserPublic")
                .appendingPathComponent("send-email-otp")

        case .verifyOTP:
            return APIConstants.baseURL
                .appendingPathComponent("UserPublic")
                .appendingPathComponent("verify-otp")

        case .verifyEmailOTP:
            return APIConstants.baseURL
                .appendingPathComponent("UserPublic")
                .appendingPathComponent("verify-email-otp")
            
        case .postForNewUserOTP:
            return APIConstants.baseURL
                .appendingPathComponent("UserPublic")
                .appendingPathComponent("send-registration-email-otp")

        case .verifyNewUserOTP:
            return APIConstants.baseURL
                .appendingPathComponent("UserPublic")
                .appendingPathComponent("verify-registration-email-otp")

        case .postBooking:
            return APIConstants.baseURL
                .appendingPathComponent("BookingPublic")

        case .notification:
            return APIConstants.baseURL
                .appendingPathComponent("BookingPublic")
                .appendingPathComponent("notifications")
                .appendingPathComponent("me")
            

        case .notificationCount:
            return APIConstants.baseURL
                .appendingPathComponent("BookingPublic")
                .appendingPathComponent("notifications-count")
                .appendingPathComponent("me")

        case .updateProfile:
            return APIConstants.baseURL
                .appendingPathComponent("UserPublic")

        case .applyCareer:
            return APIConstants.baseURL
                .appendingPathComponent("CareerPublic")
                .appendingPathComponent("apply")
            
        case .checkMobile:
            return APIConstants.baseURL
                .appendingPathComponent("UserPublic")
                .appendingPathComponent("check-mobile")
            
        }
    }
}
