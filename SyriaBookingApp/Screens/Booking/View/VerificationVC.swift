
import UIKit

class VerificationVC : UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var otpTF: UITextField!
    @IBOutlet weak var verifyAndContinueButton: UIButton!
    
    var mobileNumber: String?
    var guestName: String?
    var guestEmail: String?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        mobileNumberTF.text = mobileNumber
       
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func verifyAndContinueButtonAction(_ sender: Any) {
        guard let otp = otpTF.text, !otp.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert("Please enter the OTP.")
            return
        }
        
        if otp != "1234" {
            showAlert("Invalid OTP. Please try again.")
            return
        }
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "ConfirmYourBookingVC") as! ConfirmYourBookingVC
        controller.guestName = guestName
        controller.guestEmail = guestEmail
        controller.guestMobileNumber = mobileNumber
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
}
