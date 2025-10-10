//
//  RightMenuViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import UIKit
import SafariServices

class RightMenuViewController: UIViewController {
    
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
//        rightMenuTableView.isScrollEnabled = true
        rightMenuTableView.rowHeight = UITableView.automaticDimension
        rightMenuTableView.estimatedRowHeight = 50
        let rowHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 44.0 : 51.0
        rightMenuTableView.rowHeight = rowHeight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backButtonTitle = ""
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
        
        guard let indexPath = indexPath else { return }
        
        switch indexPath.row {
        case 0 :
            let controller = storyboard?.instantiateViewController(withIdentifier: "FrequentlyAskedTVCViewController") as! FrequentlyAskedTVCViewController
//            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true)
        case 1 :
            let controller = storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            present(controller, animated: true)
        case 2:
            let controller = storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionsVC") as! TermsAndConditionsVC
            present(controller, animated: true)
        case 3:
            let controller = storyboard?.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            present(controller, animated: true)
        case 4 :
            let controller = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ReportAnAppVC") as! ReportAnAppVC
            controller.comingfrom = .RightMenu
            controller.titleText = "Report an app"
            present(controller, animated: true)
        case 5 :
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ProfilePageVC") as! ProfilePageVC
            controller.navigationItem.backButtonTitle = ""
            self.navnController?.pushViewController(controller, animated: true)
               
            self.dismiss(animated: true, completion: nil)
        case 6 :
            showAlert(title: "syiabooking", message: "Are you sure want to logout", type: .error, OkButtonTitle: "Ok", cancelButtonTitle: "Cancle", onOK: {
                UserSessionManager.clearUser()
                self.dismiss(animated: true){
                    self.goToHomeTab()
                }
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
        let alert = UIAlertController(
            title: "Delete Account",
            message: "Choose an option to delete your account.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Delete Account", style: .destructive, handler: { _ in
            self.confirmPermanentDeletion()
        }))
        
        alert.addAction(UIAlertAction(title: "Request to Delete Account", style: .default, handler: { _ in
            self.openGoogleSheetForDeletion()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }

    
    private func confirmPermanentDeletion() {
        let confirmAlert = UIAlertController(
            title: "Are you sure?",
            message: "This will permanently delete your account and all related data.",
            preferredStyle: .alert
        )
        
        confirmAlert.addAction(UIAlertAction(title: "Yes, Delete", style: .destructive, handler: { _ in
            self.callDeleteAccountAPI()
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(confirmAlert, animated: true)
    }
    
    private func callDeleteAccountAPI() {
       
        if let user = UserSessionManager.getUser() {
            let usermobile = "\(user.mobile)-Block"
            let useremail = "\(user.email)-Block"
            
            let deleteUser = BookingModel(id: user.id, name: user.name, mobile: usermobile, address: user.address, gender: user.gender, email: useremail, country: user.country, dob: user.dob)
            
            if user.mobile == "90000000" {
                self.showAlert(
                    title: "Success",
                    message: "Your account has been deleted successfully.",
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
                            title: "Success",
                            message: "Your  account has been deleted successfully.",
                            type: .success,
                            onOK: {
                                UserSessionManager.clearUser()
                                self.goToHomeTab()
                            }
                        )
                    }else{
                        self.showAlert(
                            title: "Fail",
                            message: "Somthing went wrong",
                            type: .error,
                            onOK: {}
                        )
                    }
                }
            }
        }
       
    }

    
    private func openGoogleSheetForDeletion() {
        guard let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSdCgN1fhtcpoyD7yqhQIc3SKukItcUEWwWeLj-ytpH_VHn6mw/formResponse") else { return }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        safariVC.dismissButtonStyle = .close
        present(safariVC, animated: true)
    }


}

extension RightMenuViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true) {
            self.goToHomeTab()
        }
    }
    
}

