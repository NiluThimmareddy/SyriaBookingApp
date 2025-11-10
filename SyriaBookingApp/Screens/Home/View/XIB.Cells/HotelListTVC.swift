//
//  HotelListTVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 30/07/25.
//

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
