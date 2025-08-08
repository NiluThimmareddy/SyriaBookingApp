//
//  DetailsPageHotelImagesCVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 28/05/25.
//

import UIKit

class DetailsPageHotelImagesCVC : UICollectionViewCell {

    @IBOutlet weak var thirdImageBackView: UIView!
    @IBOutlet weak var fifthImageBackView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var hotelImageOne: UIImageView!
    @IBOutlet weak var hotelImageTwo: UIImageView!
    @IBOutlet weak var hotelImageThree: UIImageView!
    @IBOutlet weak var hotelImageFour: UIImageView!
    @IBOutlet weak var hotelImageFive: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var shadowViewButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowViewButton.alpha = 0.3
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCornersOfImageOneContainer()
        roundCornersOfImageTwoContainer()
        roundCornersOfImageThreeContainer()
        roundCornersOfImageFiveContainer()
        roundCornersOfImageFiveBackViewContainer()
        roundCornersOfImageThreeBackViewContainer()
    }

    private func roundCornersOfImageOneContainer() {
        let maskPath = UIBezierPath(
            roundedRect: hotelImageOne.bounds,
            byRoundingCorners: [.topLeft],
            cornerRadii: CGSize(width: 10, height: 10)
        )

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        hotelImageOne.layer.mask = shape
    }
    private func roundCornersOfImageTwoContainer() {
        let maskPath = UIBezierPath(
            roundedRect: hotelImageTwo.bounds,
            byRoundingCorners: [.topRight],
            cornerRadii: CGSize(width: 10, height: 10)
        )

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        hotelImageTwo.layer.mask = shape
    }
    private func roundCornersOfImageThreeContainer() {
        let maskPath = UIBezierPath(
            roundedRect: hotelImageThree.bounds,
            byRoundingCorners: [.bottomLeft],
            cornerRadii: CGSize(width: 10, height: 10)
        )

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        hotelImageThree.layer.mask = shape
    }
    private func roundCornersOfImageThreeBackViewContainer() {
        let maskPath = UIBezierPath(
            roundedRect: thirdImageBackView.bounds,
            byRoundingCorners: [.bottomLeft],
            cornerRadii: CGSize(width: 10, height: 10)
        )

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        thirdImageBackView.layer.mask = shape
    }
    private func roundCornersOfImageFiveContainer() {
        let maskPath = UIBezierPath(
            roundedRect: hotelImageFive.bounds,
            byRoundingCorners: [.bottomRight],
            cornerRadii: CGSize(width: 10, height: 10)
        )

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        hotelImageFive.layer.mask = shape
    }
    private func roundCornersOfImageFiveBackViewContainer() {
        let maskPath = UIBezierPath(
            roundedRect: fifthImageBackView.bounds,
            byRoundingCorners: [.bottomRight],
            cornerRadii: CGSize(width: 10, height: 10)
        )

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        fifthImageBackView.layer.mask = shape
    }
}

