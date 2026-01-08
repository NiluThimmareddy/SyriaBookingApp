//
//  BookingPoliciesVC.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 08/01/26.
//

import UIKit

class BookingPoliciesVC: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var bookingPolicieTitleLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var policieTextView: UITextView!
    @IBOutlet weak var checkMarkButton: UIButton!
    @IBOutlet weak var readAndAgreeLabel: UILabel!
    @IBOutlet weak var acceptTermsAndConditionsLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var acceptTermsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var acceptTermsbottomConstraint: NSLayoutConstraint!
    
    private var isCheckboxSelected = false
    private var originalAcceptTermsTopConstraint: CGFloat = 20
    private var originalAcceptTermsBottomConstraint: CGFloat = 20
    
    var guestName: String?
    var guestEmail: String?
    var guestMobileNumber: String?
    var selectedHotel: Hotel?
    var selectedRoom: RoomElement?
    var selectedRates: [Rate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        acceptTermsTopConstraint.constant = 0
        acceptTermsbottomConstraint.constant = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustTextViewHeight()
    }
    
    private func setupUI() {
        formatPoliciesText()
        acceptTermsAndConditionsLabel.isHidden = true
        originalAcceptTermsTopConstraint = acceptTermsTopConstraint.constant
        originalAcceptTermsBottomConstraint = acceptTermsbottomConstraint.constant
        acceptTermsTopConstraint.constant = 0
        acceptTermsbottomConstraint.constant = 0
        
        let graySquareImage = UIImage(systemName: "square")?.withRenderingMode(.alwaysTemplate)
        checkMarkButton.setImage(graySquareImage, for: .normal)
        checkMarkButton.tintColor = .gray
        
        acceptTermsAndConditionsLabel.textColor = .red
        acceptTermsAndConditionsLabel.text = "Please accept the Terms & Conditions to continue."
        acceptTermsAndConditionsLabel.numberOfLines = 0
        acceptTermsAndConditionsLabel.lineBreakMode = .byWordWrapping
        
        policieTextView.font = UIFont.systemFont(ofSize: 16)
        policieTextView.textColor = .label
        policieTextView.textContainer.lineFragmentPadding = 0
        policieTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        policieTextView.isScrollEnabled = false
        policieTextView.isEditable = false
    }
    
    private func formatPoliciesText() {
        guard let policies = selectedHotel?.policies, !policies.isEmpty else {
            policieTextView.text = "No policies available"
            return
        }
        let policyItems = policies.components(separatedBy: ",")
        let trimmedItems = policyItems.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        let formattedPolicies = trimmedItems.map { "• \($0)" }.joined(separator: "\n\n")
        policieTextView.text = formattedPolicies
    }
    
    private func adjustTextViewHeight() {
        let fixedWidth = policieTextView.frame.size.width
        let newSize = policieTextView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        textViewHeightConstraint.constant = newSize.height
        
        self.view.layoutIfNeeded()
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkMarkButtonAction(_ sender: Any) {
        isCheckboxSelected.toggle()
        
        if isCheckboxSelected {
            let blueCheckmarkImage = UIImage(systemName: "checkmark.square.fill")?.withRenderingMode(.alwaysTemplate)
            checkMarkButton.setImage(blueCheckmarkImage, for: .normal)
            checkMarkButton.tintColor = .systemBlue
            acceptTermsAndConditionsLabel.isHidden = true
            acceptTermsTopConstraint.constant = 0
            acceptTermsbottomConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            let graySquareImage = UIImage(systemName: "square")?.withRenderingMode(.alwaysTemplate)
            checkMarkButton.setImage(graySquareImage, for: .normal)
            checkMarkButton.tintColor = .gray
            acceptTermsAndConditionsLabel.isHidden = false
            acceptTermsTopConstraint.constant = originalAcceptTermsTopConstraint
            acceptTermsbottomConstraint.constant = originalAcceptTermsBottomConstraint
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func closeButtonaction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        if !isCheckboxSelected {
            acceptTermsAndConditionsLabel.isHidden = false
            acceptTermsAndConditionsLabel.text = "Please accept the Terms & Conditions to continue."
            
            acceptTermsTopConstraint.constant = originalAcceptTermsTopConstraint
            acceptTermsbottomConstraint.constant = originalAcceptTermsBottomConstraint
            
            UIView.animate(withDuration: 0.3) {
                self.acceptTermsAndConditionsLabel.alpha = 1.0
                self.view.layoutIfNeeded()
            }
            highlightCheckbox()
            
        } else {
            acceptTermsAndConditionsLabel.isHidden = true
            acceptTermsTopConstraint.constant = 0
            acceptTermsbottomConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            navigateToConfirmBooking()
        }
    }
    
    private func navigateToConfirmBooking() {
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        if let confirmBookingVC = storyboard.instantiateViewController(withIdentifier: "ConfirmYourBookingVC") as? ConfirmYourBookingVC {
            confirmBookingVC.guestName = self.guestName
            confirmBookingVC.guestEmail = self.guestEmail
            confirmBookingVC.guestMobileNumber = self.guestMobileNumber
            confirmBookingVC.selectedHotel = self.selectedHotel
            confirmBookingVC.selectedRoom = self.selectedRoom
            confirmBookingVC.selectedRates = self.selectedRates
            confirmBookingVC.modalPresentationStyle = .fullScreen
            self.present(confirmBookingVC, animated: true)
        }
    }
    
    private func highlightCheckbox() {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.2
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = 1
        checkMarkButton.layer.add(pulseAnimation, forKey: "pulse")
    }
}
