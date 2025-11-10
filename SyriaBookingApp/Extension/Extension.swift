//
//  Extension.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import Foundation
import UIKit

extension UILabel {
    func setHighlightedText(fullText: String,highlightText: String,normalFont: UIFont = .systemFont(ofSize: 14),highlightFont: UIFont = .boldSystemFont(ofSize: 18),normalColor: UIColor = .darkGray,highlightColor: UIColor = .black) {
        let attributedString = NSMutableAttributedString(string: fullText)
        
        attributedString.addAttributes([
            .font: normalFont,
            .foregroundColor: normalColor
        ], range: NSRange(location: 0, length: attributedString.length))
        
        if let range = fullText.range(of: highlightText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttributes([
                .font: highlightFont,
                .foregroundColor: highlightColor
            ], range: nsRange)
        }
        
        self.attributedText = attributedString
    }
}

extension UITextView {
    func setHighlightedText(fullText: String,highlightText: String,normalFont: UIFont = UIFont.systemFont(ofSize: 14),highlightFont: UIFont = UIFont.boldSystemFont(ofSize: 18),normalColor: UIColor = UIColor.darkGray,highlightColor: UIColor = UIColor.black) {
        let attributedString = NSMutableAttributedString(string: fullText)
        
        attributedString.addAttributes([
            .font: normalFont,
            .foregroundColor: normalColor
        ], range: NSRange(location: 0, length: attributedString.length))
        
        if let range = fullText.range(of: highlightText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttributes([
                .font: highlightFont,
                .foregroundColor: highlightColor
            ], range: nsRange)
        }
        
        self.attributedText = attributedString
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let hasAlpha = hexSanitized.count == 8
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let b = CGFloat(rgb & 0x0000FF) / 255
        let a = hasAlpha ? CGFloat((rgb & 0xFF000000) >> 24) / 255 : 1
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

extension UIFont {
    static func poppinsMedium(_ size: CGFloat) -> UIFont {
        UIFont(name: "Poppins-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func poppinsBold(_ size: CGFloat) -> UIFont {
        UIFont(name: "Poppins-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
}

extension UICollectionViewLayoutAttributes {
    var anchorPoint: CGPoint {
        get {
            return self.value(forKey: "anchorPoint") as? CGPoint ?? CGPoint(x: 0.5, y: 0.5)
        }
        set {
            self.setValue(newValue, forKey: "anchorPoint")
        }
    }
}

extension String {
    
    /// Converts ISO8601 date string to "dd MMM" format, e.g., "22 Sep"
    func toDayMonth() -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // handles fractional seconds
        if let date = isoFormatter.date(from: self) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "dd MMM"
            displayFormatter.locale = Locale.current
            return displayFormatter.string(from: date)
        }
        return self // fallback to original string if parsing fails
    }
    
    func toDayMonthYear() -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        
        // Try parsing with fractional seconds first
        if let date = isoFormatter.date(from: self) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "dd MMM yyyy"
            displayFormatter.locale = Locale.current
            displayFormatter.timeZone = TimeZone.current // convert to local time
            return displayFormatter.string(from: date)
        }
        
        // Fallback: try parsing without fractional seconds
        isoFormatter.formatOptions = [.withInternetDateTime]
        if let date = isoFormatter.date(from: self) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "dd MMM yyyy"
            displayFormatter.locale = Locale.current
            displayFormatter.timeZone = TimeZone.current
            return displayFormatter.string(from: date)
        }
        
        return self // fallback if parsing fails
    }
}
