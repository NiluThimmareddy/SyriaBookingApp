//
//  HotelListTVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 30/07/25.
//

/*
import UIKit

class HotelListTVC : UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hotelImgView: UIImageView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var averageView: UIView!
    @IBOutlet weak var offerPercentLabel: UILabel!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var seeAvailabilityButton: UIButton!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var bookMarkImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var seeAvailabilityAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.applyCardStyle()
        SeeButton()
    }
    
    @IBAction func seeAvailabilityButtonAction(_ sender: Any) {
        seeAvailabilityAction?()
    }
    
    func configuration(with model: Hotel) {
        
        if let firstImageURL = model.images.first, !firstImageURL.isEmpty {
            hotelImgView.loadImage(from: firstImageURL)
        } else {
            hotelImgView.loadImage(from: model.coverImageURL)
        }
        
        if let discount = model.discountText, !discount.isEmpty {
            offerPercentLabel.text = discount
            offerPercentLabel.isHidden = false
            bookMarkImageView.isHidden = false
        } else {
            offerPercentLabel.text = ""
            offerPercentLabel.isHidden = true
            bookMarkImageView.isHidden = true
        }
        
        let ratingValue = model.starRating
        let intRating = Int(ratingValue)
        
        let hotelNameAttributed = NSMutableAttributedString(
            string: "\(model.localizedName()) ",
            attributes: [.foregroundColor: UIColor.label]
        )
        
        if intRating > 0 && intRating <= 5 {
            let stars = String(repeating: "★", count: intRating)
            let starAttributed = NSAttributedString(
                string: stars,
                attributes: [.foregroundColor: UIColor.black]
            )
            hotelNameAttributed.append(starAttributed)
        }
        
        hotelNameLabel.attributedText = hotelNameAttributed
        distanceLabel.text = model.landmarkDescription
        cityLabel.text = model.localizedCity()
        let price = model.minRoomPrice
        var fullText = ""
        if AppSettings.shared.selectedLanguage == .arabic{
            fullText = "من \(price) / ليلة"
            
        } else {
            fullText = "From \(price) / night"
        }
        
        priceLabel.setHighlightedText(
            fullText: fullText,
            highlightText: price,
            normalFont: .systemFont(ofSize: 14),
            highlightFont: .boldSystemFont(ofSize: 18),
            normalColor: .darkGray,
            highlightColor: .label
        )
        // reviewLabel.text = "\(model.averageRating) (\(model.reviewCount) reviews)"
        
        if AppSettings.shared.selectedLanguage == .english {
            reviewLabel.text = "\(model.averageRating) (\(model.reviewCount) reviews)"
        } else {
            reviewLabel.text = "\(model.averageRating) (\(model.reviewCount) مراجعات)"
        }
        
    }
    func SeeButton() {
        
        if AppSettings.shared.selectedLanguage == .english{
            seeAvailabilityButton.setTitle("See Availability", for: .normal)
        } else {
            seeAvailabilityButton.setTitle("شاهد التوافر", for: .normal)
        }
    }
    
}
*/

import UIKit
import SkeletonView

