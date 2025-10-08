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

class AvailabilityRoomsCVC : UICollectionViewCell, UIViewControllerTransitioningDelegate {
    
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
    @IBOutlet weak var rateTitleLabel: UILabel!
    
    var selectedRoom: RoomElement?
    weak var delegate: AvailabilityRoomsCVCDelegate?
    var onBooknowBottonClick : ((RoomElement?)->Void)?
    var onRateSelectionChanged: ((Rate) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    @IBAction func bookNowButtonAction(_ sender: Any) {
//        guard let selectedRoom = selectedRoom else { return }
        self.onBooknowBottonClick?(selectedRoom)
       
    }
    
}

extension AvailabilityRoomsCVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedRoom?.rates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomsRatesTVC", for: indexPath) as! RoomsRatesTVC
        guard let selectedRoom = selectedRoom else {
       
            return cell
        }
        
        if UserSessionManager.getUser() == nil{
            cell.isUserInteractionEnabled = false
        } else {
            cell.isUserInteractionEnabled = true
        }
        
        cell.checkMarkButton.tag = indexPath.row
        cell.checkMarkButton.addTarget(self, action: #selector(checkMarkTapped(_:)), for: .touchUpInside)
        cell.selectRoomsButton.tag =  indexPath.row
       
        cell.configure(with: selectedRoom) { [weak self] selectedQty in
            guard let self = self else { return }
            self.selectedRoom?.rates[indexPath.row].selectedQuantity = selectedQty
            if let rate = self.selectedRoom?.rates[indexPath.row] {
                self.onRateSelectionChanged?(rate)
            }
        }
        return cell
    }
    
    @objc func checkMarkTapped(_ sender: UIButton) {
        let row = sender.tag
        guard var rate = selectedRoom?.rates[row] else { return }
        rate.isSelected?.toggle()
        selectedRoom?.rates[row] = rate
        onRateSelectionChanged?(rate)
        roomRatesTableview.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard var rate = selectedRoom?.rates[indexPath.row] else { return }
        rate.isSelected?.toggle()
        selectedRoom?.rates[indexPath.row] = rate
        onRateSelectionChanged?(rate)
        roomRatesTableview.reloadRows(at: [indexPath], with: .none)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension AvailabilityRoomsCVC {
    func setUpUI() {
        roomRatesTableview.register(UINib(nibName: "RoomsRatesTVC", bundle: nil), forCellReuseIdentifier: "RoomsRatesTVC")
        updateBookNowButtonTitle()
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
        
        let roomsizeText: String
        let guestText: String
        let refundPolicyText: String
        let aminitiesText: String
        let breakfastText: String

        if AppSettings.shared.selectedLanguage == .arabic {
            roomsizeText = "الحجم: \(roomSize)"
            guestText = "الحد الأقصى للنزلاء: \(maxAdults) بالغين، \(maxChildren) أطفال"
            refundPolicyText = "سياسة الاسترجاع: \(refundPolicy)"
            aminitiesText = "المرافق: \(amenities)"
            breakfastText = "يشمل الإفطار: \(breakfastIncluded ? "نعم" : "لا")"
            rateTitleLabel.text = "الأسعار"
        } else {
            roomsizeText = "Size: \(roomSize)"
            guestText = "Max Guests: \(maxAdults) Adults, \(maxChildren) Children"
            refundPolicyText = "Refund Policy: \(refundPolicy)"
            aminitiesText = "Amenities: \(amenities)"
            breakfastText = "Breakfast Included: \(breakfastIncluded ? "Yes" : "No")"
            rateTitleLabel.text = "Rates"
        }
        
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
        
        updateBookNowButtonTitle()
    }

    func updateBookNowButtonTitle() {
        if UserSessionManager.getUser() == nil {
            if AppSettings.shared.selectedLanguage == .arabic {
                bookNowButton.setTitle("تسجيل الدخول", for: .normal)
            } else {
                bookNowButton.setTitle("Login", for: .normal)
            }
        } else {
            if AppSettings.shared.selectedLanguage == .arabic {
                bookNowButton.setTitle("احجز الآن", for: .normal)
            } else {
                bookNowButton.setTitle("Book Now", for: .normal)
            }
        }
    }
}
