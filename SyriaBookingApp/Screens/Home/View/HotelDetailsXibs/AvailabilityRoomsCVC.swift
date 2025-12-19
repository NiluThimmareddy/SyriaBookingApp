//
//  AvailabilityRoomsCVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 06/08/25.


import UIKit
import SkeletonView

protocol AvailabilityRoomsCVCDelegate: AnyObject {
    func didTapBookNow(for room: RoomElement, selectedRate: Rate)
    func showAlertForRateSelection()
    func showRefundPolicy(for room: RoomElement)
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
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var imageCountLabel: UILabel!
    
    var isLocalRate : Bool = false
    var selectedRoom: RoomElement?
    weak var delegate: AvailabilityRoomsCVCDelegate?
    var onBooknowBottonClick : ((RoomElement?)->Void)?
    var onRateSelectionChanged: ((Rate) -> Void)?
    var parentHotel: Hotel?
    var segmentChanged : (()-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        setUpUI()
    }
    
    @IBAction func bookNowButtonAction(_ sender: Any) {
        self.onBooknowBottonClick?(selectedRoom)
    }
    
    @IBAction func refundPolicyButtonAction(_ sender : UIButton) {
        if let selectedRoom = selectedRoom {
            delegate?.showRefundPolicy(for: selectedRoom)
        }
    }
    
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        print("segment changes \(String(describing: sender.tag))")
        switch sender.selectedSegmentIndex {
        case 0:
            self.segmentChanged?()
            isLocalRate = false
            if var room = selectedRoom {
                for index in room.rates.indices {
                    room.rates[index].isSelected = false
                    room.rates[index].isLocal = false
                }
                selectedRoom = room // reassign updated value
            }
            roomRatesTableview.reloadData()
        case 1:
            isLocalRate = true
            self.segmentChanged?()
            if var room = selectedRoom {
                for index in room.rates.indices {
                    room.rates[index].isSelected = false
                    room.rates[index].isLocal = true
                }
                selectedRoom = room // reassign updated value
            }
            
            roomRatesTableview.reloadData()
        default:
            break
        }
        
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
        
        cell.configure(with: selectedRoom, ratesForLocal: isLocalRate ?? false) { [weak self] selectedQty in
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
        rate.isSelected.toggle()
        rate.isLocal = isLocalRate
        selectedRoom?.rates[row] = rate
        onRateSelectionChanged?(rate)
        
        roomRatesTableview.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard var rate = selectedRoom?.rates[indexPath.row] else { return }
        rate.isSelected.toggle()
        rate.isLocal = isLocalRate
        selectedRoom?.rates[indexPath.row] = rate
        onRateSelectionChanged?(rate)
        roomRatesTableview.reloadRows(at: [indexPath], with: .none)
    }
    
}

extension AvailabilityRoomsCVC {
    
    func setUpUI() {
        roomRatesTableview.register(UINib(nibName: "RoomsRatesTVC", bundle: nil), forCellReuseIdentifier: "RoomsRatesTVC")
        updateBookNowButtonTitle()
        roomRatesTableview.isScrollEnabled = false
        roomRatesTableview.rowHeight = UITableView.automaticDimension
        roomRatesTableview.estimatedRowHeight = 40
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(roomImageTapped))
        roomImageView.isUserInteractionEnabled = true
        roomImageView.addGestureRecognizer(tapGesture)
        
        // Setup segmented control styling and localization
        setupSegmentedControlStyling()
        segmentControl.setInternationalLocalSegments() // Add this line
        
