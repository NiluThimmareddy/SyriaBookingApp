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

    @IBAction func dismissButtonAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func rightArrowButtonAction(_ sender: Any) {
    }
    
}

extension PromotionsDetailsVC {
    func setUpUI() {
        guard let hotel = selectedHotel else {return}
        
        subdiscriptionTextView.text = hotel.shortDescription
        hotelNameLabel.text = hotel.name
        cityNameLabel.text = hotel.city
        averageRatingsLabel.text = "\(hotel.averageRating)/5"
        totalReviewsLabel.text = "\(hotel.reviewCount) reviews"
    }
}
