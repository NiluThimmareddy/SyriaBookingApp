//
//  CountryModel.swift
//  HotelBooking
//
//  Created by praveenkumar on 30/05/25.
//


import Foundation

struct Country: Codable {
    let code: String // eg. Ag
    let name: String
    
}

struct CountryCodeDataSource: Codable {
    let code: String
    let label: String
    let phone: String
    let phoneLength: PhoneLength?

    enum CodingKeys: String, CodingKey {
        case code, label, phone, phoneLength
    }

    enum PhoneLength: Codable {
        case single(Int)
        case multiple([Int])

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let intValue = try? container.decode(Int.self) {
                self = .single(intValue)
            } else if let arrayValue = try? container.decode([Int].self) {
                self = .multiple(arrayValue)
            } else {
                throw DecodingError.typeMismatch(
                    PhoneLength.self,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Expected Int or [Int] for phoneLength"
                    )
                )
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .single(let value):
                try container.encode(value)
            case .multiple(let values):
                try container.encode(values)
            }
        }
    }
}
