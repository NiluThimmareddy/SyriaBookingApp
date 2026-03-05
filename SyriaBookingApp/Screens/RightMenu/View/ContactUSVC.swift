//
//  ContactUSVC.swift
//  NewProject
//
//  Created by Yarramsetti Yedukondalu on 11/08/25.
//

import UIKit

class ContactUSVC: UIViewController {
    
    @IBOutlet weak var contactUsButton: UIButton!
    @IBOutlet weak var contactOurFriendlyExpertsLabel: UILabel!
    @IBOutlet weak var anyQuestionsLabel: UILabel!
    @IBOutlet weak var packYourBagsLabel: UILabel!
    @IBOutlet weak var mailusExperiencedLabel: UILabel!
    @IBOutlet weak var contactUsFormLabel: UILabel!
    
    var comingfrom : comingFromLogin?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar(animated: true)
        updateTexts()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        
        if lang == .english {
            contactOurFriendlyExpertsLabel.text = "Contact Our Friendly Experts Team"
            anyQuestionsLabel.text = "Any questions? We would be happy to help you."
            packYourBagsLabel.text = "Pack your bags and let SyriaBooking redefine your stay."
            mailusExperiencedLabel.text = "Mail our Experienced team here info@syriabooking.sy"
            contactUsFormLabel.text = "Or Fill our Contact us Form"
        } else {
            contactOurFriendlyExpertsLabel.text = "تواصل مع فريق الخبراء الودودين لدينا"
            anyQuestionsLabel.text = "أي أسئلة؟ سنكون سعداء بمساعدتك."
            packYourBagsLabel.text = "احزم حقائبك ودع سيريا بوكينغ تعيد تعريف إقامتك."
            mailusExperiencedLabel.text = "راسل فريقنا المتمرس هنا info@syriabooking.sy"
            contactUsFormLabel.text = "أو املأ نموذج الاتصال بنا"
        }
    }
    
    @IBAction func contactUsButtonAction(_ sender: Any) {
        let storyboard = storyboard?.instantiateViewController(identifier: "ReportAnAppVC") as! ReportAnAppVC
        storyboard.comingfrom = .TabBar
        storyboard.modalPresentationStyle = .custom
        self.present(storyboard, animated: true)
    }
}
