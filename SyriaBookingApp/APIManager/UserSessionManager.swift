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
        do {
            let encoded = try JSONEncoder().encode(user)
            
            guard let encrypted = SecureStorageHelper.encrypt(data: encoded) else {
                #if DEBUG
                print("❌ Encryption failed")
                #endif
                return
            }
            
            UserDefaults.standard.set(encrypted, forKey: userKey)
            
        } catch {
            #if DEBUG
            print("❌ Encoding failed:", error)
            #endif
        }
    }
    
//    static func saveUser(_ user: BookingModel) {
//        if let encoded = try? JSONEncoder().encode(user) {
//            UserDefaults.standard.set(encoded, forKey: userKey)
//        }
//        
////        UserDefaults.standard.set(true, forKey: hasEverSignedUpKey)
//    }
    
    // Get user
    static func getUser() -> BookingModel? {
        guard let data = UserDefaults.standard.data(forKey: userKey) else {
            return nil
        }
        
        guard let decrypted = SecureStorageHelper.decrypt(data: data) else {
            #if DEBUG
            print("❌ Decryption failed")
            #endif
            return nil
        }
        
        do {
            let user = try JSONDecoder().decode(BookingModel.self, from: decrypted)
            return user
        } catch {
            #if DEBUG
            print("❌ Decoding failed:", error)
            #endif
            return nil
        }
    }
    
//    static func getUser() -> BookingModel? {
//        if let data = UserDefaults.standard.data(forKey: userKey),
//           let user = try? JSONDecoder().decode(BookingModel.self, from: data) {
//            return user
//        }
//        return nil
//    }
    
    // Clear user (for logout)
    static func clearUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }


}
