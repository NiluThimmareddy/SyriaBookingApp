//
//  PromotionsDetailsVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 26/08/25.
//

import UIKit

class PromotionsDetailsVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var subdiscriptionTextView: UITextView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var averageRatingsLabel: UILabel!
    @IBOutlet weak var totalReviewsLabel: UILabel!
    
    var promotionsList: [Hotel] = []
    var selectedHotel: Hotel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    @IBAction func dismissButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func rightArrowButtonAction(_ sender: Any) {
        self.dismiss(animated: true) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HotelDetailsViewController") as! HotelDetailsViewController
            vc.selectedHotel = self.selectedHotel
            vc.navigationItem.title = "Hotel Details"
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension PromotionsDetailsVC {
    func setUpUI() {
        backView.applyCardStyle()
        guard let hotel = selectedHotel else {return}
        subdiscriptionTextView.text = hotel.shortDescription
        hotelNameLabel.text = hotel.name
        cityNameLabel.text = hotel.city
        averageRatingsLabel.text = "\(hotel.averageRating)/5"
        totalReviewsLabel.text = "\(hotel.reviewCount) reviews"
        
        if let imageUrl = hotel.images.first, !imageUrl.isEmpty {
            hotelImageView.loadImage(from: imageUrl)
        } else {
            hotelImageView.loadImage(from: hotel.coverImageURL)
        }
        hotelImageView.applyFullBlackGradientOverlay()
        subdiscriptionTextView.layer.cornerRadius = 10
        subdiscriptionTextView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        subdiscriptionTextView.clipsToBounds = true
        
    }
}
