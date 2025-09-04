////
////  CustomTabBarController.swift
////  SyriaBookingApp
////
////  Created by ToqSoft on 01/08/25.
////
//
//import UIKit
//
//class CustomTabBarController: UITabBarController, UITabBarControllerDelegate{
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        guard #available(iOS 18, *), UIDevice.current.userInterfaceIdiom == .pad else {
////            return
////        }
////        
////        traitOverrides.horizontalSizeClass = .compact
//         
////        self.delegate = self
//    }
//    
//
//    // Detect tab switch
//    
//    
////    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
////        
////        // Check if selected tab is at index 2 (third tab)
////        if let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController),
////           selectedIndex == 2,
////           let hotelListVC = viewController as? HotelListViewController,
////           let homeVC = viewController as? HomeViewController {
////            
////            // Pass the data
////            hotelListVC.viewModel = homeVC.viewModel
////        }
////    }
//
//
//   
//}
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
}
 
