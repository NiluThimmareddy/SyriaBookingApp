
import UIKit

class ConfirmYourBookingVC : UIViewController, UITextFieldDelegate {
    
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
    var total : Double = 0.0
    var selectedHotel: Hotel?
    var selectedRoom: RoomElement?
    //    var selectedRate = [Rate]()
    var selectedRates: [Rate] = []
    var viewModel = BookingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        hideKeyboardWhenTappedAround()
        numberOfGuestsTF.delegate = self
        checkInTF.delegate = self
        checkOutTF.delegate = self
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
        
        viewModel.SubmitBookingInfo(userId: user.id,hotelId: hotel.id,roomId: selectedRoom.room.id,guestName: guestName ?? "",guestPhone: guestMobileNumber,guestEmail: guestEmail ?? "",numberOfGuests: noOfGuest,checkIn: checkInISO,checkOut: checkOutISO,totalAmount: total,bookingDetails: selectedRoomAndRatesLabel.text ?? ""
        )
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
    
}

extension ConfirmYourBookingVC {
    func setUpUI() {
        backView.applyCardStyle()
        guestNameLabel.text = guestName
        guestEmailLabel.text = guestEmail
        guestMobileNumberTF.text = guestMobileNumber
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        let selectedCheckin = selectedCheckInDate.map { formatter.string(from: $0) } ?? "Not Selected"
        let selectedCheckout = selectedCheckOutDate.map { formatter.string(from: $0) } ?? "Not Selected"
        
        
        
        checkInTF.text = selectedCheckin
        checkOutTF.text = selectedCheckout
        var roomRatesData = ""
        total = 0.0
        for i in selectedRates {
            if i.isSelected == true {
                let price = i.price
                let quantity = i.selectedQuantity
                let guestNotes = i.notes ?? "Details Unavailable"
                
                let lineTotal = Double(price) * Double(quantity)
                let formattedLineTotal = String(format: "$%.2f", lineTotal)
                total += lineTotal
                roomRatesData += "\n $\(price): \(guestNotes) Qty \(quantity) - Total \(formattedLineTotal)"
            }
        }
        
        formattedTotal = String(format: "$%.2f", total)
        selectedRoomAndRatesLabel.text = roomRatesData
        totalAmountLabel.text = formattedTotal
        setupDatePickerUI()
        
        increaseNoButton.layer.cornerRadius = 10
        increaseNoButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        increaseNoButton.clipsToBounds = true
        decreaseNoButton.layer.cornerRadius = 10
        decreaseNoButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        decreaseNoButton.clipsToBounds = true
        bottomView.layer.cornerRadius = 10
        bottomView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        bottomView.clipsToBounds = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(Arabic),
            name: .languageChanged,
            object: nil
        )
        Arabic()
        updateTotalAmountLabel()
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

        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        datePickerContainerView.addSubview(datePicker)
        view.addSubview(datePickerContainerView)

        // Constraints - Different for iPhone and iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad - Fixed width and centered
            NSLayoutConstraint.activate([
                datePicker.leadingAnchor.constraint(equalTo: datePickerContainerView.leadingAnchor),
                datePicker.trailingAnchor.constraint(equalTo: datePickerContainerView.trailingAnchor),
                datePicker.topAnchor.constraint(equalTo: datePickerContainerView.topAnchor, constant: 16),
                datePicker.bottomAnchor.constraint(equalTo: datePickerContainerView.bottomAnchor, constant: -16),

                datePickerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                datePickerContainerView.widthAnchor.constraint(equalToConstant: 400),
                datePickerContainerView.heightAnchor.constraint(equalToConstant: 400)
            ])
        } else {
            // iPhone - Full width
            NSLayoutConstraint.activate([
                datePicker.leadingAnchor.constraint(equalTo: datePickerContainerView.leadingAnchor),
                datePicker.trailingAnchor.constraint(equalTo: datePickerContainerView.trailingAnchor),
                datePicker.topAnchor.constraint(equalTo: datePickerContainerView.topAnchor, constant: 16),
                datePicker.bottomAnchor.constraint(equalTo: datePickerContainerView.bottomAnchor, constant: -16),

                datePickerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                datePickerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                datePickerContainerView.heightAnchor.constraint(equalToConstant: 400)
            ])
        }

        datePickerBottomConstraint = datePickerContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 400)
        datePickerBottomConstraint?.isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDatePicker))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
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
        datePickerBottomConstraint?.constant = 400
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
            checkOutTF.text = ""
            selectedCheckOutDate = nil
        case .checkOut:
            print("Setting Check-Out Text Field")
            selectedCheckOutDate = sender.date
            checkOutTF.text = selectedDateString
        }
        
        dismissDatePicker()
        updateTotalAmountLabel()
    }
    
    func updateDatePickerLimits() {
        guard let today = Calendar.current.date(byAdding: .day, value: 0, to: Date()) else {
            return
        }
        switch currentDatePickerMode {
        case .checkIn:
            datePicker.minimumDate = today
            if let checkInDate = selectedCheckInDate {
                datePicker.date = checkInDate
            } else {
                datePicker.date = today
                selectedCheckInDate = today
            }
        case .checkOut:
            if let checkIn = selectedCheckInDate {
                guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) else {
                    return
                }
                datePicker.minimumDate = tomorrow
                datePicker.date = tomorrow
                selectedCheckOutDate = datePicker.date
            }
        }
    }
    
    func calculateNumberOfNights(checkIn: Date?, checkOut: Date?) -> Int {
        guard let checkIn = checkIn, let checkOut = checkOut else { return 0 }
        let components = Calendar.current.dateComponents([.day], from: checkIn, to: checkOut)
        return components.day ?? 0
    }
    
    func updateTotalAmountLabel() {
        let nights = calculateNumberOfNights(checkIn: selectedCheckInDate, checkOut: selectedCheckOutDate)
        guard nights > 0 else {
            totalAmountLabel.text = formattedTotal // if no valid nights selected
            return
        }

        // Calculate per-night total (existing roomRates total × number of nights)
        let perNightTotal = total
        let totalForStay = perNightTotal * Double(nights)
        let formatted = String(format: "$%.2f", totalForStay)
        totalAmountLabel.text = formatted
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

