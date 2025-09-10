

import UIKit

class VerificationVC : UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet var otpTF: [UITextField]!
    @IBOutlet weak var verifyAndContinueButton: UIButton!
    
    var mobileNumber: String?
    var guestName: String?
    var guestEmail: String?

    var selectedHotel: Hotel?
    var selectedRoom: RoomElement?
    var selectedRate: Rate?
    
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
        
        if otp != "123456" { 
            showAlert("Invalid OTP. Please try again.")
            return
        }
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "ConfirmYourBookingVC") as! ConfirmYourBookingVC
        controller.guestName = guestName
        controller.guestEmail = guestEmail
        controller.guestMobileNumber = mobileNumber
        controller.selectedHotel = selectedHotel
        controller.selectedRoom = selectedRoom
        controller.selectedRate = selectedRate
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
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
        
        for (index, textField) in otpTF.enumerated() {
            textField.delegate = self
            textField.keyboardType = .numberPad
            textField.textAlignment = .center
            textField.tag = index
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
}
