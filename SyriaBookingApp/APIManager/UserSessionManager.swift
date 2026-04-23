////
////  UserSessionManager.swift
////  SyriaBookingApp
////
////  Created by ToqSoft on 04/09/25.
////
//
import Foundation

class UserSessionManager {
    
    private static let userKey = "loggedInUser"

    // MARK: Save User
    static func saveUser(_ user: BookingModel) {
        do {
            let encoded = try JSONEncoder().encode(user)
            
            guard let encrypted = SecureStorageHelper.encrypt(data: encoded) else {
                print("❌ Encryption failed - user not saved")
                return
            }
            
            UserDefaults.standard.set(encrypted, forKey: userKey)
            print("✅ User saved successfully")
            
        } catch {
#if debug
            print("❌ Encoding failed:", error)
#endif
        }
    }

    // MARK: Get User
    static func getUser() -> BookingModel? {
        guard let data = UserDefaults.standard.data(forKey: userKey) else {
            print("⚠️ No saved user")
            return nil
        }
        
        guard let decrypted = SecureStorageHelper.decrypt(data: data) else {
            print("❌ Decryption failed")
            return nil
        }
        
        do {
            let user = try JSONDecoder().decode(BookingModel.self, from: decrypted)
            print("✅ User loaded successfully")
            return user
        } catch {
            #if debug
            print("❌ Decoding failed:", error)
            #endif
            return nil
        }
    }
    
    // MARK: Logout
    static func clearUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
        print("🧹 User cleared")
    }
}
