//
//  DiceEffect.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 03/09/25.
//

import UIKit

class CubeLayoutAttributes: UICollectionViewLayoutAttributes {
    var cubeAnchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! CubeLayoutAttributes
        copy.cubeAnchorPoint = cubeAnchorPoint
        return copy
    }
}

class CubeFlowLayout: UICollectionViewFlowLayout {
    
    override class var layoutAttributesClass: AnyClass {
        return CubeLayoutAttributes.self
    }
    
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        itemSize = collectionView?.bounds.size ?? .zero
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView,
              let attributesArray = super.layoutAttributesForElements(in: rect) as? [CubeLayoutAttributes] else { return nil }
        
        let offsetX = collectionView.contentOffset.x
        let width = collectionView.bounds.width
        
        for attributes in attributesArray {
            let position = (attributes.frame.origin.x - offsetX) / width   // -1, 0, 1
            
            var transform = CATransform3DIdentity
            transform.m34 = -1 / 500
            
            let angle = position * (.pi / 2)
            
            if position > 0 {
                // Coming from right
                attributes.cubeAnchorPoint = CGPoint(x: 0, y: 0.5) // left edge
                let translateX = -width / 2
                transform = CATransform3DTranslate(transform, translateX, 0, 0)
                transform = CATransform3DRotate(transform, angle, 0, 1, 0)
                transform = CATransform3DTranslate(transform, width / 2, 0, 0)
            } else {
                // Going left
                attributes.cubeAnchorPoint = CGPoint(x: 1, y: 0.5) // right edge
                let translateX = width / 2
                transform = CATransform3DTranslate(transform, translateX, 0, 0)
                transform = CATransform3DRotate(transform, angle, 0, 1, 0)
                transform = CATransform3DTranslate(transform, -width / 2, 0, 0)
            }
            
            attributes.transform3D = transform
            attributes.alpha = abs(position) < 1 ? 1 : 0
            attributes.zIndex = Int(1000 - abs(position * 1000))
        }
        
        return attributesArray
    }
}
