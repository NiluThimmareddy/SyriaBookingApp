//
//  CancelBookingViewController.swift
//  SyriaBookingApp
//
//  Created by Hitman on 06/04/26.

import UIKit

protocol CancelBookingDelegate: AnyObject {
    func didConfirmCancellation(for booking: BookingHistoryModel, reason: String)
}

class CancelBookingViewController: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cancelBookingTitleLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var roomTypeLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var whyAreYouCancellingTitleLabel: UILabel!
    @IBOutlet weak var changeOfPlansButton: UIButton!
    @IBOutlet weak var foundBetterPriceButton: UIButton!
    @IBOutlet weak var bookingMistakeButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var cancellationLabel: UILabel!
    @IBOutlet weak var youWontBeAbelLabel: UILabel!
    @IBOutlet weak var keepBookingButton: UIButton!
    @IBOutlet weak var cancelBookingButton: UIButton!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    private var placeholderLabel: UILabel!
    weak var delegate: CancelBookingDelegate?
    var booking: BookingHistoryModel?
    var viewModel = BookingViewModel()
    
    private var selectedButton: UIButton?
    private var selectedReason: String = ""
    private var cancelButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlaceholder()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backView.layer.cornerRadius = 10
        backView.clipsToBounds = true
        setupLanguage()
        hideKeyboardWhenTappedAround()
        messageTextView.delegate = self
        setupCancelButtons()
        setupInitialTextViewHeight()
    }

    override func viewDidAppear(_ animated: Bool) {
        setUpUI()
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeOfPlansButtonAction(_ sender: Any) {
        selectButton(changeOfPlansButton, reason: "Change of plans")
    }
    
    @IBAction func foundBetterPriceButtonAction(_ sender: Any) {
        selectButton(foundBetterPriceButton, reason: "Found better price")
    }
    
    @IBAction func bookingMistakeButtonAction(_ sender: Any) {
        selectButton(bookingMistakeButton, reason: "Booking mistake")
    }
    
    @IBAction func otherButtonAction(_ sender: Any) {
        selectButton(otherButton, reason: "Other")
        if selectedButton == otherButton {
            showTextView()
            messageTextView.becomeFirstResponder()
        }
    }
    
    @IBAction func keepBookingButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBookingButtonAction(_ sender: Any) {
        guard let booking = booking else { return }
        
        guard selectedButton != nil else {
            showAlert(message: "Please select a reason for cancellation")
            return
        }
        
        var finalReason = selectedReason
        
        if selectedButton == otherButton {
            let customMessage = messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if !customMessage.isEmpty {
                finalReason = "Other: \(customMessage)"
            } else {
                showAlert(message: "Please provide a reason for cancellation")
                return
            }
        }
        
        showLoader()
        delegate?.didConfirmCancellation(for: booking, reason: finalReason)
    }
    
}

extension CancelBookingViewController: UITextViewDelegate {
    
    func setUpUI() {
        guard let booking = booking else {
            return
        }
        hotelNameLabel.text = "\(booking.hotelName)"
        let checkIn = booking.checkInUtc.toDayMonthYear()
        let checkOut = booking.checkOutUtc.toDayMonthYear()
        datesLabel.text = "\(checkIn) – \(checkOut)"
        roomTypeLabel.text = booking.roomType
        hotelImageView.image = UIImage(named: "HotelPlaceholder")
    }
    
    func setupPlaceholder() {
        messageTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Tell us briefly why you're cancelling"
        placeholderLabel.font = UIFont.systemFont(ofSize: 15)
        placeholderLabel.textColor = .lightGray
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: messageTextView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: messageTextView.leadingAnchor, constant: 5)
        ])
        placeholderLabel.isHidden = !messageTextView.text.isEmpty
    }
    private func setupInitialTextViewHeight() {
        textViewHeightConstraint.constant = 0
        messageTextView.isHidden = true
        view.layoutIfNeeded()
    }
    
    private func showTextView() {
        textViewHeightConstraint.constant = 60
        messageTextView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideTextView() {
        textViewHeightConstraint.constant = 0
        messageTextView.isHidden = true
        messageTextView.resignFirstResponder()
        messageTextView.text = ""
        placeholderLabel.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if selectedButton == otherButton {
            showTextView()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    }
    
}

extension CancelBookingViewController {
    private func selectButton(_ button: UIButton, reason: String) {
        for btn in cancelButtons {
            updateButtonStyle(button: btn, isSelected: false)
        }
        
        updateButtonStyle(button: button, isSelected: true)
        
        selectedButton = button
        selectedReason = reason
        
        if button == otherButton {
            showTextView()
        } else {
            hideTextView()
            selectedReason = reason
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    } 
    
    func setupLanguage() {
        if AppSettings.shared.selectedLanguage == .arabic {
            cancelBookingTitleLabel.text = "إلغاء الحجز"
        } else {
            cancelBookingTitleLabel.text = "Cancel Booking"
        }
    }
    
    private func setupCancelButtons() {
        cancelButtons = [changeOfPlansButton, foundBetterPriceButton, bookingMistakeButton, otherButton]
        
        for button in cancelButtons {
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray4.cgColor
            updateButtonStyle(button: button, isSelected: false)
        }
    }
    
    private func updateButtonStyle(button: UIButton, isSelected: Bool) {
        if isSelected {
            button.backgroundColor = UIColor.label
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.setTitleColor(.white, for: .highlighted)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            button.layer.borderColor = UIColor.label.cgColor
            button.tintColor = .white
        } else {
            button.backgroundColor = UIColor.systemBackground
            button.setTitleColor(UIColor.label, for: .normal)
            button.setTitleColor(UIColor.label, for: .selected)
            button.setTitleColor(UIColor.label, for: .highlighted)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            button.layer.borderColor = UIColor.systemGray4.cgColor
            button.tintColor = UIColor.label
        }
        
        button.setNeedsLayout()
        button.layoutIfNeeded()
    }
}
