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
    let name: String
    let mobile: String
    let address: String
    let gender: String
    let email: String
    let country: String
    let dob: String
    
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
  let  data: OTPModel
       
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
    let otp : String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.delivery = try container.decode(String.self, forKey: .delivery)
        self.to = try container.decode(String.self, forKey: .to)
        self.expiresAtUtc = try container.decode(String.self, forKey: .expiresAtUtc)
        self.otp = try container.decode(String.self, forKey: .otp)
    }
}


struct VerifyOTPModel : Codable{
    let message: String
    let data: UserData
}

struct UserData: Codable {
    let userId: String
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
}
