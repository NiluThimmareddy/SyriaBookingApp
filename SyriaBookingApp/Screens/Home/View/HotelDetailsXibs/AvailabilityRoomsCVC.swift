//
//  AvailabilityRoomsCVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 06/08/25.
//

import UIKit

protocol AvailabilityRoomsCVCDelegate: AnyObject {
    func didTapBookNow(for room: RoomElement, selectedRate: Rate)
    func showAlertForRateSelection()
}

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
    weak var delegate: AvailabilityRoomsCVCDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    @IBAction func bookNowButtonAction(_ sender: Any) {
        guard let room = selectedRoom else { return }
        
        if let selectedRate = room.rates.first(where: { $0.isSelected == true }) {
            delegate?.didTapBookNow(for: room, selectedRate: selectedRate)
        } else {
            delegate?.showAlertForRateSelection() 
        }
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
        
        cell.checkMarkButton.tag = indexPath.row
        cell.checkMarkButton.addTarget(self, action: #selector(checkMarkTapped(_:)), for: .touchUpInside)
        cell.selectRoomsButton.tag =  indexPath.row
        
        cell.configure(with: roomRate) { [weak self] selectedQty in
            guard let self = self else { return }
            self.selectedRoom?.rates[indexPath.row].selectedQuantity = selectedQty
        }
        
        return cell
    }
    
    @objc func checkMarkTapped(_ sender: UIButton) {
        let row = sender.tag
        selectedRoom?.rates[row].isSelected?.toggle()        
        roomRatesTableview.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRoom?.rates[indexPath.row].isSelected?.toggle()
        roomRatesTableview.reloadRows(at: [indexPath], with: .none)
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
        
        let roomsizeText = "Size: \(roomSize)"
        let guestText = "Max Guests: \(maxAdults) Adults, \(maxChildren) Children"
        let refundPolicyText = "Refund Policy: \(refundPolicy)"
        let aminitiesText = "Amenities: \(amenities)"
        let breakfastText = "Breakfast Included: \(breakfastIncluded ? "Yes" : "No")"

        roomNameLabel.text = "\(roomType) (\(bedType))"
        roomSizeLabel.text = roomsizeText
        maxGuestsLabel.text = guestText
        breakfastLabel.text = breakfastText
        amenitiesLabel.text = aminitiesText
        refundPolicyLabel.text = refundPolicyText
        
        let labelConfigs: [(UILabel, String, String, UIColor)] = [
            (roomSizeLabel, roomsizeText, "Size:", .darkGray),
            (maxGuestsLabel, guestText, "Max Guests:", .darkGray),
            (refundPolicyLabel, refundPolicyText, "Refund Policy:", .darkGray),
            (amenitiesLabel, aminitiesText, "Amenities:", .systemBlue),
            (breakfastLabel, breakfastText, "Breakfast Included:", .darkGray)
        ]
        
        labelConfigs.forEach { label, fullText, highlightText, normalColor in
            label.setHighlightedText(
                fullText: fullText,
                highlightText: highlightText,
                normalFont: .systemFont(ofSize: 12),
                highlightFont: .boldSystemFont(ofSize: 13),
                normalColor: normalColor,
                highlightColor: .label
            )
        }
    }
}
