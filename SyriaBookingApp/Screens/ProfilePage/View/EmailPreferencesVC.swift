//
//  EmailPreferencesVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 03/07/25.
//

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
    var emailData = [
        SecurityData(securityTitle: "Booking Confirmation & Updates", securityContent: "Receive confirmations, changes and important information about your bookings."),
        SecurityData(securityTitle: "Special Offer & Promotions", securityContent: "Get exclusive deals, discounts and limited-time offers tailored to your interests."),
        SecurityData(securityTitle: "Account updates & Security Alerts", securityContent: "Important notification about your account security and policy changes.")
    ]
    let topNameLbl: UILabel = {
       let label = UILabel()
       label.textColor = .white
       label.text = "Email Perferences"
       label.font = UIFont.poppinsBold(16)
       label.textAlignment = .center
       return label
   }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailPreferencesTV.register(UINib(nibName: "EmailPreferencesTVC", bundle: nil), forCellReuseIdentifier: "EmailPreferencesTVC")
        fontText()
        navigationItem.titleView = topNameLbl
        lottieView.isHidden = true
        emailPreferenceButton.layer.cornerRadius = 5
    }
    
   
   
    
    func fontText(){
        chooseWhatTitle.font = UIFont.poppinsBold(14)
        unsubscribeTitle.font = UIFont.poppinsBold(14)
        youLlStillContent.font = UIFont.poppinsMedium(12)
        
        let subTv = NSAttributedString(
            string: "Reset Preferences  ",
            attributes: [.font: UIFont.poppinsBold(14), .foregroundColor:  UIColor.white]
        )
        emailPreferenceButton.setAttributedTitle(subTv, for: .normal)
        
    }

    @IBAction func checkBox(_ sender: Any) {
        isChecked.toggle()
        let imageName = isChecked ? "square-check" : "square"
        checkBox.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func emailPreferenceButton(_ sender: Any) {
    }
    
}

extension EmailPreferencesVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmailPreferencesTVC")as! EmailPreferencesTVC
        let data = emailData[indexPath.row]
        cell.contentLbl.text = data.securityContent
        cell.title.text = data.securityTitle
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
