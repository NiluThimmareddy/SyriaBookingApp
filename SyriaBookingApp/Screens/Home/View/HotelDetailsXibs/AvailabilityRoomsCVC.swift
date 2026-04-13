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
    func showLoginRequiredAlert()
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
    @IBOutlet weak var noRatesLabel: UILabel!
    @IBOutlet weak var refundTitleButton: UIButton!
    @IBOutlet weak var unavailablePricingLabel: UILabel!
    @IBOutlet weak var roomStatusLabel : UILabel!
    
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
        // user nil
        if UserSessionManager.getUser() == nil{
            self.onBooknowBottonClick?(selectedRoom)
        }else{
            if let room = selectedRoom {
                // Check if there's at least one selected rate with valid price
                let hasSelectedValidRate = room.rates.contains { rate in
                    let hasValidPrice = isLocalRate ? (rate.localPrice ?? 0) > 0 : rate.price > 0
                    return rate.isSelected && hasValidPrice
                }
                
                if !hasSelectedValidRate {
                    // No valid rate selected - show alert
                    delegate?.showAlertForRateSelection()
                    return
                }
            }
            
            self.onBooknowBottonClick?(selectedRoom)
        }
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
            updateRatesForSelectedSegment()
            updateBookNowButtonState()
        case 1:
            isLocalRate = true
            self.segmentChanged?()
            updateRatesForSelectedSegment()
            updateBookNowButtonState()
        default:
            break
        }
    }
    
    private func updateBookNowButtonState() {
        guard let room = selectedRoom else { return }
        
        // Check if there's at least one rate with a valid price
        let hasValidPrice = room.rates.contains { rate in
            if isLocalRate {
                return (rate.localPrice ?? 0) > 0
            } else {
                return rate.price > 0
            }
        }
        
        if !hasValidPrice {
            // No valid prices available - hide book button and show unavailable message
            bookNowButton.isHidden = true
            unavailablePricingLabel.isHidden = false
            roomRatesTableview.alpha = 0.8
            
            if AppSettings.shared.selectedLanguage == .arabic {
                unavailablePricingLabel.text = "أسعار العملة المحلية غير متوفرة حالياً"
            } else {
                unavailablePricingLabel.text = "Local currency pricing is currently unavailable"
                unavailablePricingLabel.textColor = .systemRed
            }
        } else {
            if let status = selectedRoom?.room.roomStatus, status.lowercased() != "available" {
                bookNowButton.isHidden = true
                unavailablePricingLabel.isHidden = false
                roomRatesTableview.alpha = 0.8
                unavailablePricingLabel.text = ""
            }else{
                unavailablePricingLabel.text = ""
                // At least one valid price exists - show book button and enable selection
                bookNowButton.isHidden = false
                unavailablePricingLabel.isHidden = true
                roomRatesTableview.alpha = 1.0
                updateBookNowButtonTitle()
                bookNowButton.backgroundColor = UIColor.label
                bookNowButton.setTitleColor(.white, for: .normal)
                bookNowButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
                bookNowButton.isEnabled = true
            }
        }
    }
    
    private func updateRatesForSelectedSegment() {
        let hasRates = !(selectedRoom?.rates.isEmpty ?? true)
        
        roomRatesTableview.isHidden = !hasRates
        noRatesLabel.isHidden = hasRates
        
        if hasRates {
            if var room = selectedRoom {
                for index in room.rates.indices {
                    room.rates[index].isSelected = false
                    room.rates[index].isLocal = isLocalRate
                }
                selectedRoom = room
            }
            roomRatesTableview.reloadData()
            
            DispatchQueue.main.async {
                self.roomRatesTableview.layoutIfNeeded()
                self.roomRatesTableviewheightConstraint.constant = self.roomRatesTableview.contentSize.height
                self.layoutIfNeeded()
            }
        } else {
            roomRatesTableviewheightConstraint.constant = 0
        }
    }
    
    func setUpUI() {
        backView.applyCardStyle()
        roomRatesTableview.register(UINib(nibName: "RoomsRatesTVC", bundle: nil), forCellReuseIdentifier: "RoomsRatesTVC")
        updateBookNowButtonTitle()
        roomRatesTableview.isScrollEnabled = false
        roomRatesTableview.rowHeight = UITableView.automaticDimension
        roomRatesTableview.estimatedRowHeight = 40
        roomRatesTableview.delegate = self
        roomRatesTableview.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(roomImageTapped))
        roomImageView.isUserInteractionEnabled = true
        roomImageView.addGestureRecognizer(tapGesture)
        
        setupSegmentedControlStyling()
        segmentControl.setInternationalLocalSegments()
        
        self.imageCountLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        imageCountLabel.layer.cornerRadius = 10
        imageCountLabel.layer.masksToBounds = true
        imageCountLabel.layer.maskedCorners = [.layerMinXMinYCorner]
        
        configureNoRatesLabel()
        
        let lang = AppSettings.shared.selectedLanguage
        let buttonFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        if lang == .arabic {
            let refundTitle = NSAttributedString(
                string: "عرض",
                attributes: [
                    .font: buttonFont,
                    .foregroundColor: refundTitleButton.titleColor(for: .normal) ?? .systemBlue
                ]
            )
            refundTitleButton.setAttributedTitle(refundTitle, for: .normal)
        } else {
            let refundTitle = NSAttributedString(
                string: "View",
                attributes: [
                    .font: buttonFont,
                    .foregroundColor: refundTitleButton.titleColor(for: .normal) ?? .systemBlue
                ]
            )
            refundTitleButton.setAttributedTitle(refundTitle, for: .normal)
        }
        
        unavailablePricingLabel.isHidden = true
        unavailablePricingLabel.textAlignment = .center
        unavailablePricingLabel.textColor = .label
        unavailablePricingLabel.backgroundColor = .clear
        unavailablePricingLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        unavailablePricingLabel.numberOfLines = 0
        
        roomStatusLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        roomStatusLabel.cornerRadius = 10
        roomStatusLabel.clipsToBounds = true
    }
    
    private func configureNoRatesLabel() {
        noRatesLabel.isHidden = true
        noRatesLabel.textAlignment = .center
        noRatesLabel.textColor = .red
        noRatesLabel.font = .systemFont(ofSize: 14, weight: .medium)
        noRatesLabel.numberOfLines = 0
        
        if AppSettings.shared.selectedLanguage == .arabic {
            noRatesLabel.text = "لا توجد أسعار متاحة حالياً"
        } else {
            noRatesLabel.text = "No rates available at the moment"
           
        }
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
                return
            }
        }
        
        if !galleryVC.roomImages.isEmpty {
            galleryVC.modalPresentationStyle = .overFullScreen
            topVC.modalPresentationStyle = .overFullScreen
            topVC.present(galleryVC, animated: true)
        }
    }
    
    func configure(with rooms: RoomElement) {
        self.selectedRoom = rooms
        
        let hasRates = !rooms.rates.isEmpty
        
        updateRatesVisibility(hasRates: hasRates)
        
        if hasRates {
            roomRatesTableview.reloadData()
            DispatchQueue.main.async {
                self.roomRatesTableview.layoutIfNeeded()
                self.roomRatesTableviewheightConstraint.constant = self.roomRatesTableview.contentSize.height
                self.layoutIfNeeded()
            }
            updateBookNowButtonState()
        } else {
            roomRatesTableviewheightConstraint.constant = 0
        }
        
        if let imageUrlString = rooms.coverImage, !imageUrlString.isEmpty {
            roomImageView.loadImage(from: imageUrlString)
        } else {
            roomImageView.image = UIImage(named: "HotelPlaceholder 1")
        }
        
        let roomImagesCount = parentHotel?.images.filter { $0.contains(rooms.room.id) }.count ?? 0
        imageCountLabel.text = "\(roomImagesCount)"
        imageCountLabel.isHidden = roomImagesCount == 0
        
        configureRoomDetails(rooms)
    }
    
    private func updateRatesVisibility(hasRates: Bool) {
        roomRatesTableview.isHidden = !hasRates
        rateTitleLabel.isHidden = !hasRates
        segmentControl.isHidden = !hasRates
        noRatesLabel.isHidden = hasRates
        unavailablePricingLabel.isHidden = true
    }
    
    private func configureRoomDetails(_ rooms: RoomElement) {
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
        if let status = rooms.room.roomStatus {
            let statusColor = setStatusColor(status: status)
            roomStatusLabel.textColor = statusColor
            roomStatusLabel.backgroundColor = statusColor.withAlphaComponent(0.10)
            roomStatusLabel.text = status
        }
 
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
    }
    
    func setStatusColor(status:String) -> UIColor {
        let statusData = status.lowercased()
        switch statusData {
        case "available":
            return UIColor.systemGreen
        case "reserved":
            return UIColor.systemBlue
        case "undermaintenance":
            return UIColor.systemOrange
        case "inactive":
            return UIColor.systemOrange
        case "outofservice":
            return UIColor.systemRed
        default :
            return UIColor.clear
            
        }
    }
    
    func updateBookNowButtonTitle() {
        if UserSessionManager.getUser() == nil {
            if AppSettings.shared.selectedLanguage == .arabic {
                bookNowButton.setTitle("تسجيل الدخول | إنشاء حساب", for: .normal)
            } else {
                bookNowButton.setTitle("Login | Sign Up", for: .normal)
            }
        } else {
            if AppSettings.shared.selectedLanguage == .arabic {
                bookNowButton.setTitle("احجز الآن", for: .normal)
            } else {
                bookNowButton.setTitle("Book Now", for: .normal)
            }
        }
        
        bookNowButton.setTitleColor(.white, for: .normal)
        bookNowButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        bookNowButton.backgroundColor = UIColor.label
    }
    
}

