

import UIKit

enum comingFromLoginSuccess {
    case Home
    case BookingHistory
    case HotelDetail
    
}

class VerificationVC : UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet var otpTF: [UITextField]!
    @IBOutlet weak var verifyAndContinueButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    var mobileNumber: String?
    var guestName: String?
    var guestEmail: String?

    var selectedHotel: Hotel?
    var selectedRoom: RoomElement?
    var selectedRate: Rate?
    var OptResponse : OTPResponseModel?
    var viewModel = BookingViewModel()
    
    var comingFrom : comingFromLoginSuccess?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        otpTF.first?.becomeFirstResponder()
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func verifyAndContinueButtonAction(_ sender: Any) {
       
        let otp = otpTF.compactMap { $0.text?.trimmingCharacters(in: .whitespaces) }.joined()

        guard !otp.isEmpty else {
            showAlert("Please enter the OTP.")
            return
        }
        
        guard let mobileNumber = mobileNumber else {
            return
        }
        
       
        self.verifyOTPCode(mobile: mobileNumber, otp: otp) { [weak self] UserId in
            
            guard let UserId = UserId else { return }
            
            self?.viewModel.onSuccess = { response in
               
                UserSessionManager.saveUser(response)
            }
            
            self?.viewModel.onError = { error in
                self?.showAlert(error.description)
            }
            
            self?.viewModel.FetchUserData(id: UserId.data.userId)

            //write code based on from which page user come here like HomePage, bookingPage, bookinghistory page
            
//            guard let comingFrom = self?.comingFrom else { return }
            
            switch self?.comingFrom {
                
            case .Home:
                //Reload HomePage
                self?.dismiss(animated: true)
                self?.dismissPopup()
            case .BookingHistory:
                    //Reload BookingHistory
                self?.dismiss(animated: true)
                self?.dismissPopup()
            case .HotelDetail:
                //Move to confirm page
                let controller = self?.storyboard?.instantiateViewController(withIdentifier: "ConfirmYourBookingVC") as! ConfirmYourBookingVC
                controller.guestName = self?.guestName
                controller.guestEmail = self?.guestEmail
                controller.guestMobileNumber = mobileNumber
                controller.selectedHotel = self?.selectedHotel
                controller.selectedRoom = self?.selectedRoom
                controller.selectedRate = self?.selectedRate
                controller.modalPresentationStyle = .fullScreen
                self?.present(controller, animated: true)
            case .none:
                self?.dismissPopup()
                self?.dismiss(animated: true)
            }
        }
    }
    
   
    
    func verifyOTPCode(mobile:String,otp:String,completion: @escaping (VerifyOTPModel?) -> Void) {
        showLoader()
        viewModel.onVerifyOTPSucess = { response in
            self.hideLoader()
           completion(response)
        }
        
        viewModel.onError = { error in
            self.hideLoader()
            self.showAlert(error.description)
        }
        
        viewModel.verifyOTP(mobile: mobile, otp: otp)
        
    }
    
}

extension VerificationVC : UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }

        if text.count >= 1 {
            textField.text = String(text.prefix(1))
            if textField.tag < otpTF.count - 1 {
                otpTF[textField.tag + 1].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty {
            if let currentText = textField.text, !currentText.isEmpty {
                textField.text = ""
                if textField.tag > 0 {
                    otpTF[textField.tag - 1].becomeFirstResponder()
                }
                return false
            } else {
                if textField.tag > 0 {
                    otpTF[textField.tag - 1].becomeFirstResponder()
                }
                return false
            }
        }

        return (textField.text?.count ?? 0) < 1
    }
}

extension VerificationVC {
    func setUpUI() {
        mobileNumberTF.text = mobileNumber
        
        messageLabel.text = "Dear \(guestName ?? "User"), your mobile is registered. An OTP has been sent to \(OptResponse?.data.to ?? "your email"). Please enter it below to continue."
        
        for (index, textField) in otpTF.enumerated() {
            textField.delegate = self
            textField.keyboardType = .numberPad
            textField.textAlignment = .center
            textField.tag = index
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
}
