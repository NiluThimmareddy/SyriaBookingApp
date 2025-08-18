
import UIKit

class BookingConfirmationVC : UIViewController {

    
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
    var selectedRate: Rate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = guestName {
            let message = """
            Dear \(name),
            Thank you for choosing to book with us. Your reservation has been successfully completed.
            We're delighted to have you as our guest and look forward to providing you with a comfortable and memorable stay.
            You can now view and print your booking confirmation by clicking the button below.
            """

            confirmationMessageTextView.setHighlightedText(
                fullText: message,
                highlightText: name,
                normalFont: .systemFont(ofSize: 14),
                highlightFont: .boldSystemFont(ofSize: 15),
                normalColor: .black,
                highlightColor: .black
            )
        }
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
