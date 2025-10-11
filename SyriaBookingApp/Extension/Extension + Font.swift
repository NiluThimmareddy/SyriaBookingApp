//
//  Extension + Font.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 03/09/25.
//

import Foundation
import UIKit

extension UIFont {
    
    // Title font - big size
    static var titleFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .bold) // Change size and weight as needed
    }
    
    // Subtitle font - medium size
    static var subtitleFont: UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    // Body font - small size
    static var bodyFont: UIFont {
        return UIFont.systemFont(ofSize: 12, weight: .regular)
    }
    
    // Optional: You can add more styles like caption, footnote, etc.
    static var captionFont: UIFont {
        return UIFont.systemFont(ofSize: 11, weight: .medium)
    }
}
