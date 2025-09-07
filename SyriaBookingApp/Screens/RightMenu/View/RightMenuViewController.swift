//
//  RightMenuViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import UIKit

class RightMenuViewController: UIViewController {
    @IBOutlet weak var rightMenuTableView: UITableView!
    
    var menuArray = [String]()
    
    var barbuttonItem: UIBarButtonItem?
    var navnController: UINavigationController?
    var sourceView: UIView?
    var sourceRect: CGRect?
    var contentSize: CGSize?
    var popoverdirection: UIPopoverArrowDirection = .any
    
    var onDismiss : (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        rightMenuTableView.applyCardStyle()
        
        
    }
}

extension RightMenuViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rightMenuTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        
        guard let indexPath = indexPath else { return }
        
        switch indexPath.row {
        case 0 :
            let controller = storyboard?.instantiateViewController(withIdentifier: "FrequentlyAskedTVCViewController") as! FrequentlyAskedTVCViewController
            controller.modalPresentationStyle = .fullScreen
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
            present(controller, animated: true)
        case 5 :
            let controller = storyboard?.instantiateViewController(withIdentifier: "ProfilePageViewController") as! ProfilePageViewController
            present(controller, animated: true)
        case 6 :
            
            showAlert(title: "syiabooking", message: "Are you sure want to logout", type: .error, OkButtonTitle: "Ok", cancelButtonTitle: "Cancle", onOK: {
                UserSessionManager.clearUser()
                self.dismiss(animated: true){
                    self.onDismiss?()
                }
            }) {
                self.dismiss(animated: true)
            }
          
        default :
            break
        }
    }
    
}

extension RightMenuViewController: UIPopoverPresentationControllerDelegate{
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        if self.barbuttonItem != nil {
            self.popoverPresentationController?.barButtonItem = barbuttonItem
        } else {
            self.popoverPresentationController?.sourceRect = self.sourceRect!
        }
        self.popoverPresentationController?.permittedArrowDirections = []
        self.popoverPresentationController?.sourceView = self.sourceView!
        preferredContentSize = self.contentSize!
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool{
        return true
    }
}
