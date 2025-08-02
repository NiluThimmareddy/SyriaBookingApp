//
//  CustomTabBar.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 01/08/25.
//

import Foundation
import UIKit

class CustomTabBar: UITabBar {
    
    private var shapeLayer: CALayer?

    override func draw(_ rect: CGRect) {
        self.addShape()
    }

    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()

        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }

    private func createPath() -> CGPath {
        let height: CGFloat = 40.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: centerWidth - 50, y: 0))

        // Curve up
        path.addQuadCurve(to: CGPoint(x: centerWidth, y: -height),
                          controlPoint: CGPoint(x: centerWidth - 25, y: 0))

        // Curve down
        path.addQuadCurve(to: CGPoint(x: centerWidth + 50, y: 0),
                          controlPoint: CGPoint(x: centerWidth + 25, y: 0))

        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()

        return path.cgPath
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.isTranslucent = true
        let newTabBarHeight: CGFloat = 60

        var tabFrame = self.frame
        tabFrame.size.height = newTabBarHeight
        tabFrame.origin.y = self.frame.origin.y + (self.frame.height - newTabBarHeight)
        self.frame = tabFrame
    }
}
