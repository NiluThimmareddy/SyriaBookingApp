//
//  CancelBookingVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 11/09/25.
//

import UIKit

protocol CancelBookingDelegate: AnyObject {
    func didConfirmCancellation(for booking: BookingHistoryModel,reason:String)
}

class CancelBookingVC: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var cancelBookingTitleLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var hotelNameAndDateLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var reasonTextView: UITextView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var confirmCancelButton: UIButton!
    
    private var placeholderLabel: UILabel!
    weak var delegate: CancelBookingDelegate?
    var booking: BookingHistoryModel?
    
    var viewModel = BookingViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlaceholder()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backView.layer.cornerRadius = 10
        backView.clipsToBounds = true
    }

    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func confirmCancelButtonAction(_ sender: Any) {
//        
//        guard let reason = reasonTextView.text else {
//            self.showAlert("Please enter reason for cancel your booking")
//            return
//        }
//        self.showLoader()
//        if let booking = booking {
//            hideLoader()
//            delegate?.didConfirmCancellation(for: booking,reason: reason)
//        }
//        
//        self.dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func confirmCancelButtonAction(_ sender: Any) {
        guard let reason = reasonTextView.text, !reason.isEmpty else {
            self.showAlert("Please enter reason for cancel your booking")
            return
        }
        
        guard let booking = booking else { return }

        guard let user = UserSessionManager.getUser() else { return}
        self.showLoader()
        
        
        viewModel.postCancelBooking(reason:reason, userId: booking.id, BookingId: user.id) { [weak self] success in
            
            guard let self = self else { return }
            self.hideLoader()
            
            showAlert(title: "Cancel", message: success.message)
                self.dismiss(animated: true)
            }
   
        }
}

extension CancelBookingVC : UITextViewDelegate {
    func setupPlaceholder() {
        reasonTextView.delegate = self        
        placeholderLabel = UILabel()
        placeholderLabel.text = "Tell us briefly why you're cancelling"
        placeholderLabel.font = UIFont.systemFont(ofSize: 15)
        placeholderLabel.textColor = .lightGray
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        reasonTextView.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: reasonTextView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: reasonTextView.leadingAnchor, constant: 5)
        ])
        
        placeholderLabel.isHidden = !reasonTextView.text.isEmpty
    }
    

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
