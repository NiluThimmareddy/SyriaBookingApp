//  SecureStorageHelper.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 06/04/26.

import Foundation
import CryptoKit
import Security

class SecureStorageHelper {
    
    private static let keyTag = "com.app.encryption.key"
    
    // MARK: - Get or Create Key
    private static func getKey() -> SymmetricKey? {
        
        // Try fetching from Keychain
        if let existingKeyData = getKeyFromKeychain() {
            return SymmetricKey(data: existingKeyData)
        }
        
        // Create new key
        let newKey = SymmetricKey(size: .bits256)
        let keyData = newKey.withUnsafeBytes { Data($0) }
        
        // Save to Keychain
        let saved = saveKeyToKeychain(keyData)
        return saved ? newKey : nil
    }
    
    // MARK: - Encrypt
    static func encrypt(data: Data) -> Data? {
        guard let key = getKey() else {
            print("❌ Failed to get encryption key")
            return nil
        }
        
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            return sealedBox.combined
        } catch {
#if debug
            print("❌ Encryption error:", error)
            #endif
            return nil
        }
    }
    
    // MARK: - Decrypt
    static func decrypt(data: Data) -> Data? {
        guard let key = getKey() else {
            print("❌ Failed to get decryption key")
            return nil
        }
        
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            return try AES.GCM.open(sealedBox, using: key)
        } catch {
#if debug
            print("❌ Decryption error:", error)
#endif
            return nil
        }
    }
    
    // MARK: - Keychain Save
    private static func saveKeyToKeychain(_ keyData: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: keyTag,
            kSecValueData as String: keyData
        ]
        
        SecItemDelete(query as CFDictionary) // Remove old if exists
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    // MARK: - Keychain Fetch
    private static func getKeyFromKeychain() -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: keyTag,
            kSecReturnData as String: true
        ]
        
        var dataTypeRef: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            return dataTypeRef as? Data
        }
        
        return nil
    }
}
