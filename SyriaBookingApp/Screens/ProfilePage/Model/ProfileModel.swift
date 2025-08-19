//
//  ProfileModel.swift
//  HotelBooking
//
//  Created by praveenkumar on 26/06/25.
//

import Foundation
import UIKit

struct ProfileOption {
    let listData: String
    let imageName: String
}

struct ProfileSection {
    let sectionTitle: String
    let options: [ProfileOption]
}

struct SecurityData {
    let securityTitle: String
    let securityContent: String
}

struct ChatMessage {
    let message: String
    let isFromAgent: Bool
    let timestamp: Date
}

enum StaticContentType {
    case privacy
    case terms
    case about
}

struct NextRoomData{
    let roomId: String
    let roomImage: String
    let bookingStatus: String
    let roomType: String
    let roomBeds: String
    let roomSize: String
    let checkIn: String
    let checkOut: String
    let roomPrice: String
    let bookingReason: String
}

struct Guest {
    var firstName: String
    var lastName: String
    var dob: String
    var gender: String
}


struct NotificationData{
    var date: String
    var viewYourBooking: String
    var bookingConfirmation: String
    var hotelImage: UIImage
}

enum chooseOptions{
    case add
    case edit
}


struct MessageData{
    var hotelName: String
    var hotelImage: String
    var date: String
    var expiresIn: String
    var status: String
}

enum ProfileOptions{
    case name
    case gender
    case email
    case address
    case number
    case dob
}

enum ChatSuggestionStage {
    case initial
    case service
    case bookingIDTrack
    case bookingIDCancel
    case postBookingID 
    case none
}


struct Address {
    var streetAddress: String
    var postCode: String
    var city: String
}

struct PersonalDetails {
    var firstName: String
    var lastName: String
    var gender: String
    var dateOfBirth: String
    var emailAddress: String
    var phoneNumber: String
    var country: String
    var address: Address
}
