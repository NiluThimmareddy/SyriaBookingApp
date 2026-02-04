
import UIKit
import Reachability

class ConfirmYourBookingVC : BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var guestNameLabel: UILabel!
    @IBOutlet weak var guestEmailLabel: UILabel!
    @IBOutlet weak var guestMobileNumberTF: UITextField!
    @IBOutlet weak var numberOfGuestsTF: UITextField!
    @IBOutlet weak var checkInTF: UITextField!
    @IBOutlet weak var checkOutTF: UITextField!
    @IBOutlet weak var selectedRoomAndRatesLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var submitBookingButton: UIButton!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var checkOutButton: UIButton!
    @IBOutlet weak var increaseNoButton: UIButton!
    @IBOutlet weak var decreaseNoButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var confirmYourBookingTitleLabel: UILabel!
    @IBOutlet weak var guestNameTitleLabel: UILabel!
    @IBOutlet weak var guestEmailTitleLabel: UILabel!
    @IBOutlet weak var guestPhoneTitleLabel: UILabel!
    @IBOutlet weak var numberOfGuestsTitleLabel: UILabel!
    @IBOutlet weak var checkInTitleLabel: UILabel!
    @IBOutlet weak var checkOutTitleLabel: UILabel!
    @IBOutlet weak var selectedRoomsAndRatesLabel: UILabel!
    @IBOutlet weak var totalAmountTitleLabel: UILabel!
    @IBOutlet weak var bookingTypeTitleLabel: UILabel!
    @IBOutlet weak var bookingTypeLabel: UILabel!
    @IBOutlet weak var totalNightsTitleLabel: UILabel!
    @IBOutlet weak var totalNightsCountLabel: UILabel!
    @IBOutlet weak var totalDiscountTitleLabel: UILabel!
    @IBOutlet weak var totalDiscountAmountLabel: UILabel!
    @IBOutlet weak var netTotalTitleLabel: UILabel!
    @IBOutlet weak var netTotalAmountLabel: UILabel!
    
    var guestName: String?
    var guestEmail: String?
    var guestMobileNumber: String?
    
    var datePickerContainerView: UIView!
    var datePicker: UIDatePicker!
    var activeButton: UIButton?
    var currentDatePickerMode: DatePickerMode = .checkIn
    var datePickerBottomConstraint: NSLayoutConstraint?
    var isDatePickerShown = false
    var formattedTotal = ""
    
    var totalAmount = 0.0
    var netAmountAfterDiscount =  0.0
    
    var selectedHotel: Hotel?
    var selectedRoom: RoomElement?
    var selectedRates: [Rate] = []
    var viewModel = BookingViewModel()
    var roomRatesData = ""
    
    var totalGrossAmount = 0.0
    var totalNetAmount = 0.0
    var totalDiscountAmount = 0.0
    var roomRatesDataDisplay = ""
    var roomRatesDataAPI = ""
    var  finaltotalDiscountAmount = 0.0
    var reachability : Reachability?
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInTF.text = ""
        checkOutTF.text = ""
        setUpUI()
        hideKeyboardWhenTappedAround()
        numberOfGuestsTF.delegate = self
        checkInTF.delegate = self
        checkOutTF.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if let checkInDate = selectedCheckInDate,
           let checkOutDate = selectedCheckOutDate{
            
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE dd MMM"
//            formatter.dateStyle = .medium
            
            checkInTF.text = formatter.string(from: checkInDate)
            checkOutTF.text = formatter.string(from: checkOutDate)
        }else{
            let today = Date()
            selectedCheckInDate = today
            
            if let tomorrow = Calendar.current.date(byAdding: .day, value: 0, to: today) {
                selectedCheckOutDate = tomorrow
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE dd MMM"
//            formatter.dateStyle = .medium
            
            checkInTF.text = formatter.string(from: selectedCheckInDate!)
            checkOutTF.text = formatter.string(from: selectedCheckOutDate!)
        }
        
      
        
       
        updateTotalAmountLabel(isLocal: selectedRoom?.rates[0].isLocal ?? false)
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func checkInButtonAction(_ sender: Any) {
        currentDatePickerMode = .checkIn
        updateDatePickerLimits()
        toggleDatePicker(for: checkInButton)
    }
    
    @IBAction func checkOutButtonAction(_ sender: Any) {
        currentDatePickerMode = .checkOut
        updateDatePickerLimits()
        toggleDatePicker(for: checkOutButton)
    }
    
    @IBAction func submitBookingButtonAction(_ sender: Any) {
        
//        guard let reachability = try? Reachability(), reachability.connection != .unavailable else {
//            showAlert("No Internet Connection. Please check your network and try again.")
//            return
//        }
        
        guard let noOfGuestText = numberOfGuestsTF.text,
              !noOfGuestText.isEmpty,
              let noOfGuest = Int(noOfGuestText) else {
            showAlert("Please enter a valid number of guests.")
            return
        }
        
        guard let  checkInDate = selectedCheckInDate else {
            showAlert("Please select a check-in date.")
            return
        }
        
        guard let checkOutDate = selectedCheckOutDate else {
            showAlert("Please select a check-out date.")
            return
        }
        
        guard let guestMobileNumber = guestMobileNumberTF.text, !guestMobileNumber.isEmpty else {
            showAlert("Please enter a mobile number.")
            return
        }
        
        guard let user = UserSessionManager.getUser(),
              let hotel = selectedHotel,
              let selectedRoom = selectedRoom else { return }
        
        showLoader()
        
        let checkInISO = iso8601String(from: checkInDate)
        let checkOutISO = iso8601String(from: checkOutDate)
        
        viewModel.onPostBookingSuccess = { [weak self] response in
            guard let self = self else { return }
            self.hideLoader()
            checkInTF.text = ""
            checkOutTF.text = ""
            selectedCheckInDate =  nil
            selectedCheckOutDate = nil
            guard let confirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "BookingConfirmationVC") as? BookingConfirmationVC else { return }
            
            confirmationVC.guestName = response.guestName
            confirmationVC.guestEmail = response.guestEmail
            confirmationVC.guestPhone = response.guestPhone
            confirmationVC.checkInDate = response.checkIn
            confirmationVC.checkOutDate = response.checkOut
            confirmationVC.numberOfGuests = "\(response.numberOfGuests ?? 0)"
            confirmationVC.totalPrice = "\(response.totalAmount ?? 0.0)"
            confirmationVC.roomDetails = response.bookingDetails
            confirmationVC.selectedHotel = self.selectedHotel
            confirmationVC.selectedRoom = self.selectedRoom
            confirmationVC.selectedRates = self.selectedRates
            confirmationVC.bookingId = response.id
            
            // Dismiss current VC and replace root with BookingConfirmationVC
            self.dismiss(animated: true) {
                // Get root window
                if let window = UIApplication.shared.windows.first {
                    confirmationVC.modalPresentationStyle = .fullScreen
                    window.rootViewController = confirmationVC
                }
            }
        }
        
        viewModel.onError = { error in
            self.hideLoader()
            self.showAlert(error.description)
        }
        
        viewModel.SubmitBookingInfo(userId: user.id,hotelId: hotel.id,roomId: selectedRoom.room.id,guestName: guestName ?? "",guestPhone: guestMobileNumber,guestEmail: guestEmail ?? "",numberOfGuests: noOfGuest,checkIn: checkInISO,checkOut: checkOutISO,totalAmount: totalAmount,bookingDetails: roomRatesDataAPI, bookingType: bookingTypeLabel.text ?? "", totalDiscount: finaltotalDiscountAmount, netTotal: netAmountAfterDiscount)
        
    }
    
    @IBAction func increaseNoButtonAction(_ sender: Any) {
        let currentValue = Int(numberOfGuestsTF.text ?? "") ?? 0
        if currentValue < 10 {
            numberOfGuestsTF.text = String(currentValue + 1)
        }
    }
    
    @IBAction func decreaseNoButtonAction(_ sender: Any) {
        let currentValue = Int(numberOfGuestsTF.text ?? "") ?? 0
        if currentValue > 0 {
            numberOfGuestsTF.text = String(currentValue - 1)
        }
    }
    
    func setNextDateInCkechout(checkInDate:Date){
        if let tomorrow = Calendar.current.date(byAdding: .day, value: 0, to: checkInDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy" // You can change format as needed
            formatter.dateStyle = .medium
            let tomorrowDate = formatter.string(from: tomorrow)
            
            checkOutTF.text =  tomorrowDate
        }
    }
    
}

