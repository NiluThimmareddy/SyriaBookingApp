//
//  AvailabilityRoomsCVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 06/08/25.
//

import UIKit

class AvailabilityRoomsCVC : UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var roomSizeLabel: UILabel!
    @IBOutlet weak var maxGuestsLabel: UILabel!
    @IBOutlet weak var refundPolicyLabel: UILabel!
    @IBOutlet weak var breakfastLabel: UILabel!
    @IBOutlet weak var amenitiesLabel: UILabel!
    @IBOutlet weak var roomRatesTableview: UITableView!
    @IBOutlet weak var bookNowButton: UIButton!
    @IBOutlet weak var roomRatesTableviewheightConstraint: NSLayoutConstraint!
    
    var selectedRoom: RoomElement?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    @IBAction func bookNowButtonAction(_ sender: Any) {
    }
}

extension AvailabilityRoomsCVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedRoom?.rates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomsRatesTVC", for: indexPath) as! RoomsRatesTVC
        guard let roomRate = selectedRoom?.rates[indexPath.row] else {
            return cell
        }
        cell.configure(with: roomRate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension AvailabilityRoomsCVC {
    func setUpUI() {
        roomRatesTableview.register(UINib(nibName: "RoomsRatesTVC", bundle: nil), forCellReuseIdentifier: "RoomsRatesTVC")
        roomImageView.applyCardStyle()
    }
    
    func configure(with rooms: RoomElement) {
        self.selectedRoom = rooms
        roomRatesTableview.reloadData()
        
        let rateCount = rooms.rates.count
        let rowHeight: CGFloat = 40
        roomRatesTableviewheightConstraint.constant = CGFloat(rateCount) * rowHeight
        self.layoutIfNeeded()

        if let imageUrlString = rooms.coverImage, !imageUrlString.isEmpty {
            roomImageView.loadImage(from: imageUrlString)
        } else {
            roomImageView.image = UIImage(named: "HotelPlaceholder 1")
        }

        let roomType = rooms.room.roomType
        let bedType = rooms.room.bedType
        let roomSize = rooms.room.roomSize ?? "N/A"
        let maxAdults = rooms.room.maxAdults
        let maxChildren = rooms.room.maxChildren
        let breakfastIncluded = rooms.room.breakfastIncluded
        let amenities = rooms.room.amenities ?? "N/A"
        let refundPolicy = rooms.room.refundPolicy ?? "N/A"

        roomNameLabel.text = "\(roomType) (\(bedType))"
        roomSizeLabel.text = "Size: \(roomSize)"
        maxGuestsLabel.text = "Max Guests: \(maxAdults) Adults, \(maxChildren) Children"
        breakfastLabel.text = "Breakfast Included: \(breakfastIncluded ? "Yes" : "No")"
        amenitiesLabel.text = "Amenities: \(amenities)"
        refundPolicyLabel.text = "Refund Policy: \(refundPolicy)"
    }

}

