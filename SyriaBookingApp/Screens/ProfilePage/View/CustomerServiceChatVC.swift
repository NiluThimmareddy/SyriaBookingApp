//
//  CustomerServiceVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 02/07/25.
//

import UIKit

class CustomerServiceChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var suggestionCV: UICollectionView!
    @IBOutlet weak var inputContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var centreView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputContainerView: UIView!

    var chatMessages: [ChatMessage] = []
    let topNameLbl: UILabel = {
       let label = UILabel()
       label.textColor = .white
       label.text = "Customer Service Chat"
       label.font = UIFont.poppinsBold(16)
       label.textAlignment = .center
       return label
   }()
    var chatSuggestions: [String] = []
    var suggestionStage: ChatSuggestionStage = .initial {
        didSet {
            updateSuggestions()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField.delegate = self
        chatTableView.register(UINib(nibName: "CustomerServiceChatTVC", bundle: nil), forCellReuseIdentifier: "CustomerServiceChatTVC")
        setupKeyboardObservers()
        suggestionCV.register(UINib(nibName: "SuggestionCVC", bundle: nil), forCellWithReuseIdentifier: "SuggestionCVC")
        let tableTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tableTapGesture.cancelsTouchesInView = false
        chatTableView.addGestureRecognizer(tableTapGesture)
        navigationItem.titleView = topNameLbl
        messageTextField.layer.cornerRadius = 5
        messageTextField.layer.borderWidth = 1
        messageTextField.layer.borderColor = UIColor.lightGray.cgColor
        suggestionStage = .initial

    }
    
    func generateFakeBookingIDs(count: Int) -> [String] {
        return (1...count).map { _ in
            "#\(Int.random(in: 1000...9999))"
        }
    }

   
   
    
    func updateSuggestions() {
        UIView.transition(with: suggestionCV, duration: 0.3, options: .transitionCrossDissolve, animations: {
            switch self.suggestionStage {
            case .initial:
                self.chatSuggestions = ["Hi", "Hello", "Hey", "Good morning", "Is anyone there?"]
            case .service:
                self.chatSuggestions = [
                    "I want to track my booking",
                    "I want to cancel my booking",
                    "Can I modify my booking?",
                    "I need help with my reservation",
                    "I want to upgrade my room",
                    "I have a payment issue"
                ]
            case .bookingIDTrack:
                self.chatSuggestions = ["#BK1234", "#BK5678", "#BK9012", "#BK0001", "#BK8888"]
            case .bookingIDCancel:
                self.chatSuggestions = ["#BK2233", "#BK4455", "#BK6677", "#BK8899", "#BK1000"]
            case .postBookingID:
                self.chatSuggestions = [
                    "Can I change my check-in date?",
                    "I want to upgrade to a deluxe room",
                    "Will breakfast be included?",
                    "I need to speak with customer support",
                    "What is the check-in time?",
                    "Thank you"
                ]
            case .none:
                self.chatSuggestions = []
            }
            self.suggestionCV.reloadData()
        })
    }

    func presentDatePicker() {
        let alert = UIAlertController(title: "Select New Check-In Date", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.frame = CGRect(x: 0, y: 15, width: alert.view.bounds.width - 20, height: 200)
        
        alert.view.addSubview(datePicker)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            let selectedDate = formatter.string(from: datePicker.date)

            let dateConfirmMessage = "Your check-in date has been updated to \(selectedDate)."
            let agentReply = ChatMessage(message: dateConfirmMessage, isFromAgent: true, timestamp: Date())
            self.chatMessages.append(agentReply)
            self.chatTableView.reloadData()
            self.scrollToBottom()
        }))

        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        present(alert, animated: true, completion: nil)
    }

    @objc func dismissKeyboard() {
        if messageTextField.isFirstResponder {
            messageTextField.resignFirstResponder()
        }
    }

    func sendMessage(_ text: String) {
            guard !text.isEmpty else { return }

            let userMessage = ChatMessage(message: text, isFromAgent: false, timestamp: Date())
            chatMessages.append(userMessage)
            chatTableView.reloadData()
            scrollToBottom()
            messageTextField.text = ""

            let lowercasedText = text.lowercased()
            var reply = "I'm sorry, I didn't understand that. Can you rephrase?"
            var nextStage: ChatSuggestionStage = .none

            if lowercasedText.contains("hi") || lowercasedText.contains("hello") || lowercasedText.contains("hey") {
                reply = "Hello! How can I assist you today?"
                nextStage = .service

            } else if lowercasedText.contains("track") {
                if let bookingID = extractBookingID(from: text) {
                    reply = "Tracking your booking with ID \(bookingID)..."
                    nextStage = .postBookingID
                } else {
                    reply = "Please provide your booking ID to track your booking."
                    nextStage = .bookingIDTrack
                }

            } else if lowercasedText.contains("cancel") {
                if let bookingID = extractBookingID(from: text) {
                    reply = "Your booking with ID \(bookingID) has been cancelled."
                    nextStage = .postBookingID
                } else {
                    reply = "Sure, please provide your booking ID to proceed with cancellation."
                    nextStage = .bookingIDCancel
                }

            } else if let bookingID = extractBookingID(from: text) {
                reply = "Processing booking ID \(bookingID)..."
                nextStage = .postBookingID

            } else if lowercasedText.contains("change") && lowercasedText.contains("check-in") {
                reply = "Sure! Please select your new check-in date."
                nextStage = .postBookingID

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    let agentReply = ChatMessage(message: reply, isFromAgent: true, timestamp: Date())
                    self.chatMessages.append(agentReply)
                    self.chatTableView.reloadData()
                    self.scrollToBottom()
                    self.suggestionStage = nextStage
                    self.presentDatePicker()
                }
                return
            } else if lowercasedText.contains("upgrade") {
                reply = "Great! I’ve found a deluxe room available for ₹500 extra per night. Would you like to proceed?"
                nextStage = .postBookingID

            } else if lowercasedText.contains("breakfast") {
                reply = "Yes, complimentary breakfast is included with all deluxe and suite bookings."
                nextStage = .postBookingID

            } else if lowercasedText.contains("speak") || lowercasedText.contains("customer support") {
                reply = "I’m connecting you with our customer support team. Please wait a moment..."
                nextStage = .none

            } else if lowercasedText.contains("check-in time") {
                reply = "Standard check-in time is 2:00 PM, and check-out is at 11:00 AM."
                nextStage = .postBookingID

            } else if lowercasedText.contains("thank") {
                reply = "You're welcome! Let us know if you need anything else."
                nextStage = .initial
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let agentReply = ChatMessage(message: reply, isFromAgent: true, timestamp: Date())
                self.chatMessages.append(agentReply)
                self.chatTableView.reloadData()
                self.scrollToBottom()
                self.suggestionStage = nextStage
            }
        }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        suggestionStage = .none
        return true
    }

    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard let text = messageTextField.text else { return }
            sendMessage(text)
    }
    func extractBookingID(from text: String) -> String? {
        let pattern = "\\d+"
        if let range = text.range(of: pattern, options: .regularExpression) {
            return String(text[range])
        }
        return nil
    }


    func scrollToBottom() {
        guard chatMessages.count > 0 else { return }
        let indexPath = IndexPath(row: chatMessages.count - 1, section: 0)
        chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }

    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = chatMessages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerServiceChatTVC", for: indexPath) as! CustomerServiceChatTVC
        cell.configure(with: message)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = chatMessages[indexPath.row].message
        let font = UIFont.systemFont(ofSize: 16)
        let bubbleWidth = tableView.frame.width * 0.6

        let textRect = NSString(string: message).boundingRect(
            with: CGSize(width: bubbleWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )

        let verticalPadding: CGFloat = 20
        let minHeight: CGFloat = 60
        let calculatedHeight = ceil(textRect.height) + verticalPadding

        return max(minHeight, calculatedHeight)
    }




    // MARK: - Keyboard Handling

    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func handleKeyboard(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }

        let isKeyboardShowing = keyboardFrame.origin.y < UIScreen.main.bounds.height
        let bottomPadding = view.safeAreaInsets.bottom

        inputContainerBottomConstraint.constant = isKeyboardShowing ? keyboardFrame.height - bottomPadding : 0

        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: UIView.AnimationOptions(rawValue: curveValue << 16),
                       animations: {
            self.view.layoutIfNeeded()
            self.scrollToBottom()
        }, completion: nil)
    }

}


extension CustomerServiceChatVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatSuggestions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionCVC", for: indexPath) as! SuggestionCVC
        let suggestion = chatSuggestions[indexPath.item]
        cell.titleLabel.text = suggestion
        cell.titleLabel.font = UIFont.poppinsMedium(14)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let suggestion = chatSuggestions[indexPath.item]
        let font = UIFont.poppinsMedium(14)
        let textWidth = (suggestion as NSString).size(withAttributes: [.font: font]).width
        return CGSize(width: textWidth + 32, height: 34)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedText = chatSuggestions[indexPath.item]
        messageTextField.text = selectedText
        sendMessage(selectedText)
    }
    
}
