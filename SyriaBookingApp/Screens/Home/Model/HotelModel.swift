//
//  HotelModel.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import Foundation
import UIKit

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
    let cityAR: String
    let shortDescriptionAR, shortDescription: String?
    let descriptionAR, description: String?
    let type: HotelType
    let starRating: Int
    let hotelChain: String?
    let addressLine1, addressLine2: String?
    let stateOrProvince: String?
    let postalCode, country, email, primaryPhone: String?
    let checkInTime, checkOutTime, acceptedCurrencies: String?
    let languagesSpoken: LanguagesSpoken
    let covidSafetyLevel: CovidSafetyLevel
    let discountText: String?
    let coverImageURL: String?
    let facilities: String?
    let policies: String
    let landmarkDescription: String?
    let averageRating: String
    let reviewCount: String
    let latitude : String?
    let longitude : String?
    let minRoomPrice: String
    let amenities: String?
    let coverImageSignedURL: String?
    var reviews: [Review]
    let landmarks: [Landmark]
    let images: [String]
    let rooms: [RoomElement]
    let discountName : String?

    enum CodingKeys: String, CodingKey {
        case id, name, nameAR, city, cityAR, shortDescription, description, type, starRating, hotelChain, addressLine1, addressLine2, stateOrProvince, postalCode, country, email, primaryPhone, checkInTime, checkOutTime, acceptedCurrencies, languagesSpoken, covidSafetyLevel, discountText,shortDescriptionAR,descriptionAR, discountName
        case coverImageURL = "coverImageUrl"
        case facilities, landmarkDescription, averageRating, reviewCount,latitude, longitude , minRoomPrice, amenities, policies
        case coverImageSignedURL = "coverImageSignedUrl"
        case reviews, landmarks, images, rooms
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.nameAR = try container.decodeIfPresent(String.self, forKey: .nameAR)
        self.city = try container.decode(String.self, forKey: .city)
        self.cityAR = try container.decode(String.self, forKey: .cityAR)
        self.shortDescription = try container.decodeIfPresent(String.self, forKey: .shortDescription)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.type = try container.decode(HotelType.self, forKey: .type)
        self.starRating = try container.decode(Int.self, forKey: .starRating)
        self.hotelChain = try container.decodeIfPresent(String.self, forKey: .hotelChain)
        self.addressLine1 = try container.decodeIfPresent(String.self, forKey: .addressLine1)
        self.addressLine2 = try container.decodeIfPresent(String.self, forKey: .addressLine2)
        self.stateOrProvince = try container.decodeIfPresent(String.self, forKey: .stateOrProvince)
        self.postalCode = try container.decodeIfPresent(String.self, forKey: .postalCode)
        self.country = try container.decodeIfPresent(String.self, forKey: .country)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.primaryPhone = try container.decodeIfPresent(String.self, forKey: .primaryPhone)
        self.checkInTime = try container.decodeIfPresent(String.self, forKey: .checkInTime)
        self.checkOutTime = try container.decodeIfPresent(String.self, forKey: .checkOutTime)
        self.acceptedCurrencies = try container.decodeIfPresent(String.self, forKey: .acceptedCurrencies)
        self.languagesSpoken = try container.decode(LanguagesSpoken.self, forKey: .languagesSpoken)
        self.covidSafetyLevel = try container.decode(CovidSafetyLevel.self, forKey: .covidSafetyLevel)
        self.discountText = try container.decodeIfPresent(String.self, forKey: .discountText)
        self.shortDescriptionAR = try container.decodeIfPresent(String.self, forKey: .shortDescriptionAR)
        self.descriptionAR = try container.decodeIfPresent(String.self, forKey: .descriptionAR)
        self.coverImageURL = try container.decodeIfPresent(String.self, forKey: .coverImageURL)
        self.facilities = try container.decodeIfPresent(String.self, forKey: .facilities)
        self.landmarkDescription = try container.decodeIfPresent(String.self, forKey: .landmarkDescription)
        self.averageRating = try container.decode(String.self, forKey: .averageRating)
        self.reviewCount = try container.decode(String.self, forKey: .reviewCount)
        self.latitude = try container.decodeIfPresent(String.self, forKey: .latitude)
        self.longitude = try container.decodeIfPresent(String.self, forKey: .longitude)
        self.minRoomPrice = try container.decode(String.self, forKey: .minRoomPrice)
        self.amenities = try container.decodeIfPresent(String.self, forKey: .amenities)
        self.policies = try container.decode(String.self, forKey: .policies)
        self.coverImageSignedURL = try container.decodeIfPresent(String.self, forKey: .coverImageSignedURL)
        self.reviews = try container.decode([Review].self, forKey: .reviews)
        self.landmarks = try container.decode([Landmark].self, forKey: .landmarks)
        self.images = try container.decode([String].self, forKey: .images)
        self.rooms = try container.decode([RoomElement].self, forKey: .rooms)
        self.discountName = try container.decodeIfPresent(String.self, forKey: .discountName)
    }
    
//    init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//
//            nameAR = try container.decodeIfPresent(String.self, forKey: .nameAR)
//            latitude = try container.decodeIfPresent(String.self, forKey: .latitude)
//            longitude = try container.decodeIfPresent(String.self, forKey: .longitude)
//            addressLine1 = try container.decodeIfPresent(String.self, forKey: .addressLine1)
//        }
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
    case resort = "Resort"
    case motel = "Motel"
    case hostel = "Hostel"
    case bedAndBreakfast = "Bed and Breakfast"
    case apartment = "Apartment"
    case villa = "Villa"
    case guesthouse = "Guesthouse"
    case boutique = "Boutique"
    case lodge = "Lodge"
    case capsule = "Capsule"
    case homestay = "Homestay"
    case camp = "Camp"
    
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
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.hotelID = try container.decode(String.self, forKey: .hotelID)
        self.roomType = try container.decode(String.self, forKey: .roomType)
        self.bedType = try container.decode(String.self, forKey: .bedType)
        self.maxAdults = try container.decode(Int.self, forKey: .maxAdults)
        self.maxChildren = try container.decode(Int.self, forKey: .maxChildren)
        self.roomSize = try container.decodeIfPresent(String.self, forKey: .roomSize)
        self.basePrice = try container.decode(Double.self, forKey: .basePrice)
        self.roomStatus = try container.decodeIfPresent(String.self, forKey: .roomStatus)
        self.refundPolicy = try container.decodeIfPresent(String.self, forKey: .refundPolicy)
        self.breakfastIncluded = try container.decode(Bool.self, forKey: .breakfastIncluded)
        self.availableRooms = try container.decode(Int.self, forKey: .availableRooms)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.amenities = try container.decodeIfPresent(String.self, forKey: .amenities)
        self.inventory = try container.decode(Int.self, forKey: .inventory)
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
