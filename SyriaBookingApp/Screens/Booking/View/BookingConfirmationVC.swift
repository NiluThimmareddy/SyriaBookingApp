
import UIKit

class BookingConfirmationVC : UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var confirmationMessageTextView: UITextView!
    @IBOutlet weak var viewBookingConfirmationButton: UIButton!
    
    var guestName: String?
    var guestEmail: String?
    var guestPhone: String?
    var checkInDate: String?
    var checkOutDate: String?
    var numberOfGuests: String?
    var totalPrice: String?
    var roomType: String?
    
    var selectedHotel: Hotel?
    var selectedRoom: RoomElement?
    var selectedRate = [Rate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfirmationMessage()
    }
    
    private func setupConfirmationMessage() {
        guard let name = guestName else { return }
        
        let fullText = """
        Thanks, \(name)! We've received your booking request and placed it in our processing queue.
        We'll finalize your booking shortly and it will appear in your booking list.
        You can check your bookings in My Bookings
        """
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let nameRange = (fullText as NSString).range(of: name)
        if nameRange.location != NSNotFound {
            attributedString.addAttributes([
                .font: UIFont.boldSystemFont(ofSize: 15),
                .foregroundColor: UIColor.black
            ], range: nameRange)
        }

        let bookingsRange = (fullText as NSString).range(of: "My Bookings")
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
                    myBookingsVC.selectedRate = selectedRate
                }

                tabBarController.modalPresentationStyle = .fullScreen
                present(tabBarController, animated: true, completion: nil)
            }
            return false
        }
        return true
    }

    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func viewBookingConfirmationButtonAction(_ sender: Any) {
        guard let viewBookingConfirmationVC = storyboard?.instantiateViewController(withIdentifier: "ViewBookingConfirmationVC") as? ViewBookingConfirmationVC else {
            return
        }
        
        viewBookingConfirmationVC.selectedHotel = selectedHotel
        viewBookingConfirmationVC.selectedRoom = selectedRoom
        viewBookingConfirmationVC.selectedRate = selectedRate
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        viewBookingConfirmationVC.bookingDate = formatter.string(from: Date())
        
        viewBookingConfirmationVC.totalNights = calculateTotalNights(checkIn: checkInDate, checkOut: checkOutDate)
        viewBookingConfirmationVC.checkInDate = checkInDate
        viewBookingConfirmationVC.checkOutDate = checkOutDate
        viewBookingConfirmationVC.guestName = guestName
        viewBookingConfirmationVC.guestEmail = guestEmail
        viewBookingConfirmationVC.guestPhone = guestPhone
        viewBookingConfirmationVC.numberOfGuests = numberOfGuests
        viewBookingConfirmationVC.totalPrice = totalPrice
        viewBookingConfirmationVC.modalPresentationStyle = .fullScreen
        present(viewBookingConfirmationVC, animated: true)
    }
    
    func calculateTotalNights(checkIn: String?, checkOut: String?) -> Int {
        guard let checkIn = checkIn, let checkOut = checkOut else { return 0 }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        guard let inDate = formatter.date(from: checkIn),
              let outDate = formatter.date(from: checkOut) else { return 0 }
        return Calendar.current.dateComponents([.day], from: inDate, to: outDate).day ?? 0
    }
}

