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
class LeftMenuViewController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var LeftMenuUITableView : UITableView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var personEmailLabel: UILabel!
    @IBOutlet weak var languageButton: UIButton!
    
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

            @objc func LeftMenuReload() {
                LeftMenuUITableView.reloadData()
            }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.backButtonTitle = ""
    }
    
    @IBAction func DismissButtonAction(_ sender: UIButton) {
        onDismiss?()
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
        
        // Icon
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
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        case 1 :
            let controller = storyboard?.instantiateViewController(withIdentifier: "CareersVC") as! CareersVC
            controller.title = "Careers at SyriaBooking.sy"
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        case 2:
            let controller = storyboard?.instantiateViewController(withIdentifier: "HowItsWorkVC") as! HowItsWorkVC
            controller.title = "How It Works"
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        case 3:
            let controller = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MyBookingsViewController") as! MyBookingsViewController
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        case 4:
            let controller = storyboard?.instantiateViewController(withIdentifier: "Covid19FAQsVC") as! Covid19FAQsVC
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        case 5:
            let controller = storyboard?.instantiateViewController(withIdentifier: "SustainabilityVC") as! SustainabilityVC
            controller.title = "Sustainability at SyriaBooking.sy"
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        case 6:
            let controller = storyboard?.instantiateViewController(withIdentifier: "SafetyResourceCenterVC") as! SafetyResourceCenterVC
            controller.title = "Safety Resource Center"
            controller.hidesBottomBarWhenPushed = true
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
    
//    func configureLanguage() {
//        let menuItems = languages.map { language in
//            UIAction(title: language) { [weak self] _ in
//                guard let self = self else { return }
//                self.languageButton.setTitle(language, for: .normal)
//                
//                switch language {
//                case "English":
//                    print("English selected")
//                case "العربية":
//                    print("Arabic selected")
//                default: break
//                }
//            }
//        }
//        
//        languageButton.menu = UIMenu(title: "", children: menuItems)
//        languageButton.showsMenuAsPrimaryAction = true
//    }
    func configureLanguage() {
            let menuItems = languages.map { language in
                UIAction(title: language) { [weak self] _ in
                    guard let self = self else { return }
                    self.languageButton.setTitle(language, for: .normal)
     
                    // Code for changing language
                    switch language {
                    case "English":
                        AppSettings.shared.selectedLanguage = .english
                        self.languageButton.setTitle("English", for: .normal)
                        NotificationCenter.default.post(name: .languageChanged, object: nil)
                        // apply English localization logic
                    case "العربية":
                        AppSettings.shared.selectedLanguage = .arabic
                        self.languageButton.setTitle("العربية", for: .normal)
                        NotificationCenter.default.post(name: .languageChanged, object: nil)
                        // apply Arabic localization logic
                    default: break
                    }
                }
            }
            
            languageButton.menu = UIMenu(title: "", children: menuItems)
            languageButton.showsMenuAsPrimaryAction = true
        }
}
