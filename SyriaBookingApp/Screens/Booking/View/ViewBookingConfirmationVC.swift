//
//  ViewBookingConfirmationVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 11/08/25.
//

import UIKit

class ViewBookingConfirmationVC : UIViewController {

    @IBOutlet weak var checkMarkImgView: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var bookingReferenceLabel: UILabel!
    @IBOutlet weak var bookingDateLabel: UILabel!
    @IBOutlet weak var checkInLabel: UILabel!
    @IBOutlet weak var checkOutLabel: UILabel!
    @IBOutlet weak var totalNightsLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var guestLabel: UILabel!
    @IBOutlet weak var guestEmailLabel: UILabel!
    @IBOutlet weak var guestPhoneNoLabel: UILabel!
    @IBOutlet weak var numberOfGuestsLabel: UILabel!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var hotelAddressLabel: UILabel!
    @IBOutlet weak var hotelPhoneNumberLabel: UILabel!
    @IBOutlet weak var hotelEmailLabel: UILabel!
    @IBOutlet weak var hotelCheckInTimeLabel: UILabel!
    @IBOutlet weak var hotelCheckOutTimeLabel: UILabel!
    @IBOutlet weak var roomTypeLabel: UILabel!
    @IBOutlet weak var acceptedCurrenciesLabel: UILabel!
    @IBOutlet weak var languagesSpokenLabel: UILabel!
    @IBOutlet weak var roomRateDetailsTableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roomRateDetailsTableview.register(UINib(nibName: "RoomRateTVC", bundle: nil), forCellReuseIdentifier: "RoomRateTVC")
    }

}

extension ViewBookingConfirmationVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomRateTVC") as! RoomRateTVC
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
