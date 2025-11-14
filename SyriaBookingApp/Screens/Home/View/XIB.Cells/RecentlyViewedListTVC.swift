//
//  RecentlyViewedListTVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 16/10/25.
//

import UIKit
import SkeletonView

class RecentlyViewedListTVC: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hotelImgView: UIImageView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var hotelTypeLabel: UILabel!
    @IBOutlet weak var hotelReviewsLabel: UILabel!
    @IBOutlet weak var pricePerNightLabel: UILabel!
    @IBOutlet weak var viewedDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSkeleton()
        backView.applyCardStyle()
    }
    
    private func setupSkeleton() {
        // Make the cell and its content skeletonable
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        
        // Make all subviews skeletonable
        backView.isSkeletonable = true
        hotelImgView.isSkeletonable = true
        hotelNameLabel.isSkeletonable = true
        hotelTypeLabel.isSkeletonable = true
        hotelReviewsLabel.isSkeletonable = true
        pricePerNightLabel.isSkeletonable = true
        viewedDateLabel.isSkeletonable = true
        
        // Configure skeleton for labels
        hotelNameLabel.skeletonTextLineHeight = .fixed(20)
        hotelNameLabel.lastLineFillPercent = 80
        hotelNameLabel.linesCornerRadius = 4
        
        hotelTypeLabel.skeletonTextLineHeight = .fixed(16)
        hotelTypeLabel.lastLineFillPercent = 60
        hotelTypeLabel.linesCornerRadius = 4
        
        hotelReviewsLabel.skeletonTextLineHeight = .fixed(16)
        hotelReviewsLabel.lastLineFillPercent = 50
        hotelReviewsLabel.linesCornerRadius = 4
        
        pricePerNightLabel.skeletonTextLineHeight = .fixed(18)
        pricePerNightLabel.lastLineFillPercent = 70
        pricePerNightLabel.linesCornerRadius = 4
        
        viewedDateLabel.skeletonTextLineHeight = .fixed(14)
        viewedDateLabel.lastLineFillPercent = 40
        viewedDateLabel.linesCornerRadius = 4
        
        // Configure image view skeleton
        hotelImgView.skeletonCornerRadius = 8
    }
    
    func showSkeleton() {
        // Ensure all elements show skeleton
        hotelImgView.showAnimatedGradientSkeleton()
        hotelNameLabel.showAnimatedGradientSkeleton()
        hotelTypeLabel.showAnimatedGradientSkeleton()
        hotelReviewsLabel.showAnimatedGradientSkeleton()
        pricePerNightLabel.showAnimatedGradientSkeleton()
        viewedDateLabel.showAnimatedGradientSkeleton()
    }
    
    func hideSkeleton() {
        hotelImgView.hideSkeleton()
        hotelNameLabel.hideSkeleton()
        hotelTypeLabel.hideSkeleton()
        hotelReviewsLabel.hideSkeleton()
        pricePerNightLabel.hideSkeleton()
        viewedDateLabel.hideSkeleton()
    }
    
    func configure(with hotel: Hotel) {
        // Hide skeleton first
        hideSkeleton()
        
        let lang = AppSettings.shared.selectedLanguage
        hotelNameLabel.text = hotel.name
        hotelTypeLabel.text = lang == .english ? "\(hotel.type) • \(hotel.city)" : "\(hotel.type) • \(hotel.cityAR)"
        
        if lang == .english {
            pricePerNightLabel.text = "From \(hotel.minRoomPrice) / night"
            hotelReviewsLabel.text = "★ \(hotel.averageRating) (\(hotel.reviewCount) reviews)"
        } else {
            pricePerNightLabel.text = "ابتداءً من \(hotel.minRoomPrice) / ليلة"
            hotelReviewsLabel.text = "★ \(hotel.averageRating) (\(hotel.reviewCount) تقييم)"
        }
       
        if let viewedDate = getViewedDate(for: hotel.id) {
            viewedDateLabel.text = formatViewedDate(viewedDate)
        } else {
            viewedDateLabel.text = ""
        }
        
        if let imageUrl = hotel.images.first, let url = URL(string: imageUrl) {
            loadImage(from: url)
        } else {
            hotelImgView.image = UIImage(named: "hotel_placeholder")
        }
    }
    
    private func getViewedDate(for hotelId: String) -> Date? {
        return HotelDataMaganer.shared.getRecentlyViewedHotelDate(hotelId: hotelId)
    }
    
    private func formatViewedDate(_ date: Date) -> String {
        let lang = AppSettings.shared.selectedLanguage
        let now = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
        
        if let years = components.year, years > 0 {
            return lang == .english ? "\(years)y ago" : "قبل \(years)س"
        } else if let months = components.month, months > 0 {
            return lang == .english ? "\(months)mo ago" : "قبل \(months)ش"
        } else if let days = components.day, days > 0 {
            return lang == .english ? "\(days)d ago" : "قبل \(days)ي"
        } else if let hours = components.hour, hours > 0 {
            return lang == .english ? "\(hours)h ago" : "قبل \(hours)س"
        } else if let minutes = components.minute, minutes > 0 {
            return lang == .english ? "\(minutes)m ago" : "قبل \(minutes)د"
        } else {
            return lang == .english ? "Just now" : "الآن"
        }
    }
    
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.hotelImgView.image = UIImage(named: "hotel_placeholder")
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.hotelImgView.image = image
            }
        }.resume()
    }
}
