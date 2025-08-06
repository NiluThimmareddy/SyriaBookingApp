//
//  CustomerServiceVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 02/07/25.
//

import UIKit
import Lottie

class CustomerServiceVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollViewScroll: UIScrollView!
    @IBOutlet weak var sendMessage: UIButton!
    @IBOutlet weak var subjectTV: UITableView!
    @IBOutlet weak var contactUsBackView: UIView!
    @IBOutlet weak var fileChooseBackjVIew: UIView!
    @IBOutlet weak var noFileChoosen: UILabel!
    @IBOutlet weak var chooseFile: UIButton!
    @IBOutlet weak var attachmentTitle: UILabel!
    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sujectTvButton: UIButton!
    @IBOutlet weak var subjectTitle: UILabel!
    @IBOutlet weak var contactUsTitle: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var emailLottieView: UIView!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var emailContent: UILabel!
    @IBOutlet weak var emailBackView: UIView!
    @IBOutlet weak var callBackView: UIView!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var twentyFourHoursContent: UILabel!
    @IBOutlet weak var twentyFourHoursTitle: UILabel!
    
   let bgColor = UIColor(named: "backgroundColor")
    let topNameLbl: UILabel = {
       let label = UILabel()
       label.textColor = .white
       label.text = "Customer Service"
       label.font = UIFont.poppinsBold(16)
       label.textAlignment = .center
       return label
   }()
    
    var dataTable = ["Select a topic", "Booking Enquiry", "Cancellation Request", "Technical Problem", "Feedback", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callButton.layer.cornerRadius = callButton.frame.size.height / 2
        emailButton.layer.cornerRadius = emailButton.frame.size.height / 2
        twentyFourHoursContent.attributedText = boldPhoneNumberText(
            fullText: "Our customer service team is available around the clock to assist you. +1(800) 123  - 4567",
            boldPart: "+1(800) 123  - 4567"
        )
        emailContent.attributedText = boldPhoneNumberText(
            fullText: "Send us an Email we'll get back to you within 24hrs. support@hotel.booking.com",
            boldPart: "support@hotel.booking.com"
        )
        subjectTV.register(UINib(nibName: "UserFeedBackAfterCheckOutTVC", bundle: nil), forCellReuseIdentifier: "UserFeedBackAfterCheckOutTVC")
        fontText()
        chatButton.BackViewShadowAppyManually(cornerRadius: chatButton.frame.size.height / 2)
        setupLottie()
        setupEmailLottie()
        subjectTV.isHidden = true
        contactUsBackView.BackViewShadow()
        fileChooseBackjVIew.layer.cornerRadius = 10
        sendMessage.BackViewShadow()
        sujectTvButton.layer.cornerRadius = 10
        sujectTvButton.layer.borderWidth = 1
        sujectTvButton.layer.borderColor = bgColor?.cgColor
        messageTextView.layer.cornerRadius = 10
        messageTextView.layer.borderWidth = 1
        messageTextView.layer.borderColor = bgColor?.cgColor
        
        let tableTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tableTapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tableTapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationItem.titleView = topNameLbl
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        roundTopRightCornerOnly()
        roundLeftSideCorners()
    }
    
    private func roundTopRightCornerOnly() {
        callBackView.layer.cornerRadius = 50
        callBackView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        callBackView.clipsToBounds = true
    }
    private func roundLeftSideCorners() {
        emailBackView.layer.cornerRadius = 50
        emailBackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        emailBackView.clipsToBounds = true
    }

    private func setupLottie() {
        let animationView = LottieAnimationView(name: "progressright")
        animationView.frame = lottieView.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        
        // Set color override (hex: #003B95)
        let blueColor = UIColor(red: 0/255, green: 59/255, blue: 149/255, alpha: 1)
        let colorProvider = ColorValueProvider(blueColor.lottieColorValue)
        
        // Keypath to fill color in your animation
        animationView.setValueProvider(colorProvider, keypath: AnimationKeypath(keypath: "**.Fill 1.Color"))
        
        animationView.play()
        lottieView.addSubview(animationView)
    }
    private func setupEmailLottie() {
        let animationView = LottieAnimationView(name: "progressright")
        animationView.frame = emailLottieView.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop

        // Set tint color override
        let blueColor = UIColor(red: 0/255, green: 59/255, blue: 149/255, alpha: 1)
        let colorProvider = ColorValueProvider(blueColor.lottieColorValue)
        animationView.setValueProvider(colorProvider, keypath: AnimationKeypath(keypath: "**.Fill 1.Color"))

        // Flip horizontally
        animationView.transform = CGAffineTransform(scaleX: -1, y: 1)

        animationView.play()
        emailLottieView.addSubview(animationView)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardFrame.height

        scrollViewScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 20, right: 0)
        scrollViewScroll.scrollIndicatorInsets = scrollViewScroll.contentInset

        // Scroll to the active textView
        if let activeTextView = view.firstResponder {
            let visibleRect = scrollViewScroll.convert(activeTextView.frame, from: activeTextView.superview)
            scrollViewScroll.scrollRectToVisible(visibleRect, animated: true)
        }
    }


    @objc func keyboardWillHide(_ notification: Notification) {
        scrollViewScroll.contentInset = .zero
        scrollViewScroll.scrollIndicatorInsets = .zero
    }
    
    
    func boldPhoneNumberText(fullText: String, boldPart: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: fullText)

        let fullFont = UIFont.poppinsMedium(12)
        let boldFont = UIFont.poppinsBold(12)

        attributedString.addAttribute(.font, value: fullFont, range: NSRange(location: 0, length: fullText.count))

        if let boldRange = fullText.range(of: boldPart) {
            let nsRange = NSRange(boldRange, in: fullText)
            attributedString.addAttribute(.font, value: boldFont, range: nsRange)
        }

        return attributedString
    }

    func fontText(){
        twentyFourHoursTitle.font = UIFont.poppinsBold(14)
        emailTitle.font = UIFont.poppinsBold(14)
        messageTitle.font = UIFont.poppinsMedium(14)
        attachmentTitle.font = UIFont.poppinsMedium(14)
        subjectTitle.font = UIFont.poppinsMedium(14)
        noFileChoosen.font = UIFont.poppinsMedium(12)
        contactUsTitle.font = UIFont.poppinsBold(14)
       
        
        let sendMessagee = NSAttributedString(
            string: "Send Message",
            attributes: [.font: UIFont.poppinsBold(12), .foregroundColor:  UIColor.white]
        )
        sendMessage.setAttributedTitle(sendMessagee, for: .normal)
        
        let choose = NSAttributedString(
            string: "Choose file",
            attributes: [.font: UIFont.poppinsMedium(12), .foregroundColor:  UIColor.black]
        )
        chooseFile.setAttributedTitle(choose, for: .normal)
        
        let subTv = NSAttributedString(
            string: "Select a topic",
            attributes: [.font: UIFont.poppinsMedium(12), .foregroundColor:  UIColor.black]
        )
        sujectTvButton.setAttributedTitle(subTv, for: .normal)
    }

    @IBAction func sujectTvButton(_ sender: Any) {
        subjectTV.isHidden = !subjectTV.isHidden
    }
    
    @IBAction func emailButton(_ sender: Any) {
        let email = "support@hotel.booking.com"
        if let url = URL(string: "mailto:\(email)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                let alert = UIAlertController(title: "Mail Not Configured", message: "Please set up a Mail account to send emails.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func chatButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "CustomerServiceChatVC")as! CustomerServiceChatVC
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func callButton(_ sender: Any) {
        let phoneNumber = "+18001234567"
        
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "Cannot Make Call", message: "Calling is not supported on this device.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func sendMessageAct(_ sender: Any) {
    }
    
    @IBAction func chooseFileAct(_ sender: Any) {
        let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let url = info[.imageURL] as? URL {
            noFileChoosen.text = url.lastPathComponent
        } else {
            noFileChoosen.text = "Unknown file"
        }
    }
    
}

extension CustomerServiceVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserFeedBackAfterCheckOutTVC")as! UserFeedBackAfterCheckOutTVC
        let data = dataTable[indexPath.row]
        cell.titleData.text = data
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataTable[indexPath.row]
        sujectTvButton.setTitle(data, for: .normal)
        let choose = NSAttributedString(
            string: data,
            attributes: [.font: UIFont.poppinsMedium(12), .foregroundColor:  UIColor.black]
        )
        sujectTvButton.setAttributedTitle(choose, for: .normal)
        subjectTV.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}
