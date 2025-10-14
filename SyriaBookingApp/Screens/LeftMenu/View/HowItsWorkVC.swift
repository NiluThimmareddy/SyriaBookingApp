//
//  HowItsWorkVC.swift
//  NewProject
//
//  Created by Yarramsetti Yedukondalu on 06/08/25.
//

import UIKit
import WebKit

class HowItsWorkVC: UIViewController {
    
   
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet var answerLabel: [UILabel]!
    
    @IBOutlet var QuestinosLabel: [UILabel]!
    
    weak var delegate: YourNotificationVCDelegate?
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupFontForLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
      
    }
    
    func setupFontForLabel(){
        descriptionLabel.font = .captionFont
        for q in QuestinosLabel {
            q.font = .titleFont
        }
        
        for a in answerLabel {
            a.font = .bodyFont
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
   
    
}
