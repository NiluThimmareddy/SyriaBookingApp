
import UIKit

class BookingConfirmationVC : UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var confirmationMessageTextView: UITextView!
    @IBOutlet weak var viewBookingConfirmationButton: UIButton!
    @IBOutlet weak var bookingConfirmationTitleLabel: UILabel!
    @IBOutlet weak var bookingQueueTitleLabel: UILabel!
    
    
    var guestName: String?
    var guestEmail: String?
    var guestPhone: String?
    var checkInDate: String?
    var checkOutDate: String?
    var numberOfGuests: String?
    var totalPrice: String?
    var roomDetails : String?
    var selectedHotel: Hotel?
    var selectedRoom: RoomElement?
//    var selectedRate = [Rate]()
    var selectedRates: [Rate] = []
    var bookingId : String?
    var roomtype : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfirmationMessage()
        setUpLanguage()
    }
    
    private func setupConfirmationMessage() {
        guard let name = guestName else { return }

        let fullText: String
        if AppSettings.shared.selectedLanguage == .english {
            fullText = """
            Thanks, \(name)! We've received your booking request and placed it in our processing queue.
            We'll finalize your booking shortly and it will appear in your booking list.
            You can check your bookings in My Bookings
            """
        } else {
            fullText = """
            شكرًا، \(name)! لقد تلقينا طلب الحجز الخاص بك ووضعناه في قائمة المعالجة.
            سنقوم بتأكيد حجزك قريبًا وسيظهر في قائمة حجوزاتك.
            يمكنك مراجعة حجوزاتك في حجوزاتي
            """
        }

        let attributedString = NSMutableAttributedString(string: fullText)

        let nameRange = (fullText as NSString).range(of: name)
        if nameRange.location != NSNotFound {
            attributedString.addAttributes([
                .font: UIFont.boldSystemFont(ofSize: 15),
                .foregroundColor: UIColor.black
            ], range: nameRange)
        }

        let bookingsRange = (fullText as NSString).range(of: AppSettings.shared.selectedLanguage == .english ? "My Bookings" : "حجوزاتي")
        if bookingsRange.location != NSNotFound {
            attributedString.addAttributes([
                .link: "mybookings://open"
            ], range: bookingsRange)
        }

        confirmationMessageTextView.attributedText = attributedString
        confirmationMessageTextView.isEditable = false
        confirmationMessageTextView.isScrollEnabled = false
        confirmationMessageTextView.dataDetectorTypes = []
        confirmationMessageTextView.delegate = self

        confirmationMessageTextView.linkTextAttributes = [
            .foregroundColor: UIColor.systemGreen,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "mybookings://open" {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            if let tabBarController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarController") as? UITabBarController {
                
                tabBarController.selectedIndex = 1 

                if let nav = tabBarController.viewControllers?[1] as? UINavigationController,
                   let myBookingsVC = nav.topViewController as? MyBookingsViewController {

                    myBookingsVC.guestName = guestName
                    myBookingsVC.guestEmail = guestEmail
                    myBookingsVC.guestPhone = guestPhone
                    myBookingsVC.checkInDate = checkInDate
                    myBookingsVC.checkOutDate = checkOutDate
                    myBookingsVC.numberOfGuests = numberOfGuests
                    myBookingsVC.totalPrice = totalPrice
                    myBookingsVC.selectedHotel = selectedHotel
                    myBookingsVC.selectedRoom = selectedRoom
                    myBookingsVC.selectedRates = selectedRates
                }

                tabBarController.modalPresentationStyle = .fullScreen
                present(tabBarController, animated: true, completion: nil)
            }
            return false
        }
        return true
    }

    @objc func setUpLanguage() {
        if AppSettings.shared.selectedLanguage == .english {
            bookingConfirmationTitleLabel.text = "Booking Confirmation"
            bookingQueueTitleLabel.text = "⏳ Booking Request Queued"
        } else {
            bookingConfirmationTitleLabel.text = "تأكيد الحجز"
            bookingQueueTitleLabel.text = "⏳ تم وضع طلب الحجز في القائمة"
        }
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func viewBookingConfirmationButtonAction(_ sender: Any) {
        guard let viewBookingConfirmationVC = storyboard?.instantiateViewController(withIdentifier: "ViewBookingConfirmationVC") as? ViewBookingConfirmationVC else {
            return
        }

        viewBookingConfirmationVC.isFromMyBookings = false
        viewBookingConfirmationVC.hotelID = selectedHotel?.id ?? ""
        viewBookingConfirmationVC.bookingId = bookingId ?? ""
        viewBookingConfirmationVC.roomType = roomtype ?? ""
        viewBookingConfirmationVC.modalPresentationStyle = .fullScreen
        present(viewBookingConfirmationVC, animated: true)
    }
}


