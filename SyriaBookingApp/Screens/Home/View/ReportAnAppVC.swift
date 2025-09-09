//
//  ReportAnAppVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 04/09/25.
//

import UIKit

class ReportAnAppVC: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var selectSubjectButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var enterMessageTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var topView: UIView!
    var comingfrom  = ""
    var hotelViewModel = HotelViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.layer.cornerRadius = 10
        topView.addBottomShadow()
        setupRatingDropdownMenu()
        
        if comingfrom == "RightMenu"{
            //set subject Complain
           
            self.selectSubjectButton.setTitle("Complaint", for: .normal)
            self.selectSubjectButton.isEnabled = false
        }
    }
    
    func setupRatingDropdownMenu() {
        let starOptions: [String] = ["Feedback","Enquiry","Complaint"]
        
        var actions: [UIAction] = []
        
        for title in starOptions {
            let action = UIAction(title: title, handler: { [weak self] _ in
                self?.selectSubjectButton.setTitle(title, for: .normal)
                
            })
            actions.append(action)
        }

        let menu = UIMenu(title: "Select Subject", children: actions)
        
        selectSubjectButton.showsMenuAsPrimaryAction = true
        selectSubjectButton.menu = menu
    }

    @IBAction func submitButtonAction(_ sender: Any) {
        showLoader()
        
        if let user = UserSessionManager.getUser() {
            
            guard let subject = selectSubjectButton.titleLabel?.text else{
                showAlert("please select subject")
                return
            }
            
            guard let message = enterMessageTextView.text else{
                showAlert("please enter message")
                return
            }
            
            hotelViewModel.onReporAnAppSucess = { response in
                self.showAlert(title: "Success", message: response.message, OkButtonTitle: "Ok", onCancel:  {
                    self.willMove(toParent: nil)
                    self.view.removeFromSuperview()
                    self.removeFromParent()
                })
                
            }
            
            hotelViewModel.submitReporAnApp(subject:subject, message: message, userName: user.name, UserEmail: user.email, userPhone: user.mobile)
        }
        
        
    }
    
    @IBAction func dismissButton(_ sender: Any) {
      
                // Remove popup from parent
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            
    }
}
