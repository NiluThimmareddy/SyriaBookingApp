//
//  Extension + Font.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 03/09/25.
//

import Foundation
import UIKit

import UIKit

extension UIFont {
    
    /// Title font - large size
    static var titleFont: UIFont {
        UIFont.dynamicFont(baseSize: 16, iPadSize: 18, weight: .bold)
    }
    
    /// Subtitle font - medium size
    static var subtitleFont: UIFont {
        UIFont.dynamicFont(baseSize: 14, iPadSize: 16, weight: .semibold)
    }
    
    /// Body font - regular size
    static var bodyFont: UIFont {
        UIFont.dynamicFont(baseSize: 12, iPadSize: 14, weight: .medium)
    }
    
    /// Caption font - smaller size
    static var captionFont: UIFont {
        UIFont.dynamicFont(baseSize: 11, iPadSize: 13, weight: .medium)
    }
    
    /// Helper function for dynamic font creation
    private static func dynamicFont(baseSize: CGFloat, iPadSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        let size = UIDevice.current.userInterfaceIdiom == .pad ? iPadSize : baseSize
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
}

