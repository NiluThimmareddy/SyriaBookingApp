
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
    @IBOutlet weak var goToHomeButton: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
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
    var selectedCurrency : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc func updateTexts() {
        setupConfirmationMessage()
        setupEmailMessage()
        setUpLanguage()
        setupBookingDetails()
        
        let lang = AppSettings.shared.selectedLanguage
        let semibold13 = UIFont.systemFont(ofSize: 13, weight: .semibold)
        
        var goToHomeConfig = goToHomeButton.configuration ?? UIButton.Configuration.plain()
        goToHomeConfig.attributedTitle = AttributedString(
            lang == .arabic ? "الرجوع إلى الرئيسية" : "Go to Home",
            attributes: AttributeContainer([
                .font: semibold13
            ])
        )
        goToHomeButton.configuration = goToHomeConfig
        payAtHotelLabel.text = lang == .arabic ? "(الدفع في الفندق)" : "(Pay at Hotel)"
    }
    
    private func setupUI() {
        setupConfirmationMessage()
        setupBookingDetails()
        setUpLanguage()
        setupEmailMessage()
        setupHotelImage()
        hotelDetailsView.applyCardStyle()
        setupCornerRadii()
        updateTexts()
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
        let lang = AppSettings.shared.selectedLanguage
        
        guard let name = guestName, !name.isEmpty else {
            if lang == .english {
                userBookingMessageLabel.text = "Thanks! We've received your booking request and placed it in our processing queue. We'll finalize your booking shortly."
            } else {
                userBookingMessageLabel.text = "شكرًا! لقد تلقينا طلب الحجز الخاص بك ووضعناه في قائمة المعالجة. سنقوم بتأكيد حجزك قريبًا."
            }
            
            bookingRequestQueueLabel.text = lang == .english ? "Booking Request Queued" : "طلب الحجز في قائمة الانتظار"
            return
        }
        
        bookingRequestQueueLabel.text = lang == .english ? "Booking Request Queued" : "طلب الحجز في قائمة الانتظار"
        
        let fullText: String
        if lang == .english {
            fullText = """
            Thanks, \(name)! We've received your booking request and placed it in our processing queue. We'll finalize your booking shortly and it will appear in your booking list.
            """
        } else {
            fullText = """
            شكرًا، \(name)! لقد تلقينا طلب الحجز الخاص بك ووضعناه في قائمة المعالجة. سنقوم بتأكيد حجزك قريبًا وسيظهر في قائمة حجوزاتك.
            """
        }
        
        let attributedString = NSMutableAttributedString(string: fullText)
        let fullNSString = fullText as NSString
        
        let customFont: UIFont
        if lang == .english {
            if let poppinsFont = UIFont(name: "Poppins-Regular", size: 13) {
                customFont = poppinsFont
            } else if let georgiaFont = UIFont(name: "Georgia", size: 13) {
                customFont = georgiaFont
            } else {
                customFont = UIFont.systemFont(ofSize: 13)
            }
        } else {
            customFont = UIFont.systemFont(ofSize: 13)
        }
        
        attributedString.addAttribute(.font, value: customFont, range: NSRange(location: 0, length: fullText.count))
        
        let nameRange = fullNSString.range(of: name)
        if nameRange.location != NSNotFound {
            let boldFont: UIFont
            if lang == .english {
                if let poppinsBold = UIFont(name: "Poppins-Bold", size: 13) {
                    boldFont = poppinsBold
                } else if let georgiaBold = UIFont(name: "Georgia-Bold", size: 13) {
                    boldFont = georgiaBold
                } else {
                    boldFont = UIFont.boldSystemFont(ofSize: 13)
                }
            } else {
                boldFont = UIFont.boldSystemFont(ofSize: 13)
            }
            
            attributedString.addAttributes([
                .font: boldFont,
                .foregroundColor: UIColor.black
            ], range: nameRange)
            
        }
        
        userBookingMessageLabel.attributedText = attributedString
        userBookingMessageLabel.numberOfLines = 0
        userBookingMessageLabel.isUserInteractionEnabled = false
    }
    
    private func setupEmailMessage() {
        let lang = AppSettings.shared.selectedLanguage
        
        guard let email = guestEmail, !email.isEmpty else {
            if lang == .english {
                emailLabel.text = "A confirmation email will be sent to your registered email with all booking details."
            } else {
                emailLabel.text = "سيتم إرسال بريد تأكيد إلى بريدك الإلكتروني المسجل مع جميع تفاصيل الحجز."
            }
            return
        }
        
        let fullText: String
        
        if lang == .english {
            fullText = "A confirmation email will be sent to your \(email) with all booking details."
            emailLabel.textAlignment = .center
        } else {
            fullText = "سيتم إرسال بريد تأكيد إلى \(email) مع جميع تفاصيل الحجز."
            emailLabel.textAlignment = .center
        }
        
        let attributedString = NSMutableAttributedString(string: fullText)
        let nsString = fullText as NSString
        let emailRange = nsString.range(of: email)
        
        attributedString.addAttribute(
            .font,
            value: UIFont.systemFont(ofSize: 13),
            range: NSRange(location: 0, length: fullText.count)
        )
        
        if emailRange.location != NSNotFound {
            attributedString.addAttributes([
                .foregroundColor: UIColor.systemBlue,
                .font: UIFont.systemFont(ofSize: 13, weight: .semibold)
            ], range: emailRange)
        }
        
        emailLabel.attributedText = attributedString
        emailLabel.numberOfLines = 0
    }
    
    private func setupBookingDetails() {
        let lang = AppSettings.shared.selectedLanguage
        
        numberOfGuestLabel.text = numberOfGuests ?? (lang == .arabic ? "غير محدد" : "N/A")
        roomTypeLabel.text = roomtype ?? (lang == .arabic ? "غير محدد" : "N/A")
        bookingReferenceIdLabel.text = bookingId != nil ? "SBK-\(bookingId!)" : (lang == .arabic ? "غير محدد" : "N/A")
        hotelNameLabel.text = selectedHotel?.name
        hotelCityLabel.text = selectedHotel?.city
        
        let currency = selectedCurrency == "International ($)" ? "$" : "SAR"
        if let price = totalPrice, !price.isEmpty {
            if lang == .arabic {
                amountLabel.text = "المبلغ: \(price) \(currency)"
            } else {
                amountLabel.text = "Amount: \(price) \(currency)"
            }
        } else {
            amountLabel.text = lang == .arabic ? "المبلغ" : "Amount"
        }
        
        if let checkIn = checkInDate, let checkOut = checkOutDate {
            let formattedCheckIn = formatDateString(checkIn)
            let formattedCheckOut = formatDateString(checkOut)
            
            checkInDateLabel.text = formattedCheckIn
            checkOutDateLabel.text = formattedCheckOut
            totalNightsLabel.text = calculateNightsBetween(checkIn: checkIn, checkOut: checkOut)
        } else {
            checkInDateLabel.text = lang == .arabic ? "غير محدد" : "N/A"
            checkOutDateLabel.text = lang == .arabic ? "غير محدد" : "N/A"
            totalNightsLabel.text = lang == .arabic ? "غير محدد" : "N/A"
        }
    }
    
    private func formatDateString(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
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
        let lang = AppSettings.shared.selectedLanguage
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime]
        
        var checkInDate: Date?
        var checkOutDate: Date?
        
        checkInDate = iso8601Formatter.date(from: checkIn)
      
        
        checkOutDate = iso8601Formatter.date(from: checkOut)
 
        
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
                  
                    break
                }
            }
        }
        
        if checkOutDate == nil {
            for format in possibleFormats {
                inputFormatter.dateFormat = format
                checkOutDate = inputFormatter.date(from: checkOut)
                if checkOutDate != nil {
                   
                    break
                }
            }
        }
        
        guard let inDate = checkInDate, let outDate = checkOutDate else {
            return lang == .arabic ? "غير محدد" : "N/A"
        }
        
        let nights = Calendar.current.dateComponents([.day], from: inDate, to: outDate).day ?? 0
        
        if lang == .arabic {
            if nights == 0 {
                return "ليلة واحدة"
            } else if nights == 1 {
                return "ليلة واحدة"
            } else if nights == 2 {
                return "ليلتان"
            } else {
                return "\(nights) ليالي"
            }
        } else {
            if nights == 0 {
                return "1 Night"
            } else {
                return "\(nights) Night\(nights != 1 ? "s" : "")"
            }
        }
    }
    
    private func setupHotelImage() {
        if let hotel = selectedHotel, let imageUrlString = hotel.coverImageURL as? String,
           let imageUrl = URL(string: imageUrlString) {
            
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
    
    @objc func setUpLanguage() {
        let lang = AppSettings.shared.selectedLanguage
        let semibold13 = UIFont.systemFont(ofSize: 13, weight: .semibold)
        
        var config = viewBookingDetailsButton.configuration ?? UIButton.Configuration.plain()
        config.attributedTitle = AttributedString(
            lang == .english ? "View Booking Details" : "عرض تفاصيل الحجز",
            attributes: AttributeContainer([
                .font: semibold13
            ])
        )
        viewBookingDetailsButton.configuration = config
        
        var goToHomeConfig = goToHomeButton.configuration ?? UIButton.Configuration.plain()
        goToHomeConfig.attributedTitle = AttributedString(
            lang == .arabic ? "الرجوع إلى الرئيسية" : "Go to Home",
            attributes: AttributeContainer([
                .font: semibold13
            ])
        )
        goToHomeButton.configuration = goToHomeConfig
        
        if lang == .english {
            checkInTitleLabel.text = "CHECK-IN"
            checkOutTitleLabel.text = "CHECK-OUT"
            guestTitleLabel.text = "GUEST"
            roomTypeTitleLabel.text = "ROOM TYPE"
            bookingReferenceTitleLabel.text = "BOOKING REFERENCE"
            totalNightsTitleLabel.text = "TOTAL NIGHTS"
            payAtHotelLabel.text = "(Pay at Hotel)"
        } else {
            checkInTitleLabel.text = "تسجيل الوصول"
            checkOutTitleLabel.text = "تسجيل المغادرة"
            guestTitleLabel.text = "الضيف"
            roomTypeTitleLabel.text = "نوع الغرفة"
            bookingReferenceTitleLabel.text = "رقم الحجز"
            totalNightsTitleLabel.text = "إجمالي الليالي"
            payAtHotelLabel.text = "(الدفع في الفندق)"
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        navigateToHomeTab()
    }
    
    @IBAction func viewBookingDetailsButtonAction(_ sender: Any) {
        navigateToBookingDetails()
    }
    
    @IBAction func goToHomeButtonAction(_ sender: Any) {
        navigateToHomeTab()
    }
}
