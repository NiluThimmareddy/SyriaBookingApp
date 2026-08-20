//
//  BookingModel.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 22/08/25.
//

import Foundation

struct BookingResponse : Codable{
    let message: String
    let data: BookingModel
}

struct BookingModel: Codable {
    let id: String
    var name: String
    var mobile: String
    var address: String
    var gender: String
    var email: String
    var country: String
    var dob: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, mobile, address, gender, email, country, dob
    }
    
    init(id: String, name: String, mobile: String, address: String, gender: String, email: String, country: String, dob: String) {
        self.id = id
        self.name = name
        self.mobile = mobile
        self.address = address
        self.gender = gender
        self.email = email
        self.country = country
        self.dob = dob
    }
    
   
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""   
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.mobile = try container.decodeIfPresent(String.self, forKey: .mobile) ?? ""
        self.address = try container.decodeIfPresent(String.self, forKey: .address) ?? ""
        self.gender = try container.decodeIfPresent(String.self, forKey: .gender) ?? ""
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.country = try container.decodeIfPresent(String.self, forKey: .country) ?? ""
        self.dob = try container.decodeIfPresent(String.self, forKey: .dob) ?? ""
    }
}

struct OTPResponseModel : Codable {
  let  message: String
  let  data: OTPModel?
       
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decode(String.self, forKey: .message)
        self.data = try container.decode(OTPModel.self, forKey: .data)
    }
}

struct  OTPModel : Codable {
    let delivery: String
    let to: String
    let expiresAtUtc : String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.delivery = try container.decode(String.self, forKey: .delivery)
        self.to = try container.decode(String.self, forKey: .to)
        self.expiresAtUtc = try container.decode(String.self, forKey: .expiresAtUtc)
       
    }
}


struct VerifyOTPModel : Codable{
    let message: String
    let data: UserData
}

struct VerifyEmailOTPModel : Codable{
    let message: String
    let data: UserEmailData
}

struct UserData: Codable {
    let userId: String
}

struct UserEmailData: Codable {
    let email: String
}

struct PostBookingWrapper: Codable {
    let data: PostBookingResponse?
    let success: Bool?
    let message: String?
}

struct PostBookingResponse: Codable {
    let id: String?
    let timestamp: String?
    let userId: String?
    let hotelId: String?
    let roomId: String?
    let guestName: String?
    let guestPhone: String?
    let guestEmail: String?
    let numberOfGuests: Int?
    let checkIn: String?
    let checkOut: String?
    let bookingStatus: String?
    let bookingDetails: String?
    let totalAmount: Double?
}

struct PostBookingRequestEncodable: Encodable {
    let userId: String
    let hotelId: String
    let roomId: String
    let guestName: String
    let guestPhone: String
    let guestEmail: String
    let numberOfGuests: Int
    let checkIn: String
    let checkOut: String
    let totalAmount: Double
    let bookingDetails: String
    let bookingType: String
    let totalDiscount: Double
    let netTotal: Double
}


struct BookingHistoryDetailsResponseModel: Codable {
    let message: String
    let data: BookingHistoryDataModel
}

struct BookingHistoryDataModel: Codable {
    let id: String
    let timestamp: String
    let userId: String
    let hotelId: String
    let roomId: String
    let guestName: String
    let guestPhone: String
    let guestEmail: String
    let numberOfGuests: Int
    let checkIn: String
    let checkOut: String
    let bookingStatus: String
    let bookingDetails: String
    let totalAmount: Double
    let bookingType: String
    let totalDiscount: Double
    let netTotal: Double
}


struct SendEmailOtpRequest: Encodable {
    let email: String
}

struct SendMobileOTPRequest: Encodable {
    let mobile: String
}

struct sendRegestrationEmailOTPRequest : Encodable {
    let email : String
}

struct VerifyRegistrationEmailOTPResponse: Codable {
    let message: String
    let data: verifyEmailOtpData?
}

struct verifyEmailOtpData: Codable {
    let email: String
    let verified: Bool
}

struct VerifyMobileOTPRequest: Encodable {
    let mobile: String
    let code: String
}

struct VerifyEmailOtpRequest: Encodable {
    let email: String
    let code: String
}

struct VerifyLoginResponse : Decodable{
    let message: String
    let data: LoginResponseData?
}


struct LoginResponseData: Decodable {
    let userId: String
    let token: String
    let expiresAtUtc: String
    
}

struct RegistrationVerifyResponse: Decodable {
    let isVerified: Bool
}

struct CheckMobileRequest: Encodable {
    let mobile: String
}

struct CheckMobileResponse: Decodable {
    let message: String
    let data: CheckMobileData
}

struct CheckMobileData: Decodable {
    let exists: Bool
    let userId: String?
    let name: String?
    let mobile: String?
    let email: String?
    let maskedEmail: String?
}
