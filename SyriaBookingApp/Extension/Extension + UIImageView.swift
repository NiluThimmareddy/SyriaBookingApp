//
//  Extension + UIImageView.swift
//  SyriaBookingApp
//  Created by ToqSoft on 28/07/25.

import Foundation

import UIKit

extension UIImageView {
    func loadImage(from urlString: String?, placeholder: UIImage? = UIImage(named: "HotelPlaceholder")) {
        self.image = placeholder
        
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil,
                  let image = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
    
    func applyWhiteGradientOverlay(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0.9).cgColor,
            UIColor.white.withAlphaComponent(0.6).cgColor,
            UIColor.white.withAlphaComponent(0.0).cgColor
        ]

        gradientLayer.locations = [0.0, 0.3, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5) // left
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)   // right

        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral.size

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage else { return nil }

        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        context.rotate(by: radians)
        context.scaleBy(x: 1.0, y: -1.0)

        let rect = CGRect(x: -self.size.width/2, y: -self.size.height/2,
                          width: self.size.width, height: self.size.height)

        context.draw(cgImage, in: rect)
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return rotatedImage
    }
}
