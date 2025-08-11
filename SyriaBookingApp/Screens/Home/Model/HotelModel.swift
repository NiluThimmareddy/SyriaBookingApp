//
//  HotelModel.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import Foundation

struct HotelResponse: Codable {
    let message: String
    let data: [Hotel]
}

struct Hotel: Codable {
    let id, name: String
    let city: String
    let shortDescription, description: String?
    let type: HotelType
    let starRating: Int
    let hotelChain: String?
    let addressLine1, addressLine2: String?
    let stateOrProvince: StateOrProvince?
    let postalCode, country, email, primaryPhone: String?
    let checkInTime, checkOutTime, acceptedCurrencies: String?
    let languagesSpoken: LanguagesSpoken
    let covidSafetyLevel: CovidSafetyLevel
    let discountText: String?
    let coverImageURL: String?
    let facilities: String?
    let landmarkDescription: String?
    let averageRating: String
    let reviewCount: String
    let minRoomPrice: String
    let amenities: String?
    let coverImageSignedURL: String?
    let reviews: [Review]
    let landmarks: [Landmark]
    let images: [String]
    let rooms: [RoomElement]
    
    enum CodingKeys: String, CodingKey {
        case id, name, city, shortDescription, description, type, starRating, hotelChain, addressLine1, addressLine2, stateOrProvince, postalCode, country, email, primaryPhone, checkInTime, checkOutTime, acceptedCurrencies, languagesSpoken, covidSafetyLevel, discountText
        case coverImageURL = "coverImageUrl"
        case facilities, landmarkDescription, averageRating, reviewCount, minRoomPrice, amenities
        case coverImageSignedURL = "coverImageSignedUrl"
        case reviews, landmarks, images, rooms
    }
}

enum City: String, Codable {
    case aleppo = "Aleppo"
    case damascus = "Damascus"
    case homs = "Homs"
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = City(rawValue: raw) ?? .unknown
    }
}

enum HotelType: String, Codable {
    case hotel = "Hotel"
    case motel = "Motel"
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = HotelType(rawValue: raw) ?? .unknown
    }
}

enum StateOrProvince: String, Codable {
    case aleppo = "Aleppo"
    case damascus = "Damascus"
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = StateOrProvince(rawValue: raw) ?? .unknown
    }
}

enum LanguagesSpoken: String, Codable {
    case arabic = "Arabic"
    case englishArabic = "English, Arabic"
    case englishHindiArabicChinese = "English, Hindi, Arabic, Chinese"
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = LanguagesSpoken(rawValue: raw) ?? .unknown
    }
}

enum CovidSafetyLevel: String, Codable {
    case certified = "Certified"
    case notSpecified = "NotSpecified"
    case empty = ""
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = CovidSafetyLevel(rawValue: raw) ?? .unknown
    }
}

// MARK: - Submodels

struct Landmark: Codable {
    let id, hotelID, name, landmarkType: String
    let distanceKM: Double
    let isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case hotelID = "hotelId"
        case name, landmarkType
        case distanceKM = "distanceKm"
        case isActive
    }
}

struct Review: Codable {
    let id, hotelID, reviewerName: String
    let rating: Int
    let reviewText: String?
    let createdOn: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case hotelID = "hotelId"
        case reviewerName, rating, reviewText, createdOn
    }
}

struct RoomElement: Codable {
    let room: RoomDetails
    let coverImage: String?
    var rates: [Rate]
    
    
}

struct Rate: Codable {
    let id, roomID, effectiveDate: String
    let price: Int
    let notes: String?
    
    var isSelected: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case roomID = "roomId"
        case effectiveDate, price, notes
    }
}

struct RoomDetails: Codable {
    let id, hotelID, roomType, bedType: String
    let maxAdults, maxChildren: Int
    let roomSize: String?
    let basePrice: Int
    let roomStatus, refundPolicy: String?
    let breakfastIncluded: Bool
    let availableRooms: Int
    let description: String?
    let amenities: String?
    let inventory: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case hotelID = "hotelId"
        case roomType, bedType, maxAdults, maxChildren, roomSize, basePrice, roomStatus, refundPolicy, breakfastIncluded, availableRooms, description, amenities, inventory
    }
}
