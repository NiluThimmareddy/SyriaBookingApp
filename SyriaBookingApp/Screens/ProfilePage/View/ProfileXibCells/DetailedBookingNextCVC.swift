//
//  DetailedBookingNextCVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 07/07/25.
//

import UIKit

protocol DetailedBookingNextCVCDelegate: AnyObject {
    func didTapCopyButton(with text: String)
}

class DetailedBookingNextCVC: UICollectionViewCell {
    
    @IBOutlet weak var checkInCheckOutStackView: UIStackView!
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var howManyBedsLbl: UILabel!
    @IBOutlet weak var sizeLblMeter: UILabel!
    @IBOutlet weak var checkOutDate: UILabel!
    @IBOutlet weak var checkInDate: UILabel!
    @IBOutlet weak var checkOutLblTitle: UILabel!
    @IBOutlet weak var checkInLblTitle: UILabel!
    @IBOutlet weak var cancelledBgLbl: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var checkInBackView: UIView!
    @IBOutlet weak var deluxeRoomLbl: UILabel!
    @IBOutlet weak var bookingIdLvl: UILabel!
    
    weak var delegate: DetailedBookingNextCVCDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        applyTextFont()
    }
    func applyTextFont() {
        bookingIdLvl.font = UIFont.poppinsBold(16)
        deluxeRoomLbl.font = UIFont.poppinsBold(14)
        cancelledBgLbl.font = UIFont.poppinsMedium(14)
        checkInDate.font = UIFont.poppinsMedium(14)
        checkOutDate.font = UIFont.poppinsMedium(14)
        checkInLblTitle.font = UIFont.poppinsBold(14)
        checkOutLblTitle.font = UIFont.poppinsBold(14)
        sizeLblMeter.font = UIFont.poppinsMedium(14)
        howManyBedsLbl.font = UIFont.poppinsMedium(14)
        hotelImage.layer.cornerRadius = 10
        cancelledBgLbl.layer.cornerRadius = 10
        cancelledBgLbl.clipsToBounds = true
        checkInBackView.layer.cornerRadius = 10
    }
    
    @IBAction func copyButton(_ sender: Any) {
        let textToCopy = bookingIdLvl.text ?? ""
        delegate?.didTapCopyButton(with: textToCopy)
    }
}
