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
private var notificationViewModelKey: UInt8 = 0

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
        DispatchQueue.main.async {
            guard self.defaultActivityIndicator == nil else { return } // Already showing
            
            let indicator = UIActivityIndicatorView(style: style)
            indicator.hidesWhenStopped = true
            indicator.color = .gray
            indicator.startAnimating()
            
            // Dim background
            let backgroundView = UIView(frame: self.view.bounds)
            backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.2)
            backgroundView.tag = 9999
            backgroundView.addSubview(indicator)
            indicator.center = backgroundView.center
            
            self.view.addSubview(backgroundView)
            self.defaultActivityIndicator = indicator
        }
    }

    
    func hideLoader() {
        DispatchQueue.main.async {
            self.defaultActivityIndicator?.stopAnimating()
            self.view.viewWithTag(9999)?.removeFromSuperview()
            self.defaultActivityIndicator = nil
        }
    }
    
    func hideNavigationBar(animated: Bool = true) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func showNavigationBar(animated: Bool = true) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension UIViewController {
    static var notificationVCReference: YourNotificationVC?
    func setupAppNavigationBar() {
        let viewModel = NotificationViewModel()
        self.notificationViewModel = viewModel
        let logoImageView = UIImageView(image: UIImage(named: "logo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.frame = CGRect(x: -20, y: 0, width: 130, height: 40)
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 130, height: 40))
        containerView.addSubview(logoImageView)
        navigationItem.titleView = containerView
        
        var rightButtons: [UIBarButtonItem] = []
        if self is HomeViewController {
            let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                               style: .plain,
                                               target: self,
                                               action: #selector(didTapSearch))
            rightButtons.append(searchButton)
        }
        
        let badgeButton = BadgeButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        badgeButton.setImage(UIImage(systemName: "bell.fill"), for: .normal)
        badgeButton.addTarget(self, action: #selector(didTapNotification), for: .touchUpInside)
        let notificationButton = UIBarButtonItem(customView: badgeButton)
        
        
        let menuImage = UIImage(systemName: "ellipsis")?.rotate(radians: .pi / 2)
        let menuButton = UIBarButtonItem(image: menuImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(didTapMenu(_:)))

        if let user = UserSessionManager.getUser() {
            viewModel.onCountSuccess = { data in
                print("Count: \(data.count)")
                badgeButton.badge = data.count
            }
            
            viewModel.onError = { error in
                print("Notification count error")
                print(error)
            }
            
            viewModel.fetchNotificationCount(userId: user.id)
            rightButtons.insert(notificationButton, at: 0)
            rightButtons.insert(menuButton, at: 0)
            navigationItem.rightBarButtonItems = rightButtons
        } else {
            rightButtons.insert(menuButton, at: 0)
            navigationItem.rightBarButtonItems = rightButtons
        }
    }
    
    @objc func didTapSearch(_ sender: UIBarButtonItem) {
    }
    
    @objc func didTapNotification(_ sender: UIBarButtonItem) {
        if let existingVC = UIViewController.notificationVCReference {
            existingVC.dismiss(animated: true) {
                UIViewController.notificationVCReference = nil
            }
        } else {
            guard let notificationVC = storyboard?.instantiateViewController(withIdentifier: "YourNotificationVC") as? YourNotificationVC else {
                return
            }
            notificationVC.modalPresentationStyle = .overCurrentContext
            notificationVC.modalTransitionStyle = .crossDissolve
            
            if let tabBarController = self.tabBarController as? YourNotificationVCDelegate {
                notificationVC.delegate = tabBarController
            } else if let delegateSelf = self as? YourNotificationVCDelegate {
                notificationVC.delegate = delegateSelf
            } else {
                print("WARNING: No delegate set for YourNotificationVC")
            }
            present(notificationVC, animated: true) {
                UIViewController.notificationVCReference = notificationVC
            }
        }
    }
    
    @objc func didTapMenu(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name: "RightMenu", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "RightMenuViewController") as? RightMenuViewController {
            
            controller.modalPresentationStyle = .popover
            controller.navnController = self.navigationController
            
            
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

extension UIViewController {
    var notificationViewModel: NotificationViewModel? {
        get {
            return objc_getAssociatedObject(self, &notificationViewModelKey) as? NotificationViewModel
        }
        set {
            objc_setAssociatedObject(self, &notificationViewModelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIViewController {
    
    func showPopup(_ childVC: UIViewController,
                   widthMultiplier: CGFloat = 0.85,
                   heightMultiplier: CGFloat = 0.6,
                   cornerRadius: CGFloat = 16,
                   withDim: Bool = true) {
        
        // 🔑 Remove existing popup first
        dismissPopup()
        
        // --- Add child relationship ---
        addChild(childVC)
        
        var dimView: UIView?
        if withDim {
            let dim = UIView(frame: view.bounds)
            dim.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            dim.tag = 9999
            dim.isUserInteractionEnabled = true
            view.addSubview(dim)
            dimView = dim
            
            // Tap outside to dismiss
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
            dim.addGestureRecognizer(tapGesture)
        }
        
        // --- Popup View ---
        let popupView = childVC.view!
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.layer.cornerRadius = cornerRadius
        popupView.clipsToBounds = true
        popupView.alpha = 0.0
        popupView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        view.addSubview(popupView)
        
        NSLayoutConstraint.activate([
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthMultiplier),
            popupView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightMultiplier)
        ])
        
        childVC.didMove(toParent: self)
        
        // --- Animate in ---
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut,
                       animations: {
            dimView?.backgroundColor = UIColor.black.withAlphaComponent(withDim ? 0.5 : 0.0)
            popupView.alpha = 1.0
            popupView.transform = .identity
        }, completion: nil)
    }
    
    /// Dismiss currently shown popup
    @objc func dismissPopup() {
        guard let popupVC = children.last else { return }
        let popupView = popupVC.view!
        let dimView = view.viewWithTag(9999)
        
        UIView.animate(withDuration: 0.25, animations: {
            dimView?.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            popupView.alpha = 0.0
            popupView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            dimView?.removeFromSuperview()
            popupVC.willMove(toParent: nil)
            popupView.removeFromSuperview()
            popupVC.removeFromParent()
            
            // ✅ Make sure touches are re-enabled
            self.view.isUserInteractionEnabled = true
        })
    }
    
    /// Dismiss popup of specific type
    func dismissPopup<T: UIViewController>(ofType type: T.Type) {
        if let popup = children.first(where: { $0 is T }) {
            popup.willMove(toParent: nil)
            popup.view.removeFromSuperview()
            popup.removeFromParent()
        }
        
        if let dimView = view.viewWithTag(9999) {
            dimView.removeFromSuperview()
        }
        
        //  Re-enable interaction just in case
        self.view.isUserInteractionEnabled = true
    }
    
    func expandPopupToFullScreen(_ childVC: UIViewController) {
        guard let popupView = childVC.view else { return }
        
        // Remove old constraints
        view.constraints.forEach { constraint in
            if constraint.firstItem as? UIView == popupView || constraint.secondItem as? UIView == popupView {
                view.removeConstraint(constraint)
            }
        }
        // Add fullscreen constraints
        NSLayoutConstraint.activate([
            popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            popupView.topAnchor.constraint(equalTo: view.topAnchor),
            popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func calculateTotalNights(checkIn: String?, checkOut: String?) -> Int {
        guard let checkIn = checkIn, let checkOut = checkOut else { return 0 }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        guard let inDate = formatter.date(from: checkIn),
              let outDate = formatter.date(from: checkOut) else { return 0 }
        return Calendar.current.dateComponents([.day], from: inDate, to: outDate).day ?? 0
    }
}
