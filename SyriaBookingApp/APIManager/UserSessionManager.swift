//
//  UserSessionManager.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 04/09/25.
//

import Foundation
class UserSessionManager {
    private static let userKey = "loggedInUser"
//    private static let hasEverSignedUpKey = "hasEverSignedUp"
    
    
    // Save user
    static func saveUser(_ user: BookingModel) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
        
//        UserDefaults.standard.set(true, forKey: hasEverSignedUpKey)
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
    
//    static func hasEverSignedUp() -> Bool {
//        
//        // If permanent flag already exists → return it
//        if UserDefaults.standard.object(forKey: hasEverSignedUpKey) != nil {
//            return UserDefaults.standard.bool(forKey: hasEverSignedUpKey)
//        }
//        
//        // 🔥 Migration logic for old app users
//        if getUser() != nil {
//            UserDefaults.standard.set(true, forKey: hasEverSignedUpKey)
//            return true
//        }
//        
//        return false
//    }

}
