//
//  CustomTabBarController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 01/08/25.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var selectionIndicatorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
        
        setUpTabBarAppearance()
        setupSelectionIndicator()
        updateTabBarTitles()
        
        DispatchQueue.main.async {
            self.updateTabBarSelectionAppearance()
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTabBarTitles),
            name: .languageChanged,
            object: nil
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSelectionIndicatorPosition()
    }
    
    override func overrideTraitCollection(
        forChild childViewController: UIViewController
    ) -> UITraitCollection? {
        if #available(iOS 18.0, *), UIDevice.current.userInterfaceIdiom == .pad {
            return UITraitCollection(horizontalSizeClass: .compact)
        }
        return super.overrideTraitCollection(forChild: childViewController)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if #available(iOS 18.0, *), UIDevice.current.userInterfaceIdiom == .pad {
            self.setOverrideTraitCollection(UITraitCollection(horizontalSizeClass: .compact), forChild: self)
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.updateSelectionIndicatorPosition()
        })
    }
    
    private func setUpTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.stackedLayoutAppearance.normal.iconColor = .lightGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 11, weight: .regular)
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold)
        ]
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.layer.borderWidth = 0
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.clipsToBounds = false
        tabBar.layer.shadowColor = UIColor.white.withAlphaComponent(0.1).cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        tabBar.layer.shadowRadius = 2
        tabBar.layer.shadowOpacity = 0.5
    }
    
    private func setupSelectionIndicator() {
        selectionIndicatorView = UIView()
        selectionIndicatorView.backgroundColor = .white
        selectionIndicatorView.layer.cornerRadius = 2
        selectionIndicatorView.layer.masksToBounds = true
        selectionIndicatorView.layer.shadowColor = UIColor.white.cgColor
        selectionIndicatorView.layer.shadowOffset = CGSize(width: 0, height: 0)
        selectionIndicatorView.layer.shadowRadius = 3
        selectionIndicatorView.layer.shadowOpacity = 0.5
        
        tabBar.addSubview(selectionIndicatorView)
    }
    
    private func updateSelectionIndicatorPosition() {
        guard let items = tabBar.items, items.count > 0 else { return }
        
        let tabWidth = tabBar.frame.width / CGFloat(items.count)
        let indicatorWidth: CGFloat = 30
        let indicatorHeight: CGFloat = 3
        let selectionX = tabWidth * CGFloat(selectedIndex) + (tabWidth - indicatorWidth) / 2
        let selectionY: CGFloat = 0
        
        selectionIndicatorView.frame = CGRect(x: selectionX,
                                              y: selectionY,
                                              width: indicatorWidth,
                                              height: indicatorHeight)
    }
    
    func updateTabBarSelectionAppearance() {
        guard let items = tabBar.items else { return }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            self.updateSelectionIndicatorPosition()
        }
        
        for (index, item) in items.enumerated() {
            if index == selectedIndex {
                item.setTitleTextAttributes([
                    .foregroundColor: UIColor.white,
                    .font: UIFont.systemFont(ofSize: 11, weight: .semibold)
                ], for: .normal)
                
                if let view = self.tabBarButton(at: index) {
                    let animation = CAKeyframeAnimation(keyPath: "transform.scale")
                    animation.values = [1.0, 1.1, 1.0]
                    animation.keyTimes = [0, 0.5, 1]
                    animation.duration = 0.25
                    view.layer.add(animation, forKey: "bounceAnimation")
                }
            } else {
                item.setTitleTextAttributes([
                    .foregroundColor: UIColor.lightGray,
                    .font: UIFont.systemFont(ofSize: 11, weight: .regular)
                ], for: .normal)
            }
        }
    }
    
    private func tabBarButton(at index: Int) -> UIView? {
        let tabBarButtons = tabBar.subviews.filter {
            String(describing: type(of: $0)) == "UITabBarButton"
        }.sorted {
            $0.frame.origin.x < $1.frame.origin.x
        }
        
        guard index < tabBarButtons.count else { return nil }
        return tabBarButtons[index]
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
        
        updateTabBarSelectionAppearance()
    }
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        UIApplication.topViewController()?.dismissPopup(ofType: ReportAnAppVC.self)
        updateTabBarSelectionAppearance()
    }
}

extension CustomTabBarController: YourNotificationVCDelegate {
    func yourNotificationDidRequestTabSwitch(to index: Int) {
        print("Delegate called, switching to tab \(index)")
        self.selectedIndex = index
        updateTabBarSelectionAppearance()
    }
}


