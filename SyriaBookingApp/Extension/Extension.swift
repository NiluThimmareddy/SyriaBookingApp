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

extension UIView {
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor {
        get { return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor) }
        set { layer.borderColor = newValue.cgColor }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    func applyCardStyle(shadowOffset: CGSize = CGSize(width: 0, height: 2),
                        shadowRadius: CGFloat = 4,
                        shadowOpacity: Float = 0.3,
                        shadowColor: UIColor = .black) {
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.masksToBounds = false
        self.backgroundColor = .white
    }

    
    func addTopShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: -3)
        self.layer.shadowRadius = 4
    }
    
    func addBottomShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 4

        let shadowRect = CGRect(x: 0, y: self.bounds.height - 4, width: self.bounds.width, height: 4)
        self.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
    }
    
    func applyVerticalGradient(fromColor: UIColor, toColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
        gradientLayer.locations = [0.0, 0.35]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = self.bounds
        self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func applyVerticalGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 48.0/255, green: 105.0/255, blue: 178.0/255, alpha: 1.0).cgColor,
            UIColor(red: 0.0/255, green: 59.0/255, blue: 149.0/255, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.frame = self.bounds

        self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func applyGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 48.0/255, green: 105.0/255, blue: 178.0/255, alpha: 1.0).cgColor,
            UIColor(red: 0.0/255, green: 59.0/255, blue: 149.0/255, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = self.bounds
        self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
