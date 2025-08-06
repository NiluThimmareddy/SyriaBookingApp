//
//  UserFeedBackListTVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 18/06/25.
//

import UIKit

protocol UserFeedBackListTVCDelegate: AnyObject{
    func didCompleteFeedback()
}

class UserFeedBackListTVC: UITableViewCell {
    @IBOutlet weak var starBackView: UIView!
    @IBOutlet weak var startFiveImage: UIImageView!
    @IBOutlet weak var startFourImage: UIImageView!
    @IBOutlet weak var starThreeImage: UIImageView!
    @IBOutlet weak var starTwoImage: UIImageView!
    @IBOutlet weak var starOneImage: UIImageView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var howManyDaysLeftToGiveReview: UILabel!
    @IBOutlet weak var bookedDate: UILabel!
    @IBOutlet weak var hotelLocation: UILabel!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var hotelImage: UIImageView!
    
    weak var delegate: UserFeedBackListTVCDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        backView.BackViewShadow()
        hotelImage.layer.cornerRadius = 10
        fontStyle()
    }
    func fontStyle(){
        hotelName.font = .poppinsBold(14)
        hotelLocation.font = .poppinsMedium(12)
        bookedDate.font = .poppinsMedium(12)
        howManyDaysLeftToGiveReview.font = .poppinsMedium(10 )
    }

    func setRatingStars(from ratingString: String) {
        let starImages = [starOneImage, starTwoImage, starThreeImage, startFourImage, startFiveImage]
        
        guard let rating = Int(ratingString) else {
            starImages.forEach { $0?.isHidden = true }
            return
        }
        
        for (index, star) in starImages.enumerated() {
            if index < rating {
                
                star?.image = UIImage(systemName: "star.fill") 
            } else {
                star?.image = UIImage(systemName: "star")
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func completeButton(_ sender: Any) {
        delegate?.didCompleteFeedback()
    }
    
}
