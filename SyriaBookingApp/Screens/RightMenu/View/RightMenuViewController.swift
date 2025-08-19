//
//  RightMenuViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import UIKit

class RightMenuViewController: UIViewController {
    

    @IBOutlet weak var rightMenuTableView: UITableView!
    
    let menuArray = ["FAQ", "Privacy Policy", "Terms and Conditions",   "About Us","Contact Us"]
    
    var barbuttonItem: UIBarButtonItem?
    var navnController: UINavigationController?
    var sourceView: UIView?
    var sourceRect: CGRect?
    var contentSize: CGSize?
    var popoverdirection: UIPopoverArrowDirection = .any
    
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
            guard let controller = storyboard?.instantiateViewController(withIdentifier: "ContactUSVC") as? ContactUSVC else { return }
            if let sheet = controller.sheetPresentationController {
                let customDetentHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 0.25 : 0.4
                
                let customDetent = UISheetPresentationController.Detent.custom(identifier: .medium) { context in
                    return context.maximumDetentValue * customDetentHeight
                }
                
                sheet.detents = [
                    customDetent,
                    .large()
                ]
                sheet.selectedDetentIdentifier = .medium
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 20
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    sheet.largestUndimmedDetentIdentifier = .medium
                    controller.preferredContentSize = CGSize(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height * 0.6
                    )
                }
            }
            
            controller.modalPresentationStyle = .pageSheet
            present(controller, animated: true)
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
