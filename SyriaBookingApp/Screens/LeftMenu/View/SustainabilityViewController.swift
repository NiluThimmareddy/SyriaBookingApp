//
//  SustainabilityViewController.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 26/03/26.

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
        updateTexts()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        
        if lang == .arabic {
            // Arabic texts
            sustainabilityTitleLabel.text = "الاستدامة في سيريا بوكينغ"
            supportResponsibleLabel.text = "دعم السياحة المسؤولة والضيافة المستدامة في سوريا"
            atSyriaBookingSYLabel.text = "في SyriaBooking.sy، نؤمن بأن السفر يجب أن لا يكون ممتعاً فحسب، بل يجب أن يكون محترماً للبيئة والمجتمعات المحلية والتراث الثقافي. نحن ملتزمون بتعزيز ممارسات السياحة المستدامة التي تعود بالفائدة على المسافرين وسوريا الحبيبة على حد سواء."
            ourCommitmentLabel.text = "التزامنا بمستقبل أكثر اخضراراً"
            promotingEcoFriendlyLabel.text = "الترويج للفنادق الصديقة للبيئة"
            weActivelyHighlightLabel.text = "نحن نسلط الضوء بنشاط ونروج للإقامات التي:"
            useRenewableEnergyLabel.text = "✓ تستخدم الطاقة المتجددة أو ممارسات توفير الطاقة"
            minimizeSingleUseLabel.text = "✓ تقلل من استخدام البلاستيك أحادي الاستخدام"
            implementWasteReductionLabel.text = "✓ تطبق برامج تقليل النفايات وإعادة التدوير"
            conserveWaterLabel.text = "✓ تحافظ على المياه والموارد المحلية"
            lookForEcoStayBadgeLabel.text = "ابحث عن شارة \"إقامة صديقة للبيئة\" على القوائم التي تلبي معايير الاستدامة."
            supportingLocalCommunitiesLabel.text = "دعم المجتمعات المحلية:"
            byConnectingTravelersLabel.text = "✓ من خلال ربط المسافرين بالفنادق المحلية ودور الضيافة، نساعد في ضمان أن السياحة تدعم بشكل مباشر العائلات المحلية والشركات والحرفيين. وهذا يعزز النمو الشامل والحفاظ على الثقافة."
            encounteringResponsibleTravelLabel.text = "تشجيع السفر المسؤول:"
            weEducateOurUsersLabel.text = "نقوم بتثقيف مستخدمينا من خلال النصائح والأدلة السياحية حول كيفية:"
            respectLocalTraditionsLabel.text = "✓ احترام التقاليد والثقافة المحلية"
            chooseLowImpactTransportationLabel.text = "✓ اختيار خيارات النقل منخفضة التأثير"
            avoidOverTourismLabel.text = "✓ تجنب السياحة المفرطة في المناطق الحساسة"
            leavePlacesBetterLabel.text = "✓ ترك الأماكن أفضل مما وجدوها"
            empoweringHotelsLabel.text = "تمكين الفنادق نحو ممارسات أكثر اخضراراً:"
            weWorkWithOurHotelPartnersLabel.text = "نحن نعمل مع شركائنا من الفنادق لتبني تغييرات بسيطة ولكنها مؤثرة، بما في ذلك:"
            switchingToEnergyLabel.text = "✓ التحول إلى إضاءة موفرة للطاقة"
            offeringReusableAmenitiesLabel.text = "✓ تقديم وسائل راحة قابلة لإعادة الاستخدام"
            reducingFoodWasteLabel.text = "✓ تقليل هدر الطعام"
            trainingStaffOnSustainabilityLabel.text = "✓ تدريب الموظفين على معايير الاستدامة"
            letsBuildABetterFutureLabel.text = "دعونا نبني مستقبلاً أفضل معاً"
            everyBookingMadeThroughSyriaBookingLabel.text = "كل حجز يتم من خلال SyriaBooking.sy يساهم في رؤيتنا لصناعة سفر أكثر استدامة وحيوية في سوريا. سواء كنت تزور للترفيه أو العمل، نحن ندعوك للسفر بوعي واحترام ومسؤولية."
            toGetherLetsPreserveLabel.text = "معاً، دعونا نحافظ على جمال سوريا اليوم وغداً.\nخيارات مستدامة. تجارب أصيلة. سوريا أفضل."
        } else {
            // English texts
            sustainabilityTitleLabel.text = "Sustainability at SyriaBooking.sy"
            supportResponsibleLabel.text = "Supporting responsible tourism and sustainable hospitality in Syria."
            atSyriaBookingSYLabel.text = "At SyriaBooking.sy, we believe travel should not only be enjoyable but also respectful of the environment, local communities, and cultural heritage. We are committed to promoting sustainable tourism practices that benefit both travelers and our beloved Syria."
            ourCommitmentLabel.text = "Our Commitment to a Greener Future"
            promotingEcoFriendlyLabel.text = "Promoting Eco Friendly Hotels"
            weActivelyHighlightLabel.text = "We actively highlight and promote accommodations that:"
            useRenewableEnergyLabel.text = "✓ Use renewable energy or energy-saving practices"
            minimizeSingleUseLabel.text = "✓ Minimize single-use plastics"
            implementWasteReductionLabel.text = "✓ Implement waste reduction and recycling programs"
            conserveWaterLabel.text = "✓ Conserve water and local resources"
            lookForEcoStayBadgeLabel.text = "Look for the “Eco Stay” badge on listings that meet sustainability criteria."
            supportingLocalCommunitiesLabel.text = "Supporting Local Communities:"
            byConnectingTravelersLabel.text = "✓ By connecting travelers with locally owned hotels and guesthouses, we help ensure that tourism directly supports local families, businesses, and artisans. This promotes inclusive growth and cultural preservation."
            encounteringResponsibleTravelLabel.text = "Encouraging Responsible Travel:"
            weEducateOurUsersLabel.text = "We educate our users through tips and travel guides on how to:"
            respectLocalTraditionsLabel.text = "✓ Respect local traditions and culture"
            chooseLowImpactTransportationLabel.text = "✓ Choose low-impact transportation options"
            avoidOverTourismLabel.text = "✓ Avoid over-tourism in sensitive regions"
            leavePlacesBetterLabel.text = "✓ Leave places better than they found them"
            empoweringHotelsLabel.text = "Empowering Hotels Towards Greener Practices:"
            weWorkWithOurHotelPartnersLabel.text = "We work with our hotel partners to adopt simple but impactful changes, including:"
            switchingToEnergyLabel.text = "✓ Switching to energy-efficient lighting"
            offeringReusableAmenitiesLabel.text = "✓ Offering reusable amenities"
            reducingFoodWasteLabel.text = "✓ Reducing food waste"
            trainingStaffOnSustainabilityLabel.text = "✓ Training staff on sustainability standards"
            letsBuildABetterFutureLabel.text = "Let’s Build a Better Future Together"
            everyBookingMadeThroughSyriaBookingLabel.text = "Every booking made through SyriaBooking.sy contributes to our vision of a more sustainable and vibrant travel industry in Syria. Whether you're visiting for leisure or business, we invite you to travel consciously, respectfully, and responsibly."
            toGetherLetsPreserveLabel.text = "Together, let’s preserve the beauty of Syria for today and tomorrow.\nSustainable choices. Authentic experiences. A better Syria."
        }
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
