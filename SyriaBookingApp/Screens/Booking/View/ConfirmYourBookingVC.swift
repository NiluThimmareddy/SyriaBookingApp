
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
    
    var guestName: String?
    var guestEmail: String?
    var guestMobileNumber: String?
    
    var datePickerContainerView: UIView!
    var datePicker: UIDatePicker!
    var activeButton: UIButton?
    var currentDatePickerMode: DatePickerMode = .checkIn
    var selectedCheckInDate: Date?
    var isDatePickerShown = false
   
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
        let storyboard = storyboard?.instantiateViewController(withIdentifier: "BookingConfirmationVC") as! BookingConfirmationVC
        storyboard.guestName = guestName
        present(storyboard, animated: true)
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
        
        setupDatePickerUI()
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
