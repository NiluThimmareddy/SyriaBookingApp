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


