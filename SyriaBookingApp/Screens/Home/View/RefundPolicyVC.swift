//
//  RefundPolicyVC.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 24/10/25.
//

import UIKit

class RefundPolicyVC: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var refundPolicyTypeLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var refundLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }

    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
