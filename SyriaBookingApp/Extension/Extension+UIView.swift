//
//  Extension+UIView.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 02/08/25.
//
import Foundation
import UIKit

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
        }
    }
    
    func applyCardStyle(shadowOffset: CGSize = CGSize(width: 0, height: 2),
                        shadowRadius: CGFloat = 2,
                        shadowOpacity: Float = 0.4,
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
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: -3)
        self.layer.shadowRadius = 3
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
            UIColor(red: 85.0/255, green: 170.0/255, blue: 85.0/255, alpha: 1.0).cgColor,
            UIColor(red: 144.0/255, green: 238.0/255, blue: 144.0/255, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = self.layer.cornerRadius
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
    
    func applyTopRightLightGreenGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [
            UIColor(red: 0.87, green: 1.0, blue: 0.88, alpha: 1).cgColor,
            UIColor.white.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.cornerRadius = self.layer.cornerRadius
        self.layer.masksToBounds = true
        self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        layer.addSublayer(border)
    }
}
