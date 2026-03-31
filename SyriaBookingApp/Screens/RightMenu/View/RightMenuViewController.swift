//
//  RightMenuViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import UIKit
import SafariServices

class RightMenuViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var rightMenuTableView: UITableView!
    
    var menuArray = [String]()
    var barbuttonItem: UIBarButtonItem?
    var navnController: UINavigationController?
    var sourceView: UIView?
    var sourceRect: CGRect?
    var contentSize: CGSize?
    var popoverdirection: UIPopoverArrowDirection = .any
    var profileViewModle = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rightMenuTableView.applyCardStyle()
        rightMenuTableView.semanticContentAttribute = .forceLeftToRight
        rightMenuTableView.rowHeight = UITableView.automaticDimension
        rightMenuTableView.estimatedRowHeight = 50
        let rowHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 44.0 : 51.0
        rightMenuTableView.rowHeight = rowHeight
        
        updateMenuTitles()
    }
    
    @objc func updateMenuTitles() {
        let lang = AppSettings.shared.selectedLanguage
        
        if lang == .arabic {
            menuArray = [
                "الأسئلة الشائعة",
                "سياسة الخصوصية",
                "الشروط والأحكام",
                "معلومات عنا",
                "الإبلاغ عن تطبيق",
                UserSessionManager.getUser() != nil ? "الملف الشخصي" : "تسجيل الدخول",
                "تسجيل الخروج",
                "حذف الحساب"
            ]
        } else {
            menuArray = [
                "FAQ",
                "Privacy Policy",
                "Terms & Conditions",
                "About Us",
                "Report an app",
                UserSessionManager.getUser() != nil ? "Profile" : "Login",
                "Logout",
                "Delete Account"
            ]
        }
        
        rightMenuTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backButtonTitle = ""
        updateMenuTitles()
    }
}

extension RightMenuViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rightMenuTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuArray[indexPath.row]
        cell.textLabel?.semanticContentAttribute = .forceLeftToRight
        cell.textLabel?.textAlignment = .left
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let lang = AppSettings.shared.selectedLanguage
        
        guard let indexPath = indexPath else { return }
        
        switch indexPath.row {
        case 0 :
            self.dismiss(animated: true) {
                let controller = UIStoryboard(name: "RightMenu", bundle: nil).instantiateViewController(withIdentifier: "FrequentlyAskedTVCViewControllercopy") as! FrequentlyAskedTVCViewControllercopy
                controller.navigationItem.backButtonTitle = ""
                self.navnController?.pushViewController(controller, animated: true)
            }
        case 1 :
            self.dismiss(animated: true) {
                let controller = UIStoryboard(name: "RightMenu", bundle: nil).instantiateViewController(withIdentifier: "PrivacyAndPolicyVC") as! PrivacyAndPolicyVC
                controller.navigationItem.backButtonTitle = ""
                self.navnController?.pushViewController(controller, animated: true)
            }
        case 2:
            self.dismiss(animated: true) {
                let controller = UIStoryboard(name: "RightMenu", bundle: nil).instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
                controller.navigationItem.backButtonTitle = ""
                self.navnController?.pushViewController(controller, animated: true)
            }
        case 3:
            self.dismiss(animated: true) {
                let storyboard = UIStoryboard(name: "RightMenu", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
                controller.navigationItem.backButtonTitle = ""
                self.navnController?.pushViewController(controller, animated: true)
            }
        case 4 :
            let controller = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ReportAnAppVC") as! ReportAnAppVC
            controller.comingfrom = .RightMenu
            controller.titleText = lang == .arabic ? "الإبلاغ عن تطبيق" : "Report an app"
            controller.modalPresentationStyle = .overFullScreen
            present(controller, animated: true)
        case 5:
            let title = menuArray[indexPath.row]
            if title == "Profile" || title == "الملف الشخصي" {
                self.dismiss(animated: true) {
                    let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "ProfilePageVC") as! ProfilePageVC
                    controller.navigationItem.backButtonTitle = ""
                    self.navnController?.pushViewController(controller, animated: true)
                }
            } else {
                self.dismiss(animated: true) {
                    let storyboard = UIStoryboard(name: "Booking", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "RegisterMobileNumberVC") as! RegisterMobileNumberVC
                    controller.modalPresentationStyle = .overFullScreen
                    controller.transitioningDelegate = self
                    controller.reloadScreenAfterDismiss = {
                        self.goToHomeTab()
                    }
                    self.navnController?.present(controller, animated: true)
                }
            }
        case 6 :
            // Logout alert with Arabic localization
            let title = lang == .arabic ? "سيريا بوكينغ" : "SyriaBooking"
            let message = lang == .arabic ? "هل أنت متأكد أنك تريد تسجيل الخروج؟" : "Are you sure you want to logout?"
            let okTitle = lang == .arabic ? "نعم" : "Ok"
            let cancelTitle = lang == .arabic ? "إلغاء" : "Cancel"
            
            showAlert(title: title, message: message, type: .error, OkButtonTitle: okTitle, cancelButtonTitle: cancelTitle, onOK: {
                UserSessionManager.clearUser()
                NotificationCenter.default.post(
                    name: .didLogoutSuccessfully,
                    object: nil
                )
                self.navigateToHomeTab()
            })
        case 7:
            self.showDeleteAccountOptions()
        default :
            break
        }
    }
}