extension ConfirmYourBookingVC {
    
    func setUpUI() {
        backView.applyCardStyle()
        guestNameLabel.text = guestName
        guestEmailLabel.text = guestEmail
        guestMobileNumberTF.text = guestMobileNumber
        
        // --- Setup date format ---
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        if let checkIn = selectedCheckInDate {
            checkInTF.text = formatter.string(from: checkIn)
            if let checkOut = selectedCheckOutDate {
                checkOutTF.text = formatter.string(from: checkOut)
            }
        } else {
            let today = Date()
            selectedCheckInDate = today
            checkInTF.text = formatter.string(from: today)
            if let tomorrow = Calendar.current.date(byAdding: .day, value: 0, to: today) {
                selectedCheckOutDate = tomorrow
                checkOutTF.text = formatter.string(from: tomorrow)
            }
        }
        
        // --- Reset totals ---
        totalGrossAmount = 0.0
        totalNetAmount = 0.0
        totalDiscountAmount = 0.0
        roomRatesDataDisplay = ""
        roomRatesDataAPI = ""
        
        for rate in selectedRates where rate.isSelected {
            let qty = Double(rate.selectedQuantity)
            let discountPercent = rate.isLocal ? (rate.localDiscount ?? 0.0) : (rate.discount ?? 0.0)
            let price = rate.isLocal ? (rate.localPrice ?? 0.0) : rate.price
            let currency = rate.isLocal ? "SYP" : "$"
            
            let gross = price * qty
            let discountValue = gross * (discountPercent / 100.0)
            let net = gross - discountValue
            
            totalGrossAmount += gross
            totalDiscountAmount += discountValue
            
            let qtyInt = Int(qty)
            
            let displayLine = String(
                format: "Qty %d × %.2f %@ (−%.2f%%) = Gross %.2f %@, Discount %.2f %@, Net %.2f %@",
                qtyInt, price, currency, discountPercent, gross, currency, discountValue, currency, net, currency
            )
            
            let apiLine = String(
                format: "Rate Id(%@) : qty %d, price %.2f %@, discount %.2f%%, gross %.2f %@, discount %.2f %@, net %.2f %@",
                rate.id, qtyInt, price, currency, discountPercent, gross, currency, discountValue, currency, net, currency
            )
            
            if !roomRatesDataDisplay.isEmpty {
                roomRatesDataDisplay += "\r\n"
                roomRatesDataAPI += "\r\n"
            }
            
            roomRatesDataDisplay += displayLine
            roomRatesDataAPI += apiLine
        }
        
        
        // --- Update Labels ---
        if let firstSelected = selectedRates.first(where: { $0.isSelected }) {
            let currency = firstSelected.isLocal ? "SYP" : "$"
            bookingTypeLabel.text = firstSelected.isLocal ? "Local(SYP)" : "International($)"
        }
        
        selectedRoomAndRatesLabel.text = roomRatesDataDisplay
        setupDatePickerUI()
        Arabic()
        updateTotalAmountLabel(isLocal: selectedRoom?.rates.first?.isLocal ?? false)
    }
    
    
    
