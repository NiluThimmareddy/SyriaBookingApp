//
//  LeftMenuViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 31/07/25.
//

import UIKit

struct MenuItem {
    let titleEN: String
    let titleAR: String
    let icon: String
    
    func localizedTitle() -> String {
        if AppSettings.shared.selectedLanguage == .english {
            return titleEN
        } else {
            return titleAR
        }
    }
}

class LeftMenuViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var LeftMenuUITableView : UITableView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var personEmailLabel: UILabel!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var loginbutton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var arabicButton: UIButton!
    @IBOutlet weak var rightArrow: UIButton!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    let menuItems: [MenuItem] = [
        MenuItem(titleEN: "Hotels", titleAR: "فنادق", icon: "bed.double.fill"),
        MenuItem(titleEN: "Careers", titleAR: "وظائف", icon: "briefcase.fill"),
        MenuItem(titleEN: "How it works", titleAR: "كيف تعمل", icon: "questionmark.circle.fill"),
        MenuItem(titleEN: "Your Booking", titleAR: "حجوزاتك", icon: "calendar.badge.checkmark"),
        MenuItem(titleEN: "COVID-19 – FAQs", titleAR: "الأسئلة الشائعة - كوفيد 19", icon: "checkmark.shield.fill"),
        MenuItem(titleEN: "Sustainability", titleAR: "الاستدامة", icon: "leaf.circle.fill"),
        MenuItem(titleEN: "Safety Resource Center", titleAR: "مركز موارد السلامة", icon: "shield.lefthalf.filled.badge.checkmark")
    ]
    
    var onDismiss: (()->Void)?
    let languages = ["English", "العربية"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        if AppSettings.shared.selectedLanguage == nil {
            AppSettings.shared.selectedLanguage = .english
        }
        
        updateLanguageButtonsUI()
        NotificationCenter.default.addObserver(
            self,selector: #selector(LeftMenuReload),name: .languageChanged,object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backButtonTitle = ""
        loadUserDetails()
    }
    
    @IBAction func DismissButtonAction(_ sender: UIButton) {
        onDismiss?()
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "RegisterMobileNumberVC") as? RegisterMobileNumberVC else { return }
        controller.comingFrom = .HomeSliderView
        controller.modalPresentationStyle = .overFullScreen
        controller.transitioningDelegate = self
        controller.reloadScreenAfterDismiss = {
            self.dismissPopup()
            
        }
        self.present(controller, animated: true)
    }
    
    @IBAction func rightArrowButtonAction(_ sender: Any) {
       guard let storyboard = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfilePageVC") as? ProfilePageVC else { return }
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
    @IBAction func languagesButtonAction(_ sender: Any) {
    }
    
    @IBAction func englishLanguageButtonAction(_ sender: Any) {
        AppSettings.shared.selectedLanguage = .english
        NotificationCenter.default.post(name: .languageChanged, object: nil)
        updateLanguageButtonsUI()
    }
    
    @IBAction func arabicLanguageButtonAction(_ sender: Any) {
        AppSettings.shared.selectedLanguage = .arabic
        NotificationCenter.default.post(name: .languageChanged, object: nil)
        updateLanguageButtonsUI()
    }
    
}

extension LeftMenuViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuTVC") as! LeftMenuTVC
        let item = menuItems[indexPath.row]
        cell.titleLabel.text = item.localizedTitle()
        
        let image = UIImage(systemName: item.icon)?.withRenderingMode(.alwaysTemplate)
        cell.imgView.image = image
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        
        guard let indexPath = indexPath else { return }
        
        switch indexPath.row {
        case 0 :
            guard let controller = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HotelListViewController") as? HotelListViewController else { return}
            controller.comingFrom = .tabBar
            self.navigationController?.pushViewController(controller, animated: true)
        case 1 :
            guard let controller = storyboard?.instantiateViewController(withIdentifier: "CareersViewController") as? CareersViewController else { return}
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(controller, animated: true)
        case 2:
            guard let controller = storyboard?.instantiateViewController(withIdentifier: "HowItWorksViewController") as? HowItWorksViewController else { return}
            self.navigationController?.pushViewController(controller, animated: true)
        case 3:
            guard let controller = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MyBookingsViewController") as? MyBookingsViewController  else { return}
            self.navigationController?.pushViewController(controller, animated: true)
        case 4:
            guard let controller = storyboard?.instantiateViewController(withIdentifier: "Covid19FAQsViewController") as? Covid19FAQsViewController  else { return}
            self.navigationController?.pushViewController(controller, animated: true)
        case 5:
            guard let controller = storyboard?.instantiateViewController(withIdentifier: "SustainabilityViewController") as? SustainabilityViewController  else { return}
            self.navigationController?.pushViewController(controller, animated: true)
        case 6:
            guard let controller = storyboard?.instantiateViewController(withIdentifier: "SafetyResourceCenterViewController") as? SafetyResourceCenterViewController  else { return}
            self.navigationController?.pushViewController(controller, animated: true)
        default :
            break
        }
    }
}

extension LeftMenuViewController {
    func setUpUI() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        
        [backView].forEach { shadow in
            shadow?.applyCardStyle()
            shadow?.layer.cornerRadius = 20
            shadow?.layer.maskedCorners = [.layerMaxXMinYCorner]
        }
        LeftMenuUITableView.register(UINib(nibName: "LeftMenuTVC", bundle: nil), forCellReuseIdentifier: "LeftMenuTVC")
        applyCornerRadiusToLanguageButtons()
        
        languageButton.applyTopRightLightGreyGradient()
    }
    
    func applyCornerRadiusToLanguageButtons() {
        let cornerRadius: CGFloat = 5
        
        englishButton.layer.cornerRadius = cornerRadius
        englishButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        englishButton.clipsToBounds = true
        
        arabicButton.layer.cornerRadius = cornerRadius
        arabicButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        arabicButton.clipsToBounds = true
    }
    
    func updateLanguageButtonsUI() {
        let selectedLanguage = AppSettings.shared.selectedLanguage
        
        englishButton.layer.borderWidth = 1
        arabicButton.layer.borderWidth = 1
        englishButton.layer.borderColor = UIColor.lightGray.cgColor
        arabicButton.layer.borderColor = UIColor.lightGray.cgColor
        
        englishButton.backgroundColor = .white
        arabicButton.backgroundColor = .white
        englishButton.setTitleColor(.black, for: .normal)
        arabicButton.setTitleColor(.black, for: .normal)
        
        switch selectedLanguage {
        case .english:
            englishButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.6)
            englishButton.setTitleColor(.white, for: .normal)
            englishButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        case .arabic:
            arabicButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.6)
            arabicButton.setTitleColor(.white, for: .normal)
            arabicButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        default:
            break
        }
    }
    
    func loadUserDetails() {
        if let user = UserSessionManager.getUser() {
            personNameLabel.isHidden = false
            personEmailLabel.isHidden = false
            loginbutton.isHidden = true
            profileImgView.isHidden = false
            rightArrow.isHidden = false
            personNameLabel.text = user.name
            personEmailLabel.text = user.email
            topViewHeightConstraint.constant = 150
        } else {
            personNameLabel.isHidden = true
            personEmailLabel.isHidden = true
            loginbutton.isHidden = false
            profileImgView.isHidden = true
            rightArrow.isHidden = true
            topViewHeightConstraint.constant = 75
        }
    }
    
    @objc func LeftMenuReload() {
        LeftMenuUITableView.reloadData()
    }
}
