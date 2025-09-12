//
//  CustomTabBarController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 01/08/25.
//

import UIKit
 
class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        // ✅ Force bottom tab bar on iPad (iOS 18+)
//        if #available(iOS 18.0, *), UIDevice.current.userInterfaceIdiom == .pad {
//            self.traitOverrides.horizontalSizeClass = .compact
//        }
// 
        // ✅ Setup TabBar appearance
        setUpTabBarAppearance()
 
        updateTabBarTitles()
 
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTabBarTitles),
            name: .languageChanged,
            object: nil
        )
    }
 
    // MARK: - Setup TabBar UI
    private func setUpTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
 
        appearance.stackedLayoutAppearance.normal.iconColor = .white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
 
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
 
    @objc func updateTabBarTitles() {
        if AppSettings.shared.selectedLanguage == .english {
            tabBar.items?[0].title = "Home"
            tabBar.items?[1].title = "Bookings"
            tabBar.items?[2].title = "Filter List"
            tabBar.items?[3].title = "Contact Us"
        } else {
            tabBar.items?[0].title = "الرئيسية"
            tabBar.items?[1].title = "الحجوزات"
            tabBar.items?[2].title = "قائمة التصفية"
            tabBar.items?[3].title = "اتصل بنا"
        }
    }
    
  
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        
        if let nav = viewController as? UINavigationController,
           nav.topViewController is ReportAnAppVC {
            
            // ✅ Get current visible VC
            if let topVC = UIApplication.topViewController() {
                
                // ✅ Prevent duplicates: check if ReportAnAppVC already added as child
                if topVC.children.contains(where: { $0 is ReportAnAppVC }) {
                    return false
                }
                
                // ✅ Show popup
                if let contactVC = storyboard?.instantiateViewController(withIdentifier: "ReportAnAppVC") as? ReportAnAppVC {
                    topVC.showPopup(contactVC, widthMultiplier: 0.85, heightMultiplier: 0.85)
                }
            }
            
            return false
        }
        
        return true
    }

    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        UIApplication.topViewController()?.dismissPopup(ofType: ReportAnAppVC.self)
    }
}
 
extension CustomTabBarController: YourNotificationVCDelegate {
    func yourNotificationDidRequestTabSwitch(to index: Int) {
        print("Delegate called, switching to tab \(index)")
        self.selectedIndex = index
    }
}
