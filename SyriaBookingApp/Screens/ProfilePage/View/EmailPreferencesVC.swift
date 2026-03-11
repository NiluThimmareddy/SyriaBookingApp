//  EmailPreferencesVC.swift
//  HotelBooking
//  Created by praveenkumar on 03/07/25.

import UIKit

class EmailPreferencesVC: UIViewController {
    
    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var emailPreferenceButton: UIButton!
    @IBOutlet weak var youLlStillContent: UILabel!
    @IBOutlet weak var unsubscribeTitle: UILabel!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var emailPreferencesTV: UITableView!
    @IBOutlet weak var chooseWhatTitle: UILabel!
    
    let switchKeyPrefix = "emailSwitchState_"
    var isChecked = false
    
    // English data
    var englishEmailData = [
        SecurityData(securityTitle: "Booking Confirmation & Updates", securityContent: "Receive confirmations, changes and important information about your bookings."),
        SecurityData(securityTitle: "Special Offers & Promotions", securityContent: "Get exclusive deals, discounts and limited-time offers tailored to your interests."),
        SecurityData(securityTitle: "Account Updates & Security Alerts", securityContent: "Important notifications about your account security and policy changes.")
    ]
    
    // Arabic data
    var arabicEmailData = [
        SecurityData(securityTitle: "تأكيد الحجز والتحديثات", securityContent: "احصل على تأكيدات وتغييرات ومعلومات مهمة حول حجوزاتك."),
        SecurityData(securityTitle: "العروض الخاصة والترويجية", securityContent: "احصل على عروض حصرية وخصومات وعروض محدودة الوقت مصممة حسب اهتماماتك."),
        SecurityData(securityTitle: "تحديثات الحساب وتنبيهات الأمان", securityContent: "إشعارات مهمة حول أمان حسابك وتغييرات السياسة.")
    ]
    
    // Computed property that returns data based on current language
    var emailData: [SecurityData] {
        return AppSettings.shared.selectedLanguage == .arabic ? arabicEmailData : englishEmailData
    }
    
    let topNameLbl: UILabel = {
       let label = UILabel()
       label.textColor = .white
       label.font = UIFont.poppinsBold(16)
       label.textAlignment = .center
       return label
   }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add language change notification observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTexts),
            name: .languageChanged,
            object: nil
        )
        
        emailPreferencesTV.register(UINib(nibName: "EmailPreferencesTVC", bundle: nil), forCellReuseIdentifier: "EmailPreferencesTVC")
        fontText()
        navigationItem.titleView = topNameLbl
        lottieView.isHidden = true
        emailPreferenceButton.layer.cornerRadius = 5
        
        // Set initial texts
        updateTexts()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        
        if lang == .arabic {
            topNameLbl.text = "تفضيلات البريد الإلكتروني"
            chooseWhatTitle.text = "اختر نوع رسائل البريد الإلكتروني التي ترغب في تلقيها منا."
            unsubscribeTitle.text = "إلغاء الاشتراك من جميع رسائل البريد الإلكتروني التسويقية"
            youLlStillContent.text = "ستستمر في تلقي رسائل البريد الإلكتروني الأساسية حول أمان حسابك وتغييرات السياسة."
            
            let buttonTitle = NSAttributedString(
                string: "إعادة تعيين التفضيلات",
                attributes: [.font: UIFont.poppinsBold(14), .foregroundColor: UIColor.white]
            )
            emailPreferenceButton.setAttributedTitle(buttonTitle, for: .normal)
        } else {
            topNameLbl.text = "Email Preferences"
            chooseWhatTitle.text = "Choose what type of emails you'd like to receive from us."
            unsubscribeTitle.text = "Unsubscribe from all marketing emails"
            youLlStillContent.text = "You'll still receive essential emails about your account security and policy changes."
            
            let buttonTitle = NSAttributedString(
                string: "Reset Preferences",
                attributes: [.font: UIFont.poppinsBold(14), .foregroundColor: UIColor.white]
            )
            emailPreferenceButton.setAttributedTitle(buttonTitle, for: .normal)
        }
        
        // Reload table view with new data
        emailPreferencesTV.reloadData()
    }
    
    func fontText(){
        chooseWhatTitle.font = UIFont.poppinsBold(14)
        unsubscribeTitle.font = UIFont.poppinsBold(14)
        youLlStillContent.font = UIFont.poppinsMedium(12)
    }

    @IBAction func checkBox(_ sender: Any) {
        isChecked.toggle()
        let imageName = isChecked ? "square-check" : "square"
        checkBox.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func emailPreferenceButton(_ sender: Any) {
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension EmailPreferencesVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmailPreferencesTVC") as! EmailPreferencesTVC
        let data = emailData[indexPath.row]
        
        let lang = AppSettings.shared.selectedLanguage
        
        cell.contentLbl.text = data.securityContent
        cell.title.text = data.securityTitle
        
        // Set text alignment based on language
        if lang == .arabic {
            cell.title.textAlignment = .right
            cell.contentLbl.textAlignment = .right
        } else {
            cell.title.textAlignment = .left
            cell.contentLbl.textAlignment = .left
        }
        
        // Key for this cell's switch
        let switchKey = "\(switchKeyPrefix)\(indexPath.row)"
        
        // Default ON for 1st and 3rd cell (index 0 and 2)
        let savedState = UserDefaults.standard.object(forKey: switchKey) as? Bool
        if let state = savedState {
            cell.swictchButton.isOn = state
        } else {
            let defaultState = (indexPath.row == 0 || indexPath.row == 2)
            cell.swictchButton.isOn = defaultState
            UserDefaults.standard.set(defaultState, forKey: switchKey)
        }
        
        // Handle toggle change
        cell.swictchButton.tag = indexPath.row
        cell.swictchButton.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        let key = "\(switchKeyPrefix)\(sender.tag)"
        UserDefaults.standard.set(sender.isOn, forKey: key)
    }
}
