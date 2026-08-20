//
//  KeychainTokenStore.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 17/07/26.
//

import Foundation
import Security

final class KeychainTokenStore {
    
    private enum Key {
        static let token = "hotelbooking.jwt.token"
        static let expiry = "hotelbooking.jwt.expiry"
        static let userId = "hotelbooking.user.id"
        static let email = "hotelbooking.user.email"
    }
    
    func saveSession(
        token: String,
        expiresAtUtc: String,
        userId: String,
        email: String
    ) throws {
        try save(token, key: Key.token)
        try save(expiresAtUtc, key: Key.expiry)
        try save(userId, key: Key.userId)
        try save(email, key: Key.email)
    }
    
    func token() -> String? {
        read(key: Key.token)
    }
    
    func expiresAtUtc() -> String? {
        read(key: Key.expiry)
    }
    
    func isTokenExpired() -> Bool {
        
        guard let value = expiresAtUtc() else {
            return true
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSX"
        
        guard let expiry = formatter.date(from: value) else {
          
            return true
        }
#if DEBUG
        print("Expiry String:", value)
        print("Parsed Date:", ISO8601DateFormatter().date(from: value) as Any)
        
#endif
        return Date() >= expiry.addingTimeInterval(-30)
    }
    
//    func isTokenExpired() -> Bool {
//        guard  let value = expiresAtUtc(),
//            let expiry = ISO8601DateFormatter().date(from: value) else{
//            return true
//        }
//        return Date() >= expiry.addingTimeInterval(-30)
//    }
    
    func hasValidSession() -> Bool {
        guard let token = token(), !token.isEmpty else {
            return false
        }
        return !isTokenExpired()
    }
    
    func clearSession() {
        delete(key: Key.token)
        delete(key: Key.expiry)
        delete(key: Key.userId)
        delete(key: Key.email)
    }
    
    private func save(_ value: String, key: String) throws {
        delete(key: key)
        
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrAccessible as String:
                kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.unhandled(status)
        }
    }
    
    private func read(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(
            query as CFDictionary,
            &result
        )
        guard
            status == errSecSuccess,
            let data = result as? Data else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    private func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}

enum KeychainError: Error {
    case unhandled(OSStatus)
}