        self.imageCountLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        imageCountLabel.layer.cornerRadius = 10
        imageCountLabel.layer.masksToBounds = true
        imageCountLabel.layer.maskedCorners = [.layerMinXMinYCorner]
    }
    
    func setupSegmentedControlStyling() {
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black
        ]
        segmentControl.setTitleTextAttributes(normalAttributes, for: .normal)
        segmentControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        segmentControl.layer.backgroundColor = UIColor.white.cgColor
        segmentControl.selectedSegmentTintColor = UIColor.black
        segmentControl.selectedSegmentIndex = 0
        
        if AppSettings.shared.selectedLanguage == .arabic {
            segmentControl.semanticContentAttribute = .forceLeftToRight
        } else {
            segmentControl.semanticContentAttribute = .forceLeftToRight
        }
    }
    
    @objc func roomImageTapped() {
        guard let selectedRoom = selectedRoom,
              let topVC = UIApplication.shared.keyWindow?.rootViewController else { return }
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let galleryVC = storyboard.instantiateViewController(withIdentifier: "HotelImagesGalleryVC") as? HotelImagesGalleryVC else { return }
        
        galleryVC.galleryType = .room
        
        let RoomImages = parentHotel?.images.filter  { $0.contains(selectedRoom.room.id) }
        if let roomImages = RoomImages, !roomImages.isEmpty {
            galleryVC.roomImages = roomImages
            
            if let roomCover = selectedRoom.coverImage,
               let initialIndex = roomImages.firstIndex(of: roomCover) {
                galleryVC.initialIndex = initialIndex
            } else {
                galleryVC.initialIndex = 0
            }
        } else {
            if let coverImage = selectedRoom.coverImage {
                galleryVC.roomImages = [coverImage]
                galleryVC.initialIndex = 0
            } else {
                print("No images available for this room")
                return
            }
        }
        
        if !galleryVC.roomImages.isEmpty {
            topVC.present(galleryVC, animated: true)
        }
    }
    
    func configure(with rooms: RoomElement) {
        self.selectedRoom = rooms
        roomRatesTableview.reloadData()
        DispatchQueue.main.async {
            self.roomRatesTableview.layoutIfNeeded()
            self.roomRatesTableviewheightConstraint.constant = self.roomRatesTableview.contentSize.height
            self.layoutIfNeeded()
        }
        
        if let imageUrlString = rooms.coverImage, !imageUrlString.isEmpty {
            roomImageView.loadImage(from: imageUrlString)
        } else {
            roomImageView.image = UIImage(named: "HotelPlaceholder 1")
        }
        
        let RoomImages = parentHotel?.images.filter  { $0.contains(rooms.room.id) }.count ?? 0
        imageCountLabel.text = "\(RoomImages)"
        
        
        let roomType = rooms.room.roomType
        let bedType = rooms.room.bedType
        let roomSize = rooms.room.roomSize ?? "N/A"
        let maxAdults = rooms.room.maxAdults
        let maxChildren = rooms.room.maxChildren
        let breakfastIncluded = rooms.room.breakfastIncluded
        let amenities = rooms.room.amenities ?? "N/A"
        
        let roomsizeText: String
        let guestText: String
        let refundPolicyText: String
        let aminitiesText: String
        let breakfastText: String
        
        if AppSettings.shared.selectedLanguage == .arabic {
            roomsizeText = "الحجم: \(roomSize)"
            guestText = "الحد الأقصى للنزلاء: \(maxAdults) بالغين، \(maxChildren) أطفال"
            refundPolicyText = "سياسة الاسترجاع: "
            aminitiesText = "المرافق: \(amenities)"
            breakfastText = "يشمل الإفطار: \(breakfastIncluded ? "نعم" : "لا")"
            rateTitleLabel.text = "الأسعار"
        } else {
            roomsizeText = "Size: \(roomSize)"
            guestText = "Max Guests: \(maxAdults) Adults, \(maxChildren) Children"
            refundPolicyText = "Refund Policy: "
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

extension UISegmentedControl {
    func setInternationalLocalSegments() {
        if AppSettings.shared.selectedLanguage == .arabic {
            self.setTitle("الدولية", forSegmentAt: 0)
            self.setTitle("المحلية", forSegmentAt: 1)
        } else {
            self.setTitle("International", forSegmentAt: 0)
            self.setTitle("Local", forSegmentAt: 1)
        }
    }
}
