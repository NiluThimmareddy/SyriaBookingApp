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
            // Move to FAQ
            break
        case 1 :
            //Move to Privacy Policy
            break
        case 2:
            
            //Move to Terms and Condition
            break
        case 3:
            //About us
            break
        case 4 :
                // Contact us
            break
       
            
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
