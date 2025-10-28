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

struct SignleHoteResponseModel : Codable {
    let message: String
    let data: Hotel
}

struct Hotel: Codable {
    let id, name: String
    let city: String
    let nameAR: String?
    let cityAR: String?
    let shortDescriptionAR, shortDescription: String?
    let descriptionAR, description: String?
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
    var reviews: [Review]
    let landmarks: [Landmark]
    let images: [String]
    let rooms: [RoomElement]

    enum CodingKeys: String, CodingKey {
        case id, name, nameAR, city, cityAR, shortDescription, description, type, starRating, hotelChain, addressLine1, addressLine2, stateOrProvince, postalCode, country, email, primaryPhone, checkInTime, checkOutTime, acceptedCurrencies, languagesSpoken, covidSafetyLevel, discountText,shortDescriptionAR,descriptionAR
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

struct ReviewResponse : Codable{
    let message: String
    let data: Review
}

struct RoomElement: Codable {
    let room: RoomDetails
    let coverImage: String?
    var rates: [Rate]
    let images: [String]? 
}

struct Rate: Codable {
    let id, roomID, effectiveDate: String
    let price: Double
    let notes: String?
    let discount: Double?
    let localPrice: Double?
    let localDiscount: Double?
    var selectedQuantity: Int = 1
    var isSelected: Bool = false
    var isLocal : Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case roomID = "roomId"
        case effectiveDate, price, notes
        case discount,localPrice,localDiscount
    }
}

struct RoomDetails: Codable {
    let id, hotelID, roomType, bedType: String
    let maxAdults, maxChildren: Int
    let roomSize: String?
    let basePrice: Double
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


struct ReporAnAppModel: Codable {
    let message : String
}

struct Booking {
    let id: String
    let hotelName: String
    let roomType: String
    let checkIn: String
    let checkOut: String
    let totalAmount: Double
    var status: String   // pending, confirmed, cancelled
}

struct BookingHistoryResponseModel : Codable {
    var message : String
    var data : [BookingHistoryModel]
}
struct BookingHistoryModel: Codable {
    let id: String
    let type: String
    var status: String
    let hotelId: String
    let roomId: String
    let hotelName: String
    let roomType: String
    let checkInUtc: String
    let checkOutUtc: String
    let totalAmount: Double
    let lastUpdatedUtc: String
    let title: String
    let subtitle: String
    let deepLink: String
}

struct NotificationCountModel : Codable {
    let count : Int
}

struct BookingDetailsResponseModel : Codable {
    var message : String
    var data : [BookingDetailsModel]
}
struct BookingDetailsModel:Codable{
    var id : String
    var timestamp : String
    var userId : String
    var hotelId: String
    var guestName : String
    var guestPhone : String
    var guestEmail : String
    var numberOfGuests : Int
    var checkIn : String
    var checkOut : String
    var bookingStatus : String
    var bookingDetails : String
    var totalAmount : Double
    var bookingType : String
    var totalDiscount : Double
    var netTotal : Double
  
}
/*
"id": "BK00125",
"timestamp": "2025-09-29T18:14:49.9357803+00:00",
"userId": "UP00193",
"hotelId": "H00041",
"roomId": "R00064",
"guestName": "Nilu",
"guestPhone": "9986749841",
"guestEmail": "niluk3700@gmail.com",
"numberOfGuests": 2,
"checkIn": "2025-09-18T00:00:00Z",
"checkOut": "2025-09-22T00:00:00Z",
"bookingStatus": "Cancelled",
"bookingDetails": "$50: Base Price Qty 1 - Total $50.00\r\n$10: Extra Bed Qty 1 - Total $10.00",
"totalAmount": 240,
"bookingType": "International",
"totalDiscount": 0,
"netTotal": 240
*/
