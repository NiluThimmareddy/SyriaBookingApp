//
//  SustainabilityViewController.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 26/03/26.
//

import UIKit

class SustainabilityViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var insideScrollView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var sustainabilityImageView: UIImageView!
    @IBOutlet weak var sustainabilityTitleLabel: UILabel!
    @IBOutlet weak var supportResponsibleLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var atSyriaBookingSYLabel: UILabel!
    @IBOutlet weak var ourCommitmentLabel: UILabel!
    @IBOutlet weak var promotingEcoFriendlyLabel: UILabel!
    @IBOutlet weak var weActivelyHighlightLabel: UILabel!
    @IBOutlet weak var useRenewableEnergyLabel: UILabel!
    @IBOutlet weak var minimizeSingleUseLabel: UILabel!
    @IBOutlet weak var implementWasteReductionLabel: UILabel!
    @IBOutlet weak var conserveWaterLabel: UILabel!
    @IBOutlet weak var lookForEcoStayBadgeLabel: UILabel!
    @IBOutlet weak var supportingLocalCommunitiesLabel: UILabel!
    @IBOutlet weak var byConnectingTravelersLabel: UILabel!
    @IBOutlet weak var encounteringResponsibleTravelLabel: UILabel!
    @IBOutlet weak var weEducateOurUsersLabel: UILabel!
    @IBOutlet weak var respectLocalTraditionsLabel: UILabel!
    @IBOutlet weak var chooseLowImpactTransportationLabel: UILabel!
    @IBOutlet weak var avoidOverTourismLabel: UILabel!
    @IBOutlet weak var leavePlacesBetterLabel: UILabel!
    @IBOutlet weak var empoweringHotelsLabel: UILabel!
    @IBOutlet weak var weWorkWithOurHotelPartnersLabel: UILabel!
    @IBOutlet weak var switchingToEnergyLabel: UILabel!
    @IBOutlet weak var offeringReusableAmenitiesLabel: UILabel!
    @IBOutlet weak var reducingFoodWasteLabel: UILabel!
    @IBOutlet weak var trainingStaffOnSustainabilityLabel: UILabel!
    @IBOutlet weak var letsBuildABetterFutureLabel: UILabel!
    @IBOutlet weak var everyBookingMadeThroughSyriaBookingLabel: UILabel!
    @IBOutlet weak var toGetherLetsPreserveLabel: UILabel!
    @IBOutlet weak var followLinksView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSocialMediaView()
        everyBookingMadeThroughSyriaBookingLabel.clipsToBounds = true
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
