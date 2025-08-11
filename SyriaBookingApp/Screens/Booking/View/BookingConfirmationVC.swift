
import UIKit

class BookingConfirmationVC : UIViewController {

    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var confirmationMessageTextView: UITextView!
    @IBOutlet weak var viewBookingConfirmationButton: UIButton!
    
    var guestName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = guestName {
            confirmationMessageTextView.text = """
                   Dear \(name),
                   Thank you for choosing to book with us. Your reservation has been successfully completed.
                   We're delighted to have you as our guest and look forward to providing you with a comfortable and memorable stay.
                   You can now view and print your booking confirmation by clicking the button below.
                   """
        }
    }

    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func viewBookingConfirmationButtonAction(_ sender: Any) {
    }
    
    
}
