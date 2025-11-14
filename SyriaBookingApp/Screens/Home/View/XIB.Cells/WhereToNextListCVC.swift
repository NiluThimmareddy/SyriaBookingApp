//
//  WhereToNextListCVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 17/10/25.

import UIKit
import SkeletonView

class WhereToNextListCVC: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var hotelTypeLabel: UILabel!
    @IBOutlet weak var pricePerNightLabel: UILabel!
    @IBOutlet weak var hotelImgLabel: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        setupSkeleton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backView.applyCardStyle()
    }
    
    func configure(with hotel: Hotel, language: Languages) {
        hideSkeleton()
        
        let hotelName = language == .english ? hotel.name : hotel.nameAR
        hotelNameLabel.text = hotelName
        
        hotelTypeLabel.text = "\(hotel.type)"
        
        let price = hotel.minRoomPrice
        if !price.isEmpty {
            if language == .english {
                pricePerNightLabel.text = "\(price)/night"
            } else {
                pricePerNightLabel.text = "\(price) دولار/ليلة"
            }
        } else {
            pricePerNightLabel.text = language == .english ? "Price on request" : "السعر عند الطلب"
        }
        
        ratingLabel?.text = String(format: "%.1f", hotel.averageRating)
        
        if let firstImage = hotel.images.first,
           let url = URL(string: firstImage) {
            loadHotelImage(from: url)
        } else {
            hotelImgLabel.image = UIImage(named: "hotel_placeholder")
        }
    }
    
    private func loadHotelImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  error == nil,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.hotelImgLabel.image = UIImage(named: "hotel_placeholder")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.hotelImgLabel.image = image
            }
        }.resume()
    }
    
    // MARK: - Skeleton Methods
    private func setupSkeleton() {
        backView.isSkeletonable = true
        hotelNameLabel.isSkeletonable = true
        hotelTypeLabel.isSkeletonable = true
        pricePerNightLabel.isSkeletonable = true
        hotelImgLabel.isSkeletonable = true
        ratingLabel?.isSkeletonable = true
        ratingContainerView?.isSkeletonable = true
        hotelNameLabel.skeletonTextLineHeight = .fixed(18)
        hotelNameLabel.lastLineFillPercent = 100
        hotelNameLabel.linesCornerRadius = 4
        
        hotelTypeLabel.skeletonTextLineHeight = .fixed(14)
        hotelTypeLabel.lastLineFillPercent = 70
        hotelTypeLabel.linesCornerRadius = 4
        
        pricePerNightLabel.skeletonTextLineHeight = .fixed(16)
        pricePerNightLabel.lastLineFillPercent = 80
        pricePerNightLabel.linesCornerRadius = 4
        
        if let ratingLabel = ratingLabel {
            ratingLabel.skeletonTextLineHeight = .fixed(12)
            ratingLabel.lastLineFillPercent = 60
            ratingLabel.linesCornerRadius = 4
        }
        hotelImgLabel.skeletonCornerRadius = 8
        ratingContainerView?.skeletonCornerRadius = 4
    }
    
    func showSkeleton() {
        hotelNameLabel.text = nil
        hotelTypeLabel.text = nil
        pricePerNightLabel.text = nil
        ratingLabel?.text = nil
        hotelImgLabel.image = nil
        backView.showAnimatedGradientSkeleton()
        hotelNameLabel.showAnimatedGradientSkeleton()
        hotelTypeLabel.showAnimatedGradientSkeleton()
        pricePerNightLabel.showAnimatedGradientSkeleton()
        hotelImgLabel.showAnimatedGradientSkeleton()
        ratingLabel?.showAnimatedGradientSkeleton()
        ratingContainerView?.showAnimatedGradientSkeleton()
    }
    
    func hideSkeleton() {
        backView.hideSkeleton()
        hotelNameLabel.hideSkeleton()
        hotelTypeLabel.hideSkeleton()
        pricePerNightLabel.hideSkeleton()
        hotelImgLabel.hideSkeleton()
        ratingLabel?.hideSkeleton()
        ratingContainerView?.hideSkeleton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hotelNameLabel.text = nil
        hotelTypeLabel.text = nil
        pricePerNightLabel.text = nil
        ratingLabel?.text = nil
        hotelImgLabel.image = nil
        hideSkeleton()
    }
}