    func setupDatePickerUI() {
        datePickerContainerView = UIView()
        datePickerContainerView.backgroundColor = .systemBackground
        datePickerContainerView.layer.cornerRadius = 16
        datePickerContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        datePickerContainerView.layer.shadowColor = UIColor.black.cgColor
        datePickerContainerView.layer.shadowOpacity = 0.2
        datePickerContainerView.layer.shadowOffset = CGSize(width: 0, height: -2)
        datePickerContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        // ✅ Toolbar setup
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
        toolbar.setItems([cancelButton, flexSpace, doneButton], animated: false)
        
        // Date Picker setup
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        datePickerContainerView.addSubview(toolbar)
        datePickerContainerView.addSubview(datePicker)
        view.addSubview(datePickerContainerView)
        
        // Constraints
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: datePickerContainerView.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: datePickerContainerView.trailingAnchor),
            toolbar.topAnchor.constraint(equalTo: datePickerContainerView.topAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 44),
            
            datePicker.leadingAnchor.constraint(equalTo: datePickerContainerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerContainerView.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: 8),
            datePicker.bottomAnchor.constraint(equalTo: datePickerContainerView.bottomAnchor, constant: -16)
        ])
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                datePickerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                datePickerContainerView.widthAnchor.constraint(equalToConstant: 400),
                datePickerContainerView.heightAnchor.constraint(equalToConstant: 450)
            ])
        } else {
            NSLayoutConstraint.activate([
                datePickerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                datePickerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                datePickerContainerView.heightAnchor.constraint(equalToConstant: 450)
            ])
        }
        
        datePickerBottomConstraint = datePickerContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 450)
        datePickerBottomConstraint?.isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDatePicker))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func doneDatePicker() {
        let selectedDate = datePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let selectedDateString = formatter.string(from: selectedDate)
        
        switch currentDatePickerMode {
        case .checkIn:
            selectedCheckInDate = selectedDate
            checkInTF.text = selectedDateString
            
            setNextDateInCkechout(checkInDate: datePicker.date)
            
        case .checkOut:
            selectedCheckOutDate = selectedDate
            checkOutTF.text = selectedDateString
        }
        
        updateTotalAmountLabel(isLocal: selectedRoom?.rates[0].isLocal ?? false)
        dismissDatePicker()
    }
    
    @objc func cancelDatePicker() {
        dismissDatePicker()
    }
    
    
    func toggleDatePicker(for button: UIButton) {
        activeButton = button
        updateDatePickerLimits()
        datePickerBottomConstraint?.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissDatePicker() {
        datePickerBottomConstraint?.constant = 500
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        let selectedDateString = formatter.string(from: sender.date)
        
        print("Selected Date: \(selectedDateString)")
        
        switch currentDatePickerMode {
        case .checkIn:
            print("Setting Check-In Text Field")
            selectedCheckInDate = sender.date
            checkInTF.text = selectedDateString
            setNextDateInCkechout(checkInDate: sender.date)
        case .checkOut:
            print("Setting Check-Out Text Field")
            selectedCheckOutDate = sender.date
            checkOutTF.text = selectedDateString
            dismissDatePicker()
        }
        
        
        updateTotalAmountLabel(isLocal: selectedRoom?.rates[0].isLocal ?? false)
    }
    
    func updateDatePickerLimits() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        switch currentDatePickerMode {
        case .checkIn:
            datePicker.minimumDate = today
            datePicker.date = today
            
        case .checkOut:
            if let checkIn = selectedCheckInDate {
                if let nextDayBaseOnCheckin = Calendar.current.date(byAdding: .day, value: 0, to: checkIn) {
                    datePicker.minimumDate = nextDayBaseOnCheckin
                }
            } else {
                if let tomorrow = Calendar.current.date(byAdding: .day, value: 0, to: today) {
                    datePicker.minimumDate = tomorrow
                    datePicker.date = tomorrow
                }
            }
        }
    }
    
    
    func calculateNumberOfNights(checkIn: Date?, checkOut: Date?) -> Int {
        guard let checkIn = checkIn, let checkOut = checkOut else { return 0 }
        
        let calendar = Calendar.current
        let startOfCheckIn = calendar.startOfDay(for: checkIn)
        let startOfCheckOut = calendar.startOfDay(for: checkOut)
        
        let components = calendar.dateComponents([.day], from: startOfCheckIn, to: startOfCheckOut)
        let days = components.day ?? 0
        
        // If both dates are same → 1 night
        // If next day → 1 night
        // Otherwise → number of days difference
        let totalNights = max(days, 0) == 0 ? 1 : days
        return totalNights
    }
    
    func updateTotalAmountLabel(isLocal: Bool) {
        let nights = calculateNumberOfNights(checkIn: selectedCheckInDate, checkOut: selectedCheckOutDate)
        let currency = isLocal ? "SYP" : "$"
        bookingTypeLabel.text = isLocal ? "Local (SYP)" : "International ($)"
        
        // Number formatter for both currencies (with comma and 2 decimals)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.groupingSeparator = ","
        formatter.locale = Locale(identifier: "en_US")
        
        guard nights > 0 else {
            totalAmountLabel.text = "\(currency) \(formatter.string(from: NSNumber(value: totalGrossAmount)) ?? "0.00")"
            netTotalAmountLabel.text = "\(currency) \(formatter.string(from: NSNumber(value: totalNetAmount)) ?? "0.00")"
            return
        }
        
        totalNightsCountLabel.text = "\(nights)"
        finaltotalDiscountAmount = totalDiscountAmount * Double(nights)
        totalAmount = totalGrossAmount * Double(nights)
        netAmountAfterDiscount = Double(totalAmount) - Double(finaltotalDiscountAmount)
        
        totalAmountLabel.text = "\(currency) \(formatter.string(from: NSNumber(value: totalAmount)) ?? "0.00")"
        totalDiscountAmountLabel.text = "\(currency) \(formatter.string(from: NSNumber(value: finaltotalDiscountAmount)) ?? "0.00")"
        netTotalAmountLabel.text = "\(currency) \(formatter.string(from: NSNumber(value: netAmountAfterDiscount)) ?? "0.00")"
    }
    
    
    @objc func Arabic() {
        if AppSettings.shared.selectedLanguage == .english {
            confirmYourBookingTitleLabel.text = "Confirm Your Booking"
            guestNameTitleLabel.text = "Guest Name"
            guestEmailTitleLabel.text = "Guest Email"
            guestPhoneTitleLabel.text = "Guest Phone"
            checkOutTitleLabel.text = "Check-Out"
            checkInTitleLabel.text = "Check-In"
            numberOfGuestsTitleLabel.text = "Number of Guests"
            selectedRoomsAndRatesLabel.text = "Selected Rooms & Rate"
            totalAmountTitleLabel.text = "Total Amount"
            submitBookingButton.setTitle("Submit Booking", for: .normal)
        } else {
            confirmYourBookingTitleLabel.text = "تأكيد الحجز"
            guestNameTitleLabel.text = "اسم الضيف"
            guestEmailTitleLabel.text = "بريد الضيف الإلكتروني"
            guestPhoneTitleLabel.text = "هاتف الضيف"
            checkOutTitleLabel.text = "تسجيل الخروج"
            checkInTitleLabel.text = "تسجيل الوصول"
            numberOfGuestsTitleLabel.text = "عدد الضيوف"
            selectedRoomsAndRatesLabel.text = "الغرف والأسعار المحددة"
            totalAmountTitleLabel.text = "المبلغ الإجمالي"
            submitBookingButton.setTitle("إرسال الحجز", for: .normal)
        }
    }
}

extension ConfirmYourBookingVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Check if the touch is inside the date picker container view
        let location = touch.location(in: datePickerContainerView)
        let isTouchInDatePicker = datePickerContainerView.bounds.contains(location)
        return !isTouchInDatePicker
    }
}

