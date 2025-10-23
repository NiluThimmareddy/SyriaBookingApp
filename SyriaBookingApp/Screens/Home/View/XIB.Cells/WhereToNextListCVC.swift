//
//  WhereToNextListCVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 17/10/25.
//
 
import UIKit

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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backView.applyCardStyle()
    }
    
    func configure(with hotel: Hotel, language: Languages) {
        let hotelName = language == .english ? hotel.name : hotel.nameAR
        hotelNameLabel.text = hotelName
        
        hotelTypeLabel.text = "\(hotel.type)"
        
        let price = hotel.minRoomPrice
        if !price.isEmpty {
            if language == .english {
                pricePerNightLabel.text = "$\(price)/night"
            } else {
                pricePerNightLabel.text = "\(price) دولار/ليلة"
            }
        } else {
            pricePerNightLabel.text = language == .english ? "Price on request" : "السعر عند الطلب"
        }
        
        ratingLabel?.text = String(format: "%.1f", hotel.averageRating)
        
        // Fixed: Remove unnecessary casting
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
}

