//
//  ContactUSVC.swift
//  NewProject
//
//  Created by Yarramsetti Yedukondalu on 11/08/25.
//

import UIKit

class ContactUSVC: UIViewController {
    
    @IBOutlet weak var contactUsButton: UIButton!
   
    var comingfrom : comingFromLogin?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar(animated: true)
    }
    
    @IBAction func contactUsButtonAction(_ sender: Any) {
        let storyboard = storyboard?.instantiateViewController(identifier: "ReportAnAppVC") as! ReportAnAppVC
        storyboard.comingfrom = .TabBar
        storyboard.modalPresentationStyle = .custom
        self.present(storyboard, animated: true)
    }
}
