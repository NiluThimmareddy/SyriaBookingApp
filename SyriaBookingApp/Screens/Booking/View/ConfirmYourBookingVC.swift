
import UIKit

class ConfirmYourBookingVC : UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var guestNameLabel: UILabel!
    @IBOutlet weak var guestEmailLabel: UILabel!
    @IBOutlet weak var guestMobileNumberLabel: UILabel!
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
    
    var guestName: String?
    var guestEmail: String?
    var guestMobileNumber: String?
    
    var datePickerContainerView: UIView!
    var datePicker: UIDatePicker!
    var activeButton: UIButton?
    var currentDatePickerMode: DatePickerMode = .checkIn
    var selectedCheckInDate: Date?
    var isDatePickerShown = false
    
    var selectedHotel: Hotel?
    var selectedRoom: RoomElement?
    var selectedRate: Rate?
   
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
        let confirmationVC = storyboard?.instantiateViewController(withIdentifier: "BookingConfirmationVC") as! BookingConfirmationVC
        confirmationVC.guestName = guestName
        confirmationVC.guestEmail = guestEmail
        confirmationVC.guestPhone = guestMobileNumber
        confirmationVC.checkInDate = checkInTF.text
        confirmationVC.checkOutDate = checkOutTF.text
        confirmationVC.numberOfGuests = numberOfGuestsTF.text
        confirmationVC.totalPrice = totalAmountLabel.text
        confirmationVC.roomType = selectedRoomAndRatesLabel.text
        
        confirmationVC.selectedHotel = selectedHotel
        confirmationVC.selectedRoom = selectedRoom
        confirmationVC.selectedRate = selectedRate
        present(confirmationVC, animated: true)
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
        guestNameLabel.text = guestName
        guestEmailLabel.text = guestEmail
        guestMobileNumberLabel.text = guestMobileNumber
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let todayDate = formatter.string(from: Date())
        checkInTF.text = todayDate
        
        if let selectedRoom = selectedRoom, let selectedRate = selectedRate {
            let price = selectedRate.price
            let quantity = selectedRate.selectedQuantity
            let guestNotes = selectedRate.notes ?? "Details Unavailable"            
            let total = Double(price * quantity)
            let formattedTotal = String(format: "$%.2f", total)
            selectedRoomAndRatesLabel.text = "$\(price): \(guestNotes) Qty \(quantity) - Total \(formattedTotal)"
            totalAmountLabel.text = formattedTotal
        } else {
            selectedRoomAndRatesLabel.text = "N/A"
            totalAmountLabel.text = "N/A"
        }
        
        setupDatePickerUI()
        
        increaseNoButton.layer.cornerRadius = 10
        increaseNoButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        increaseNoButton.clipsToBounds = true
        
        decreaseNoButton.layer.cornerRadius = 10
        decreaseNoButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        decreaseNoButton.clipsToBounds = true
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