class HotelListTVC : UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hotelImgView: UIImageView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var averageView: UIView!
    @IBOutlet weak var offerPercentLabel: UILabel!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var seeAvailabilityButton: UIButton!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var bookMarkImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var seeAvailabilityAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.applyCardStyle()
        SeeButton()
        setupSkeletonView()
    }
    
    @IBAction func seeAvailabilityButtonAction(_ sender: Any) {
        seeAvailabilityAction?()
    }
    
    func configuration(with model: Hotel) {
        // Hide skeleton first
        hideSkeleton()
        
        if let firstImageURL = model.images.first, !firstImageURL.isEmpty {
            hotelImgView.loadImage(from: firstImageURL)
        } else {
            hotelImgView.loadImage(from: model.coverImageURL)
        }
        
        if let discount = model.discountText, !discount.isEmpty {
            offerPercentLabel.text = discount
            offerPercentLabel.isHidden = false
            bookMarkImageView.isHidden = false
        } else {
            offerPercentLabel.text = ""
            offerPercentLabel.isHidden = true
            bookMarkImageView.isHidden = true
        }
        
        let ratingValue = model.starRating
        let intRating = Int(ratingValue)
        
        let hotelNameAttributed = NSMutableAttributedString(
            string: "\(model.localizedName()) ",
            attributes: [.foregroundColor: UIColor.label]
        )
        
        if intRating > 0 && intRating <= 5 {
            let stars = String(repeating: "★", count: intRating)
            let starAttributed = NSAttributedString(
                string: stars,
                attributes: [.foregroundColor: UIColor.black]
            )
            hotelNameAttributed.append(starAttributed)
        }
        
        hotelNameLabel.attributedText = hotelNameAttributed
        distanceLabel.text = model.landmarkDescription
        cityLabel.text = model.localizedCity()
        let price = model.minRoomPrice
        var fullText = ""
        if AppSettings.shared.selectedLanguage == .arabic{
            fullText = "من \(price) / ليلة"
            
        } else {
            fullText = "From \(price) / night"
        }
        
        priceLabel.setHighlightedText(
            fullText: fullText,
            highlightText: price,
            normalFont: .systemFont(ofSize: 14),
            highlightFont: .boldSystemFont(ofSize: 18),
            normalColor: .darkGray,
            highlightColor: .label
        )
        
        if AppSettings.shared.selectedLanguage == .english {
            reviewLabel.text = "\(model.averageRating) (\(model.reviewCount) reviews)"
        } else {
            reviewLabel.text = "\(model.averageRating) (\(model.reviewCount) مراجعات)"
        }
    }
    
    func SeeButton() {
        if AppSettings.shared.selectedLanguage == .english{
            seeAvailabilityButton.setTitle("See Availability", for: .normal)
        } else {
            seeAvailabilityButton.setTitle("شاهد التوافر", for: .normal)
        }
    }
    
    // MARK: - Skeleton View Methods
    private func setupSkeletonView() {
        // Make all elements skeletonable
        hotelImgView.isSkeletonable = true
        averageView.isSkeletonable = true
        offerPercentLabel.isSkeletonable = true
        hotelNameLabel.isSkeletonable = true
        cityLabel.isSkeletonable = true
        priceLabel.isSkeletonable = true
        seeAvailabilityButton.isSkeletonable = true
        reviewLabel.isSkeletonable = true
        bookMarkImageView.isSkeletonable = true
        distanceLabel.isSkeletonable = true
        backView.isSkeletonable = true
        rightView.isSkeletonable = true
        
        // Configure skeleton appearance for labels
        let skeletonLabels: [UILabel] = [
            offerPercentLabel,
            hotelNameLabel,
            cityLabel,
            priceLabel,
            reviewLabel,
            distanceLabel
        ]
        
        skeletonLabels.forEach { label in
            label.linesCornerRadius = 4
            label.skeletonTextLineHeight = .fixed(12)
            label.lastLineFillPercent = 100
        }
        
        // Configure skeleton for button
        seeAvailabilityButton.skeletonCornerRadius = 6
        seeAvailabilityButton.titleLabel?.isSkeletonable = true
        seeAvailabilityButton.titleLabel?.linesCornerRadius = 4
        seeAvailabilityButton.titleLabel?.skeletonTextLineHeight = .fixed(12)
        
        // Configure skeleton for image views
        hotelImgView.skeletonCornerRadius = 8
        bookMarkImageView.skeletonCornerRadius = 4
        
        // Configure skeleton for views
        averageView.skeletonCornerRadius = 4
        backView.skeletonCornerRadius = 12
        rightView.skeletonCornerRadius = 8
    }
    
    func showSkeleton() {
        // Clear content for skeleton
        hotelImgView.image = nil
        offerPercentLabel.text = nil
        hotelNameLabel.text = nil
        cityLabel.text = nil
        priceLabel.text = nil
        reviewLabel.text = nil
        distanceLabel.text = nil
        seeAvailabilityButton.setTitle(nil, for: .normal)
        
        // Hide elements that shouldn't show during skeleton
        offerPercentLabel.isHidden = false
        bookMarkImageView.isHidden = false
        
        // Show skeleton on all elements
        hotelImgView.showAnimatedGradientSkeleton()
        averageView.showAnimatedGradientSkeleton()
        offerPercentLabel.showAnimatedGradientSkeleton()
        hotelNameLabel.showAnimatedGradientSkeleton()
        cityLabel.showAnimatedGradientSkeleton()
        priceLabel.showAnimatedGradientSkeleton()
        seeAvailabilityButton.showAnimatedGradientSkeleton()
        reviewLabel.showAnimatedGradientSkeleton()
        bookMarkImageView.showAnimatedGradientSkeleton()
        distanceLabel.showAnimatedGradientSkeleton()
        backView.showAnimatedGradientSkeleton()
        rightView.showAnimatedGradientSkeleton()
        
        // Show skeleton on button title label
        seeAvailabilityButton.titleLabel?.showAnimatedGradientSkeleton()
    }
    
    func hideSkeleton() {
        // Hide skeleton from all elements
        hotelImgView.hideSkeleton()
        averageView.hideSkeleton()
        offerPercentLabel.hideSkeleton()
        hotelNameLabel.hideSkeleton()
        cityLabel.hideSkeleton()
        priceLabel.hideSkeleton()
        seeAvailabilityButton.hideSkeleton()
        reviewLabel.hideSkeleton()
        bookMarkImageView.hideSkeleton()
        distanceLabel.hideSkeleton()
        backView.hideSkeleton()
        rightView.hideSkeleton()
        
        // Hide skeleton from button title label
        seeAvailabilityButton.titleLabel?.hideSkeleton()
        
        // Restore button title
        SeeButton()
    }
    
    // Method to prepare cell for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        // Clear previous content and show skeleton again if needed
        hotelImgView.image = nil
        offerPercentLabel.text = nil
        hotelNameLabel.text = nil
        cityLabel.text = nil
        priceLabel.text = nil
        reviewLabel.text = nil
        distanceLabel.text = nil

    }
}
