//
//  DiceEffect.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 03/09/25.

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
        if let cv = collectionView {
            itemSize = cv.bounds.size
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let cv = collectionView else { return nil }
        
        let attrs = CubeLayoutAttributes(forCellWith: indexPath)
        
        // Always compute a valid frame
        let w = max(cv.bounds.width, 1)
        let h = max(cv.bounds.height, 1)
        let originX = CGFloat(indexPath.item) * w
        attrs.frame = CGRect(x: originX, y: 0, width: w, height: h)
        
        // Cube transform
        let offsetX = cv.contentOffset.x
        let position = (attrs.frame.origin.x - offsetX) / w
        
        var transform = CATransform3DIdentity
        transform.m34 = -1 / 500.0
        
        let angle = position * (.pi / 2)
        
        if position > 0 {
            attrs.cubeAnchorPoint = CGPoint(x: 0, y: 0.5)
            transform = CATransform3DTranslate(transform, -w / 2, 0, 0)
            transform = CATransform3DRotate(transform, angle, 0, 1, 0)
            transform = CATransform3DTranslate(transform, w / 2, 0, 0)
        } else {
            attrs.cubeAnchorPoint = CGPoint(x: 1, y: 0.5)
            transform = CATransform3DTranslate(transform, w / 2, 0, 0)
            transform = CATransform3DRotate(transform, angle, 0, 1, 0)
            transform = CATransform3DTranslate(transform, -w / 2, 0, 0)
        }
        
        attrs.transform3D = transform
        attrs.alpha = abs(position) < 1 ? 1 : 0
        attrs.zIndex = Int(1000 - abs(position * 1000))
        
        return attrs
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let cv = collectionView else { return nil }
        let count = cv.numberOfItems(inSection: 0)
        
        var result: [UICollectionViewLayoutAttributes] = []
        for item in 0..<count {
            let ip = IndexPath(item: item, section: 0)
            if let attrs = layoutAttributesForItem(at: ip), attrs.frame.intersects(rect) {
                result.append(attrs)
            }
        }
        return result
    }
}
