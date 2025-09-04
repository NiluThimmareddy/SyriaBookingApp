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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.layer.cornerRadius = 10
        topView.addBottomShadow()
        setupRatingDropdownMenu()
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
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
