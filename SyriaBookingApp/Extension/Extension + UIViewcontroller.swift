////
////  Extension.swift
////  SyriaBookingApp
////
////  Created by ToqSoft on 25/07/25.
////
//


import UIKit
import ObjectiveC

private var activityIndicatorKey: UInt8 = 0

extension UIViewController {
    
    private var defaultActivityIndicator: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &activityIndicatorKey) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &activityIndicatorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showLoader(style: UIActivityIndicatorView.Style = .large) {
        guard defaultActivityIndicator == nil else { return } // Already showing
        
        let indicator = UIActivityIndicatorView(style: style)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        indicator.startAnimating()
        
        // Optional: dim background
        let backgroundView = UIView(frame: self.view.bounds)
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        backgroundView.tag = 9999
        backgroundView.addSubview(indicator)
        indicator.center = backgroundView.center
        
        self.view.addSubview(backgroundView)
        defaultActivityIndicator = indicator
    }
    
    func hideLoader() {
        defaultActivityIndicator?.stopAnimating()
        self.view.viewWithTag(9999)?.removeFromSuperview()
        defaultActivityIndicator = nil
    }
    
    func hideNavigationBar(animated: Bool = true) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func showNavigationBar(animated: Bool = true) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension UIViewController {
    func setupAppNavigationBar() {
        let logoImageView = UIImageView(image: UIImage(named: "logo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.frame = CGRect(x: -20, y: 0, width: 130, height: 40)
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 130, height: 40))
        containerView.addSubview(logoImageView)
        navigationItem.titleView = containerView
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(didTapSearch))
        
        let notificationButton = UIBarButtonItem(image: UIImage(systemName: "bell.fill"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(didTapNotification))
        
        let menuImage = UIImage(systemName: "ellipsis")?.rotate(radians: .pi / 2)
        let menuButton = UIBarButtonItem(image: menuImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(didTapMenu(_:)))
        
        navigationItem.rightBarButtonItems = [menuButton, notificationButton, searchButton]
    }
    
    @objc func didTapSearch(_ sender: UIBarButtonItem) {
        print("Search tapped")
        
    }
    
    @objc func didTapNotification(_ sender: UIBarButtonItem) {
        guard let notificationVC = storyboard?.instantiateViewController(withIdentifier: "YourNotificationVC") as? YourNotificationVC else {
            return
        }
        notificationVC.title = "Notification"
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    @objc func didTapMenu(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name: "RightMenu", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "RightMenuViewController") as? RightMenuViewController {
            
            controller.modalPresentationStyle = .popover
            controller.navnController = self.navigationController
            
            
            controller.onDismiss = {
                //Goto Home
                self.view.window?.rootViewController?.dismiss(animated: true) {
                    if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
                        tabBarController.selectedIndex = 0
                        if let navController = tabBarController.viewControllers?.first as? UINavigationController {
                            navController.popToRootViewController(animated: false)
                        }
                    }
                }
            }
            if UserSessionManager.getUser() == nil {
                controller.menuArray = ["FAQ", "Privacy Policy", "Terms and Conditions","About Us", "Roport an App","Profile"]
            }else{
                controller.menuArray = ["FAQ", "Privacy Policy", "Terms and Conditions", "About Us", "Roport an App","Profile","Logout"]
            }
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                controller.contentSize = CGSize(width: 250.0, height: (44.0 * Double(controller.menuArray.count)))
            } else {
                controller.contentSize = CGSize(width: 210.0, height: (51.0 * Double(controller.menuArray.count)))
            }
            
            controller.sourceView = self.view
            controller.barbuttonItem = sender
            
            if let popoverPresentationController = controller.popoverPresentationController {
                popoverPresentationController.delegate = controller
                popoverPresentationController.barButtonItem = sender
                popoverPresentationController.permittedArrowDirections = .any
                popoverPresentationController.sourceView = self.view
                controller.preferredContentSize = controller.contentSize ?? CGSize(width: 200, height: 200)
            }
            
            DispatchQueue.main.async {
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
}
