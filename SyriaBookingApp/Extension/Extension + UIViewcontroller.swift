////
////  Extension.swift
////  SyriaBookingApp
////
////  Created by ToqSoft on 25/07/25.
////
//


import UIKit
import ObjectiveC

private var activityIndicatorKey: UInt8 = 0

extension UIViewController {
    
    private var defaultActivityIndicator: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &activityIndicatorKey) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &activityIndicatorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showLoader(style: UIActivityIndicatorView.Style = .large) {
        guard defaultActivityIndicator == nil else { return } // Already showing

        let indicator = UIActivityIndicatorView(style: style)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        indicator.startAnimating()
        
        // Optional: dim background
        let backgroundView = UIView(frame: self.view.bounds)
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        backgroundView.tag = 9999
        backgroundView.addSubview(indicator)
        indicator.center = backgroundView.center
        
        self.view.addSubview(backgroundView)
        defaultActivityIndicator = indicator
    }
    
    func hideLoader() {
        defaultActivityIndicator?.stopAnimating()
        self.view.viewWithTag(9999)?.removeFromSuperview()
        defaultActivityIndicator = nil
    }
}

//import Foundation
//import UIKit
//
//private var activityIndicatorViewKey: UInt8 = 0
//
//extension UIViewController {
//    
//    private var customActivityIndicator: UIImageView? {
//        get {
//            return objc_getAssociatedObject(self, &activityIndicatorViewKey) as? UIImageView
//        }
//        set {
//            objc_setAssociatedObject(self, &activityIndicatorViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//    
//    func showLoader(imageName: String = "loading", size: CGSize = CGSize(width: 60, height: 60)) {
//        guard customActivityIndicator == nil else { return } // Avoid adding multiple indicators
//        
//        let loader = UIImageView(image: UIImage(named: imageName))
//        loader.contentMode = .scaleAspectFit
//        loader.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//        loader.center = self.view.center
//        loader.alpha = 0.8
//        
//        // Animation
//        let rotation = CABasicAnimation(keyPath: "transform.rotation")
//        rotation.fromValue = 0
//        rotation.toValue = CGFloat.pi * 2
//        rotation.duration = 1
//        rotation.repeatCount = .infinity
//        loader.layer.add(rotation, forKey: "rotate")
//        
//        self.view.addSubview(loader)
//        customActivityIndicator = loader
//    }
//    
//    func hideLoader() {
//        customActivityIndicator?.removeFromSuperview()
//        customActivityIndicator = nil
//    }
//}
//
