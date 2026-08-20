//
//  URLObfuscator.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 12/08/26.
//


import Foundation


final class URLCrypto {
    private static let minASCII = 32
    private static let maxASCII = 126
    private static let range = maxASCII - minASCII + 1
    
    static func decrypt(_ text: String) -> String {
        
        var result = ""
        
        for (index, char) in text.enumerated() {
            
            guard let ascii = char.asciiValue else {
                result.append(char)
                continue
            }
            
            let shift = (index % 10) + 3
            
            var value = Int(ascii) - minASCII
            value = value - shift
            
            if value < 0 {
                value += range
            }
            
            let decrypted = value + minASCII
            
            result.append(Character(UnicodeScalar(decrypted)!))
        }
        
        return result
    }
}

final class URLObfuscator {
    
    // Dynamic XOR key (not directly visible)
    private static let key: UInt8 = {
        let a: UInt8 = 0x12
        let b: UInt8 = 0x45
        let c: UInt8 = 0x3F
        return a ^ b ^ c
    }()
    
    /// Encode string (Run only while generating encrypted values)
    static func encode(_ string: String) -> String {
        
        let reversed = String(string.reversed())
        
        let bytes = reversed.utf8.map {
            $0 ^ key
        }
        
        return Data(bytes).base64EncodedString()
    }
    
    /// Decode string (Used by app)
    static func decode(_ encoded: String) -> String {
        
        guard let data = Data(base64Encoded: encoded) else {
            return ""
        }
        
        let bytes = data.map {
            $0 ^ key
        }
        
        let reversed = String(decoding: bytes, as: UTF8.self)
        
        return String(reversed.reversed())
    }
}
