//
//  Extension.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import Foundation
import UIKit

extension UILabel {
    func setHighlightedText(
        fullText: String,
        highlightText: String,
        normalFont: UIFont = .systemFont(ofSize: 14),
        highlightFont: UIFont = .boldSystemFont(ofSize: 18),
        normalColor: UIColor = .darkGray,
        highlightColor: UIColor = .black
    ) {
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


