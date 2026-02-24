
import UIKit

class BookingConfirmationVC: BaseViewController, UITextViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var insideScrollView: UIView!
    @IBOutlet weak var dissmissButtonTap: UIButton!
    @IBOutlet weak var bookingRequestQueueLabel: UILabel!
    @IBOutlet weak var userBookingMessageLabel: UILabel!
    @IBOutlet weak var hotelDetailsView: UIView!
    @IBOutlet weak var hotelImgView: UIImageView!
    @IBOutlet weak var checkInTitleLabel: UILabel!
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkOutTitleLabel: UILabel!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var guestTitleLabel: UILabel!
    @IBOutlet weak var numberOfGuestLabel: UILabel!
    @IBOutlet weak var roomTypeTitleLabel: UILabel!
    @IBOutlet weak var roomTypeLabel: UILabel!
    @IBOutlet weak var bookingReferenceTitleLabel: UILabel!
    @IBOutlet weak var bookingReferenceIdLabel: UILabel!
    @IBOutlet weak var totalNightsView: UIView!
    @IBOutlet weak var totalNightsTitleLabel: UILabel!
    @IBOutlet weak var payAtHotelLabel: UILabel!
    @IBOutlet weak var totalNightsLabel: UILabel!
    @IBOutlet weak var untilCheckInLabel: UILabel!
    @IBOutlet weak var viewBookingDetailsButton: UIButton!
    @IBOutlet weak var hoteldetailsBottomView: UIView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var hotelCityLabel: UILabel!
    
    var guestName: String?
    var guestEmail: String?
    var guestPhone: String?
    var checkInDate: String?
    var checkOutDate: String?
    var numberOfGuests: String?
    var totalPrice: String?
    var roomDetails: String?
    var selectedHotel: Hotel?
    var selectedRoom: RoomElement?
    var selectedRates: [Rate] = []
    var bookingId: String?
    var roomtype: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupConfirmationMessage()
        setupBookingDetails()
        setUpLanguage()
        setupHotelImage()
        hotelDetailsView.applyCardStyle()
        setupCornerRadii()
    }
    
    private func setupCornerRadii() {
        hotelImgView.layer.cornerRadius = 20
        hotelImgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        hotelImgView.layer.masksToBounds = true
        hotelImgView.contentMode = .scaleAspectFill
        
        hoteldetailsBottomView.layer.cornerRadius = 20
        hoteldetailsBottomView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        hoteldetailsBottomView.layer.masksToBounds = true
        
        hotelDetailsView.layer.masksToBounds = false
    }
    
    private func setupConfirmationMessage() {
        guard let name = guestName, !name.isEmpty else {
            if AppSettings.shared.selectedLanguage == .english {
                userBookingMessageLabel.text = "Thanks! We've received your booking request and placed it in our processing queue. We'll finalize your booking shortly."
            } else {
                userBookingMessageLabel.text = "شكرًا! لقد تلقينا طلب الحجز الخاص بك ووضعناه في قائمة المعالجة. سنقوم بتأكيد حجزك قريبًا."
            }
            return
        }
        
        let fullText: String
        if AppSettings.shared.selectedLanguage == .english {
            fullText = """
            Thanks, \(name)! We've received your booking request and placed it in our processing queue.
            We'll finalize your booking shortly and it will appear in your booking list.
            """
        } else {
            fullText = """
            شكرًا، \(name)! لقد تلقينا طلب الحجز الخاص بك ووضعناه في قائمة المعالجة.
            سنقوم بتأكيد حجزك قريبًا وسيظهر في قائمة حجوزاتك.
            """
        }
        
        let attributedString = NSMutableAttributedString(string: fullText)
        let fullNSString = fullText as NSString
        
        // Set custom font for the entire text
        let customFont: UIFont
        if AppSettings.shared.selectedLanguage == .english {
            // Try to use Poppins or Georgia for English
            if let poppinsFont = UIFont(name: "Poppins-Regular", size: 14) {
                customFont = poppinsFont
            } else if let georgiaFont = UIFont(name: "Georgia", size: 14) {
                customFont = georgiaFont
            } else {
                customFont = UIFont.systemFont(ofSize: 14)
            }
        } else {
            customFont = UIFont.systemFont(ofSize: 14)
        }
        
        // Apply custom font to entire text
        attributedString.addAttribute(.font, value: customFont, range: NSRange(location: 0, length: fullText.count))
        
        // Bold the user's name
        let nameRange = fullNSString.range(of: name)
        if nameRange.location != NSNotFound {
            let boldFont: UIFont
            if AppSettings.shared.selectedLanguage == .english {
                if let poppinsBold = UIFont(name: "Poppins-Bold", size: 17) {
                    boldFont = poppinsBold
                } else if let georgiaBold = UIFont(name: "Georgia-Bold", size: 17) {
                    boldFont = georgiaBold
                } else {
                    boldFont = UIFont.boldSystemFont(ofSize: 17)
                }
            } else {
                boldFont = UIFont.boldSystemFont(ofSize: 17)
            }
            
            attributedString.addAttributes([
                .font: boldFont,
                .foregroundColor: UIColor.black
            ], range: nameRange)
            print("✅ Found name range: \(nameRange)")
        } else {
            print("❌ Could not find name '\(name)' in text")
        }
        
        userBookingMessageLabel.attributedText = attributedString
        userBookingMessageLabel.numberOfLines = 0
        userBookingMessageLabel.isUserInteractionEnabled = false
    }
    
    private func setupBookingDetails() {
        numberOfGuestLabel.text = numberOfGuests ?? "N/A"
        roomTypeLabel.text = roomtype ?? "N/A"
        bookingReferenceIdLabel.text = bookingId != nil ? "SBK-\(bookingId!)" : "N/A"
        hotelNameLabel.text = selectedHotel?.name
        hotelCityLabel.text = selectedHotel?.city
        // Format price with currency
        if let price = totalPrice, !price.isEmpty {
            payAtHotelLabel.text = "Pay at hotel: \(price)"
        } else {
            payAtHotelLabel.text = "Pay at hotel"
        }
        
        if let checkIn = checkInDate, let checkOut = checkOutDate {
            let formattedCheckIn = formatDateString(checkIn)
            let formattedCheckOut = formatDateString(checkOut)
            
            checkInDateLabel.text = formattedCheckIn
            checkOutDateLabel.text = formattedCheckOut
            totalNightsLabel.text = calculateNightsBetween(checkIn: checkIn, checkOut: checkOut)
        } else {
            checkInDateLabel.text = "N/A"
            checkOutDateLabel.text = "N/A"
            totalNightsLabel.text = "N/A"
        }
    }
    
    private func formatDateString(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        // Try ISO8601 format first (your date format)
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime]
        
        if let date = iso8601Formatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "EEE d MMM"
            outputFormatter.locale = Locale(identifier: "en_US")
            return outputFormatter.string(from: date)
        }
        
        let possibleFormats = [
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd",
            "MM/dd/yyyy",
            "dd/MM/yyyy"
        ]
        
        var date: Date?
        for format in possibleFormats {
            inputFormatter.dateFormat = format
            if let parsedDate = inputFormatter.date(from: dateString) {
                date = parsedDate
                break
            }
        }
        
        guard let validDate = date else {
            return dateString
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "EEE d MMM"
        outputFormatter.locale = Locale(identifier: "en_US")
        
        let formattedDate = outputFormatter.string(from: validDate)
        return formattedDate
    }
    
    private func calculateNightsBetween(checkIn: String, checkOut: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime]
        
        var checkInDate: Date?
        var checkOutDate: Date?
        
        checkInDate = iso8601Formatter.date(from: checkIn)
        if checkInDate != nil {
            print("✅ Parsed checkIn with ISO8601 formatter")
        }
        
        // Parse check-out date with ISO8601
        checkOutDate = iso8601Formatter.date(from: checkOut)
        if checkOutDate != nil {
            print("✅ Parsed checkOut with ISO8601 formatter")
        }
        
        // If ISO8601 fails, try other formats
        let possibleFormats = [
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd"
        ]
        
        if checkInDate == nil {
            for format in possibleFormats {
                inputFormatter.dateFormat = format
                checkInDate = inputFormatter.date(from: checkIn)
                if checkInDate != nil {
                    print("✅ Parsed checkIn with format: \(format)")
                    break
                }
            }
        }
        
        if checkOutDate == nil {
            for format in possibleFormats {
                inputFormatter.dateFormat = format
                checkOutDate = inputFormatter.date(from: checkOut)
                if checkOutDate != nil {
                    print("✅ Parsed checkOut with format: \(format)")
                    break
                }
            }
        }
        
        guard let inDate = checkInDate, let outDate = checkOutDate else {
            return "N/A"
        }
        
        // Calculate nights
        let nights = Calendar.current.dateComponents([.day], from: inDate, to: outDate).day ?? 0
        if nights == 0 {
            return "1 Night"
        } else {
            return "\(nights) Night\(nights != 1 ? "s" : "")"
        }
    }
    
    private func setupHotelImage() {
        if let hotel = selectedHotel, let imageUrlString = hotel.coverImageURL as? String,
           let imageUrl = URL(string: imageUrlString) {
            
            // Load image asynchronously
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: imageUrl),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.hotelImgView.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.hotelImgView.image = UIImage(named: "hotel_placeholder")
                    }
                }
            }
        } else {
            hotelImgView.image = UIImage(named: "hotel_placeholder") ?? UIImage(systemName: "building.fill")
        }
    }
    
    // MARK: - TextView Delegate (kept for compatibility)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "mybookings://open" {
            navigateToBookingDetails()
        }
        return false
    }
    
    private func navigateToBookingDetails() {
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        
        guard let viewBookingConfirmationVC = storyboard.instantiateViewController(withIdentifier: "ViewBookingConfirmationVC") as? ViewBookingConfirmationVC else {
            return
        }
        
        viewBookingConfirmationVC.isFromMyBookings = false
        viewBookingConfirmationVC.hotelID = selectedHotel?.id ?? ""
        viewBookingConfirmationVC.bookingId = bookingId ?? ""
        viewBookingConfirmationVC.roomType = roomtype ?? ""
        viewBookingConfirmationVC.modalPresentationStyle = .fullScreen
        present(viewBookingConfirmationVC, animated: true)
    }
    
    // MARK: - Language Setup
    @objc func setUpLanguage() {
        if AppSettings.shared.selectedLanguage == .english {
            checkInTitleLabel.text = "CHECK-IN"
            checkOutTitleLabel.text = "CHECK-OUT"
            guestTitleLabel.text = "GUEST"
            roomTypeTitleLabel.text = "ROOM TYPE"
            bookingReferenceTitleLabel.text = "BOOKING REFERENCE"
            totalNightsTitleLabel.text = "TOTAL NIGHTS"
            viewBookingDetailsButton.setTitle("View Booking Details", for: .normal)
        } else {
            checkInTitleLabel.text = "تسجيل الوصول"
            checkOutTitleLabel.text = "تسجيل المغادرة"
            guestTitleLabel.text = "الضيف"
            roomTypeTitleLabel.text = "نوع الغرفة"
            bookingReferenceTitleLabel.text = "رقم الحجز"
            totalNightsTitleLabel.text = "إجمالي الليالي"
            viewBookingDetailsButton.setTitle("عرض تفاصيل الحجز", for: .normal)
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        navigateToHomeTab()
    }
    
    @IBAction func viewBookingDetailsButtonAction(_ sender: Any) {
        navigateToBookingDetails()
    }
}
