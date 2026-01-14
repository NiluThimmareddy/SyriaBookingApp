//
//  CareerApplicationVC.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 12/01/26.
//

import UIKit

class CareerApplicationVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var insideScrollView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var fullNameLabel: UITextField!
    @IBOutlet weak var emailIdLabel: UITextField!
    @IBOutlet weak var phoneNumberLabel: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var positionAppliedTF: UITextField!
    @IBOutlet weak var coverMessageTextView: UITextView!
    @IBOutlet weak var chooseFileButton: UIButton!
    @IBOutlet weak var captchaLabel: UILabel!
    @IBOutlet weak var enterCaptchaTF: UITextField!
    @IBOutlet weak var submitApplicationButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var selectedFileLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func chooseFileButtonAction(_ sender: Any) {
    }
    
    @IBAction func submitApplicationButtonAction(_ sender: Any) {
        
    }
    
    
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
