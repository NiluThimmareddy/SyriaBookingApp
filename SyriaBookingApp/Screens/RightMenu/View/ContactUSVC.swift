//
//  ContactUSVC.swift
//  NewProject
//
//  Created by Yarramsetti Yedukondalu on 11/08/25.
//

import UIKit

class ContactUSVC: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var designView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.layer.cornerRadius = 15
        designView.layer.cornerRadius = 15
        uiView.layer.cornerRadius = 15
        
    }
    

    @IBAction func continueButtonAction(_ sender: Any) {
    }

}
