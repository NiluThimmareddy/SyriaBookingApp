//
//  AboutUSViewController.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 25/03/26.
//

import UIKit

class AboutUSViewController: UIViewController {

   
    @IBOutlet weak var aboutUsTitleLabel: UILabel!
    @IBOutlet weak var redefiningDescriptionLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var hotelBookingSystemLabel: UILabel!
    @IBOutlet weak var yourTrustedPartnerLabel: UILabel!
    @IBOutlet weak var atSyriaBookingSYLabel: UILabel!
    @IBOutlet weak var whatWeOfferLabel: UILabel!
    @IBOutlet weak var questionOneLabel: UILabel!
    @IBOutlet weak var questionTwoLabel: UILabel!
    
    @IBOutlet weak var followLinksView: UIView!
    @IBOutlet weak var aboutUsImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSocialMediaView()
        aboutUsImageView.applyFullLightBlackGradientOverlay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
    }
    
    private func setupSocialMediaView() {
        let nib = UINib(nibName: "SocialMedia", bundle: nil)
        guard let socialView = nib.instantiate(withOwner: nil, options: nil).first as? SocialMediaView else {
            return
        }

        followLinksView.addSubview(socialView)

        socialView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            socialView.topAnchor.constraint(equalTo: followLinksView.topAnchor),
            socialView.bottomAnchor.constraint(equalTo: followLinksView.bottomAnchor),
            socialView.leadingAnchor.constraint(equalTo: followLinksView.leadingAnchor),
            socialView.trailingAnchor.constraint(equalTo: followLinksView.trailingAnchor)
        ])
    }

}
