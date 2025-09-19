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
        configureLanguage()
        NotificationCenter.default.addObserver(
            self,selector: #selector(LeftMenuReload),name: .languageChanged,object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backButtonTitle = ""
        updateLanguageButtonTitle()
        loadUserDetails()
    }
    
    @IBAction func DismissButtonAction(_ sender: UIButton) {
        onDismiss?()
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "RegisterMobileNumberVC") as? RegisterMobileNumberVC else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        controller.reloadScreenAfterDismiss = {
            self.viewDidLoad()
            self.viewWillAppear(true)
        }
        self.showPopup(controller, widthMultiplier: 0.9, heightMultiplier: 0.3)
    }

    @IBAction func rightArrowButtonAction(_ sender: Any) {
    }
    
    @IBAction func languagesButtonAction(_ sender: Any) {
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
            let controller = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HotelListViewController") as! HotelListViewController
            controller.comingFrom = .tabBar
            self.navigationController?.pushViewController(controller, animated: true)
        case 1 :
            let controller = storyboard?.instantiateViewController(withIdentifier: "CareersVC") as! CareersVC
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(controller, animated: true)
        case 2:
            let controller = storyboard?.instantiateViewController(withIdentifier: "HowItsWorkVC") as! HowItsWorkVC
            self.navigationController?.pushViewController(controller, animated: true)
        case 3:
            let controller = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MyBookingsViewController") as! MyBookingsViewController
            self.navigationController?.pushViewController(controller, animated: true)
        case 4:
            let controller = storyboard?.instantiateViewController(withIdentifier: "Covid19FAQsVC") as! Covid19FAQsVC
            self.navigationController?.pushViewController(controller, animated: true)
        case 5:
            let controller = storyboard?.instantiateViewController(withIdentifier: "SustainabilityVC") as! SustainabilityVC
            self.navigationController?.pushViewController(controller, animated: true)
        case 6:
            let controller = storyboard?.instantiateViewController(withIdentifier: "SafetyResourceCenterVC") as! SafetyResourceCenterVC
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
        
        [backView,topView].forEach { shadow in
            shadow?.applyCardStyle()
            shadow?.layer.cornerRadius = 20
            shadow?.layer.maskedCorners = [.layerMaxXMinYCorner]
        }
        LeftMenuUITableView.register(UINib(nibName: "LeftMenuTVC", bundle: nil), forCellReuseIdentifier: "LeftMenuTVC")
        
        languageButton.applyTopRightLightGreyGradient()
        configureLanguage()
    }
    
    func configureLanguage() {
        let menuItems = languages.map { language in
            UIAction(title: language) { [weak self] _ in
                guard let self = self else { return }
                
                switch language {
                case "English":
                    AppSettings.shared.selectedLanguage = .english
                case "العربية":
                    AppSettings.shared.selectedLanguage = .arabic
                default: break
                }

                NotificationCenter.default.post(name: .languageChanged, object: nil)
                self.updateLanguageButtonTitle()
            }
        }

        languageButton.menu = UIMenu(title: "", children: menuItems)
        languageButton.showsMenuAsPrimaryAction = true
        
        updateLanguageButtonTitle()
    }

    func updateLanguageButtonTitle() {
        let font = UIFont.boldSystemFont(ofSize: 13)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]

        let selectedLanguage = AppSettings.shared.selectedLanguage
        let title: String

        switch selectedLanguage {
        case .english:
            title = "English"
        case .arabic:
            title = "العربية"
        }

        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        languageButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    func loadUserDetails() {
        if let user = UserSessionManager.getUser() {
            personNameLabel.isHidden = false
            personEmailLabel.isHidden = false
            loginbutton.isHidden = true
            personNameLabel.text = user.name
            personEmailLabel.text = user.email
        } else {
            personNameLabel.isHidden = true
            personEmailLabel.isHidden = true
            loginbutton.isHidden = false
        }
    }
    
    @objc func LeftMenuReload() {
        LeftMenuUITableView.reloadData()
    }
}