// MARK: - UITableView Delegate & DataSource
extension AvailabilityRoomsCVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedRoom?.rates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomsRatesTVC", for: indexPath) as! RoomsRatesTVC
        guard let selectedRoom = selectedRoom else {
            return cell
        }
        
        cell.checkMarkButton.tag = indexPath.row
        cell.checkMarkButton.addTarget(self, action: #selector(checkMarkTapped(_:)), for: .touchUpInside)

        let isLoggedIn = UserSessionManager.getUser() != nil
        let currentRate = selectedRoom.rates[indexPath.row]
        
        // Check if this specific rate has a valid price
        let hasValidPrice = isLocalRate ? (currentRate.localPrice ?? 0) > 0 : currentRate.price > 0

        if !hasValidPrice{
            // This rate has zero price - disable it
            cell.checkMarkButton.isUserInteractionEnabled = false
            cell.checkMarkButton.alpha = 0.3
            cell.selectRoomsButton.isUserInteractionEnabled = false
            cell.selectRoomsButton.isEnabled = false
            cell.selectRoomsButton.alpha = 0.3
            cell.roomPriceLabel.alpha = 0.3
            cell.roomsTitleLabel.alpha = 0.3
            cell.contentView.alpha = 0.7
            
            // Show unavailable message for zero-price rows
            if AppSettings.shared.selectedLanguage == .arabic {
                cell.roomPriceLabel.text = "السعر غير متاح"
            } else {
                cell.roomPriceLabel.text = "Price unavailable"
            }
        } else {
            
            if let status = selectedRoom.room.roomStatus, status.lowercased() != "available" {
                cell.checkMarkButton.isUserInteractionEnabled = false
                cell.checkMarkButton.isEnabled = false
                cell.selectRoomsButton.alpha = 0.3
                cell.roomPriceLabel.alpha = 0.3
                cell.roomsTitleLabel.alpha = 0.3
                cell.selectRoomsButton.isUserInteractionEnabled = false
                cell.selectRoomsButton.isEnabled = false
                cell.contentView.alpha = 0.7
                
            }else{
                // This rate has valid price
                cell.selectRoomsButton.isUserInteractionEnabled = isLoggedIn
                cell.selectRoomsButton.alpha = isLoggedIn ? 1.0 : 0.5
                cell.checkMarkButton.isUserInteractionEnabled = isLoggedIn
                cell.checkMarkButton.alpha = isLoggedIn ? 1.0 : 0.5
                cell.roomPriceLabel.alpha = 1.0
                cell.contentView.alpha = 1.0
                cell.roomsTitleLabel.alpha = 1.0
                cell.selectRoomsButton.isEnabled = true
            }
            
        }
        
        cell.selectRoomsButton.tag = indexPath.row
        cell.configure(with: selectedRoom, ratesForLocal: isLocalRate) { [weak self] selectedQty in
            guard let self = self else { return }
            
            self.selectedRoom?.rates[indexPath.row].selectedQuantity = selectedQty
            if let rate = self.selectedRoom?.rates[indexPath.row] {
                self.onRateSelectionChanged?(rate)
            }
        }
        return cell
    }
    
    @objc func checkMarkTapped(_ sender: UIButton) {
        if UserSessionManager.getUser() == nil {
            delegate?.showLoginRequiredAlert()
            return
        }
        
        let row = sender.tag
        guard var rate = selectedRoom?.rates[row] else { return }
        
        // Check if this specific rate has a valid price
        let hasValidPrice = isLocalRate ? (rate.localPrice ?? 0) > 0 : rate.price > 0
        if !hasValidPrice {
            return // Don't allow selection of zero-price rates
        }
        
        if let status = selectedRoom?.room.roomStatus, status.lowercased() != "available" {
            return
        }
        
        rate.isSelected.toggle()
        
        rate.isLocal = isLocalRate
        selectedRoom?.rates[row] = rate
        onRateSelectionChanged?(rate)
    
        roomRatesTableview.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserSessionManager.getUser() == nil {
            delegate?.showLoginRequiredAlert()
            return
        }
        
        guard var rate = selectedRoom?.rates[indexPath.row] else { return }
        
        // Check if this specific rate has a valid price
        let hasValidPrice = isLocalRate ? (rate.localPrice ?? 0) > 0 : rate.price > 0
        if !hasValidPrice {
            return // Don't allow selection of zero-price rates
        }
        
        if let status = selectedRoom?.room.roomStatus, status.lowercased() != "available" {
            return
        }
        
        rate.isSelected.toggle()
        
        rate.isLocal = isLocalRate
        selectedRoom?.rates[indexPath.row] = rate
        onRateSelectionChanged?(rate)
        roomRatesTableview.reloadRows(at: [indexPath], with: .none)
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
