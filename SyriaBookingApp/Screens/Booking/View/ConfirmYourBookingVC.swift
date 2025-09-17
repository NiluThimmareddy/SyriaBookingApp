
import UIKit

class ConfirmYourBookingVC : UIViewController {

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
    
    
    var guestName: String?
    var guestEmail: String?
    var guestMobileNumber: String?
    
    var datePickerContainerView: UIView!
    var datePicker: UIDatePicker!
    var activeButton: UIButton?
    var currentDatePickerMode: DatePickerMode = .checkIn
    var selectedCheckInDate: Date?
    var isDatePickerShown = false
    var formattedTotal = ""
    var total : Double = 0.0
    var selectedHotel: Hotel?
    var selectedRoom: RoomElement?
    var selectedRate = [Rate]()
    var  viewModel = BookingViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
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
        guard let checkIn = checkInTF.text, !checkIn.isEmpty else {
            showAlert("Please enter a Check Out.")
            return
        }
        
        guard let checkout = checkOutTF.text, !checkout.isEmpty else {
            showAlert("Please enter a Check Out.")
            return
        }
        
        guard let guestMobileNumber = guestMobileNumber else {
            showAlert("Please enter a mobile number.")
            return
        }
        
        guard let user = UserSessionManager.getUser() else { return }
        guard let hotel = selectedHotel else {
            print("No room selected")
            return
        }
        guard let selectedRoom = selectedRoom else {
            print("No room selected")
            return
        }
        showLoader()
        viewModel.onPostBookingSuccess = { [weak self] response in
            
            guard let self = self else { return }
            hideLoader()
            let confirmationVC = storyboard?.instantiateViewController(withIdentifier: "BookingConfirmationVC") as! BookingConfirmationVC
           
            confirmationVC.guestName = response.guestName
            confirmationVC.guestEmail = response.guestEmail
            confirmationVC.guestPhone = response.guestPhone
//            confirmationVC.checkInDate = response.checkIn
//            confirmationVC.checkOutDate = response.checkOut
//            confirmationVC.numberOfGuests = "\(response.numberOfGuests)"
//            confirmationVC.totalPrice = "\(response.totalAmount)"
//            confirmationVC.roomType = selectedRoomAndRatesLabel.text
//            
//            confirmationVC.selectedHotel = selectedHotel
//            confirmationVC.selectedRoom = selectedRoom
//            confirmationVC.selectedRate = selectedRate
            present(confirmationVC, animated: true)
            
        }
        
        viewModel.onError = { error in
            self.hideLoader()
            self.showAlert(error.description)
        }
        
        
        viewModel.SubmitBookingInfo(userId: user.id, hotelId: hotel.id, roomId: selectedRoom.room.id, guestName: guestName ?? "", guestPhone: guestMobileNumber, guestEmail: guestEmail ?? "", numberOfGuests: noOfGuest, checkIn: checkIn, checkOut: checkout, totalAmount: total, bookingDetails: selectedRoomAndRatesLabel.text ?? "")
        
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
        formatter.dateStyle = .medium
        let todayDate = formatter.string(from: Date())
        checkInTF.text = todayDate
        
        var roomRatesData = ""
       
        for i in selectedRate {
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
        
    }
    
    func setupDatePickerUI() {
        datePickerContainerView = UIView()
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
       
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        updateDatePickerLimits()
        datePickerContainerView.backgroundColor = .systemBackground
        datePickerContainerView.layer.cornerRadius = 8
        datePickerContainerView.layer.borderWidth = 1
        datePickerContainerView.layer.borderColor = UIColor.lightGray.cgColor
        datePickerContainerView.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePickerContainerView.addSubview(datePicker)
        view.addSubview(datePickerContainerView)
        
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: datePickerContainerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerContainerView.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: datePickerContainerView.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: datePickerContainerView.bottomAnchor),
            
            datePickerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePickerContainerView.widthAnchor.constraint(equalToConstant: 320),
            datePickerContainerView.heightAnchor.constraint(equalToConstant: 360)
        ])
        
        datePickerContainerView.isHidden = true
    }
    
    func toggleDatePicker(for button: UIButton) {
        activeButton = button
        
        if button.superview != nil {
            let buttonFrame = button.convert(button.bounds, to: view)
            let topAnchor = datePickerContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: buttonFrame.maxY + 8)
            NSLayoutConstraint.deactivate(datePickerContainerView.constraints)
            NSLayoutConstraint.activate([
                datePicker.leadingAnchor.constraint(equalTo: datePickerContainerView.leadingAnchor),
                datePicker.trailingAnchor.constraint(equalTo: datePickerContainerView.trailingAnchor),
                datePicker.topAnchor.constraint(equalTo: datePickerContainerView.topAnchor),
                datePicker.bottomAnchor.constraint(equalTo: datePickerContainerView.bottomAnchor),
                datePickerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                topAnchor,
                datePickerContainerView.widthAnchor.constraint(equalToConstant: 320),
                datePickerContainerView.heightAnchor.constraint(equalToConstant: 360)
            ])
        }
        datePickerContainerView.isHidden.toggle()
    }
    
    func updateDatePickerLimits() {
        let now = Date()
        switch currentDatePickerMode {
        case .checkIn:
           
            datePicker.minimumDate = now
            datePicker.date = now

        case .checkOut:
            guard let checkIn = selectedCheckInDate else {
               
                datePicker.minimumDate = now
                datePicker.date = now
                return
            }
            datePicker.minimumDate = checkIn
            datePicker.date = checkIn
        }
    }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let selectedDate = formatter.string(from: sender.date)
        switch currentDatePickerMode {
        case .checkIn:
            selectedCheckInDate = sender.date
            checkInTF.text = selectedDate
            checkOutTF.text = ""
        case .checkOut:
            checkOutTF.text = selectedDate
        }
        datePickerContainerView.isHidden = true
    }
}
