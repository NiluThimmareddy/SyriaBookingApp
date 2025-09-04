//
//  UserSessionManager.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 04/09/25.
//

import Foundation
class UserSessionManager {
    private static let userKey = "loggedInUser"
    
    // Save user
    static func saveUser(_ user: BookingModel) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }
    
    // Get user
    static func getUser() -> BookingModel? {
        if let data = UserDefaults.standard.data(forKey: userKey),
           let user = try? JSONDecoder().decode(BookingModel.self, from: data) {
            return user
        }
        return nil
    }
    
    // Clear user (for logout)
    static func clearUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }
}
