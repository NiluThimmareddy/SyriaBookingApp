//
//  LanguageVC.swift
//  SyriaBookingApp
//
//  Created by Yarramsetti Yedukondalu on 01/09/25.
//

//
//import UIKit
//
//class LanguageVC: UIViewController {
//    @IBOutlet weak var designUiView: UIView!
//    @IBOutlet weak var arbicLanguageButton: UIButton!
//    @IBOutlet weak var englishLanguageButton: UIButton!
//    @IBOutlet weak var selectedLanguageButton: UIButton! // not really needed, unless you want default
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupButtons()
//        setupPopupDesign()
//    }
//    private func setupPopupDesign() {
//           // Rounded corners
//           designUiView.layer.cornerRadius = 20
//           designUiView.layer.masksToBounds = true
//           
//           // Shadow for popup
//           designUiView.layer.shadowColor = UIColor.black.cgColor
//           designUiView.layer.shadowOpacity = 0.2
//           designUiView.layer.shadowOffset = CGSize(width: 0, height: 4)
//           designUiView.layer.shadowRadius = 8
//           
//           // Background
//           designUiView.backgroundColor = .systemBackground
//       }
//    private func setupButtons() {
//        englishLanguageButton.setImage(UIImage(systemName: "circle"), for: .normal)
//        arbicLanguageButton.setImage(UIImage(systemName: "circle"), for: .normal)
//    }
//    
//    @IBAction func englishSelected(_ sender: UIButton) {
//        AppSettings.shared.selectedLanguage = .english
//        englishLanguageButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
//        arbicLanguageButton.setImage(UIImage(systemName: "circle"), for: .normal)
//        
//       
//    }
//    
//    @IBAction func arabicSelected(_ sender: UIButton) {
//        AppSettings.shared.selectedLanguage = .arabic
//        arbicLanguageButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
//        englishLanguageButton.setImage(UIImage(systemName: "circle"), for: .normal)
//        
//       
//    }
//}
import UIKit

class LanguageVC: UIViewController {
    @IBOutlet weak var designUiView: UIView!
    @IBOutlet weak var arbicLanguageButton: UIButton!
    @IBOutlet weak var englishLanguageButton: UIButton!
    @IBOutlet weak var selectedLanguageButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopupDesign()
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSelectedLanguageUI()
    }
    
    private func setupPopupDesign() {
        designUiView.layer.cornerRadius = 20
        designUiView.layer.masksToBounds = true
        designUiView.layer.shadowColor = UIColor.black.cgColor
        designUiView.layer.shadowOpacity = 0.2
        designUiView.layer.shadowOffset = CGSize(width: 0, height: 4)
        designUiView.layer.shadowRadius = 8
        designUiView.backgroundColor = .systemBackground
    }
    
    private func setupButtons() {
        englishLanguageButton.setTitle(" English", for: .normal)
        arbicLanguageButton.setTitle(" Arabic", for: .normal)
        englishLanguageButton.tintColor = .systemBlue
        arbicLanguageButton.tintColor = .systemBlue
    }
    
    private func updateSelectedLanguageUI() {
        if AppSettings.shared.selectedLanguage == .english {
            englishLanguageButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            arbicLanguageButton.setImage(UIImage(systemName: "circle"), for: .normal)
        } else {
            arbicLanguageButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            englishLanguageButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    
    @IBAction func doneDismissButton(_ sender: UIButton) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }

    @IBAction func englishSelected(_ sender: UIButton) {
        AppSettings.shared.selectedLanguage = .english
       
        NotificationCenter.default.post(name: .languageChanged, object: nil)
        updateSelectedLanguageUI()
    }
    
    @IBAction func arabicSelected(_ sender: UIButton) {
        AppSettings.shared.selectedLanguage = .arabic
        updateSelectedLanguageUI()
        NotificationCenter.default.post(name: .languageChanged, object: nil)
       
    }
}