extension RightMenuViewController: UIPopoverPresentationControllerDelegate {
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        if self.barbuttonItem != nil {
            popoverPresentationController.barButtonItem = barbuttonItem
        } else {
            popoverPresentationController.sourceRect = self.sourceRect ?? CGRect.zero
        }
        popoverPresentationController.permittedArrowDirections = .up
        popoverPresentationController.sourceView = self.sourceView
        preferredContentSize = self.contentSize ?? CGSize(width: 210, height: 300)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}

extension RightMenuViewController{
    func showDeleteAccountOptions() {
        let lang = AppSettings.shared.selectedLanguage
        
        let title = lang == .arabic ? "حذف الحساب" : "Delete Account"
        let message = lang == .arabic ? "اختر خياراً لحذف حسابك" : "Choose an option to delete your account."
        let deleteTitle = lang == .arabic ? "حذف الحساب" : "Delete Account"
        let requestTitle = lang == .arabic ? "طلب حذف الحساب" : "Request to Delete Account"
        let cancelTitle = lang == .arabic ? "إلغاء" : "Cancel"
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: deleteTitle, style: .destructive, handler: { _ in
            self.confirmPermanentDeletion()
        }))
        
        alert.addAction(UIAlertAction(title: requestTitle, style: .default, handler: { _ in
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "AccountDeletionVC") as! AccountDeletionVC
            self.present(controller, animated: true)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        present(alert, animated: true)
    }
    
    private func confirmPermanentDeletion() {
        let lang = AppSettings.shared.selectedLanguage
        
        let title = lang == .arabic ? "هل أنت متأكد؟" : "Are you sure?"
        let message = lang == .arabic ? "سيؤدي هذا إلى حذف حسابك وجميع البيانات المرتبطة به بشكل دائم." : "This will permanently delete your account and all related data."
        let confirmTitle = lang == .arabic ? "نعم، احذف" : "Yes, Delete"
        let cancelTitle = lang == .arabic ? "إلغاء" : "Cancel"
        
        let confirmAlert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        confirmAlert.addAction(UIAlertAction(title: confirmTitle, style: .destructive, handler: { _ in
            self.callDeleteAccountAPI()
        }))
        
        confirmAlert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        present(confirmAlert, animated: true)
    }
    
    private func callDeleteAccountAPI() {
        let lang = AppSettings.shared.selectedLanguage
        
        if let user = UserSessionManager.getUser() {
            let usermobile = "\(user.mobile)-Block"
            let useremail = "\(user.email)-Block"
            
            let deleteUser = BookingModel(id: user.id, name: user.name, mobile: usermobile, address: user.address, gender: user.gender, email: useremail, country: user.country, dob: user.dob)
            
            let successTitle = lang == .arabic ? "نجاح" : "Success"
            let failTitle = lang == .arabic ? "فشل" : "Fail"
            let successMessage = lang == .arabic ? "تم حذف حسابك بنجاح." : "Your account has been deleted successfully."
            let failMessage = lang == .arabic ? "حدث خطأ ما" : "Something went wrong"
            
            if user.mobile == "90000000" {
                self.showAlert(
                    title: successTitle,
                    message: successMessage,
                    type: .success,
                    onOK: {
                        UserSessionManager.clearUser()
                        self.goToHomeTab()
                    }
                )
            }else{
                profileViewModle.updateProfile(userId: user.id, profile: deleteUser)
                profileViewModle.onProfileUpdated = { result, message, bookingModel in
                    if result {
                        //account deleted
                        self.showAlert(
                            title: successTitle,
                            message: successMessage,
                            type: .success,
                            onOK: {
                                UserSessionManager.clearUser()
                                self.goToHomeTab()
                            }
                        )
                    }else{
                        self.showAlert(
                            title: failTitle,
                            message: failMessage,
                            type: .error,
                            onOK: {}
                        )
                    }
                }
            }
        }
    }
}

extension RightMenuViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true) {
            self.goToHomeTab()
        }
    }
}
