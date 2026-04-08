//
//  SecureStorageHelper.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 06/04/26.
//


import CryptoKit
import Foundation

class SecureStorageHelper {
    
    private static let key = SymmetricKey(size: .bits256)
    
    static func encrypt(data: Data) -> Data? {
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            return sealedBox.combined
        } catch {
            return nil
        }
    }
    
    static func decrypt(data: Data) -> Data? {
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            return try AES.GCM.open(sealedBox, using: key)
        } catch {
            return nil
        }
    }
}
