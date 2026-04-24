//
//  AboutUSViewController.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 25/03/26.
import UIKit

class AboutUSViewController: UIViewController {

    @IBOutlet weak var aboutUsTitleLabel: UILabel!
    @IBOutlet weak var redefiningDescriptionLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var hotelBookingSystemLabel: UILabel!
    @IBOutlet weak var yourTrustedPartnerLabel: UILabel!
    @IBOutlet weak var atSyriaBookingSYLabel: UILabel!
    @IBOutlet weak var followLinksView: UIView!
    @IBOutlet weak var aboutUsImageView: UIImageView!
    @IBOutlet weak var whyChooseUsLabel: UILabel!
    @IBOutlet weak var wideSelectionOfPropertiesLabel: UILabel!
    @IBOutlet weak var whetherYouAreVisitingLabel: UILabel!
    @IBOutlet weak var bookNowPayOnArrivalLabel: UILabel!
    @IBOutlet weak var noNeedForCreditCardsLabel: UILabel!
    @IBOutlet weak var easyBookingProcessLabel: UILabel!
    @IBOutlet weak var designedForSimplicityLabel: UILabel!
    @IBOutlet weak var realInformationNoSurpriseLabel: UILabel!
    @IBOutlet weak var weProvidedDetailedHotelLabel: UILabel!
    @IBOutlet weak var localExpertiseLabel: UILabel!
    @IBOutlet weak var weAreSyrianBasedLabel: UILabel!
    @IBOutlet weak var ourMissionLabel: UILabel!
    @IBOutlet weak var toMakeHotelBookingInSyriaLabel: UILabel!
    @IBOutlet weak var ourCommitmentLabel: UILabel!
    @IBOutlet weak var weStriveToOfferSeamLessLabel: UILabel!
    @IBOutlet weak var noHiddenFeesLabel: UILabel!
    @IBOutlet weak var fearReservationLabel: UILabel!
    @IBOutlet weak var responsiveCustomerSupportLabel: UILabel!
    @IBOutlet weak var supportingSyrianTourismLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSocialMediaView()
        aboutUsImageView.applyFullLightBlackGradientOverlay()
        updateTexts()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        
        if lang == .arabic {
            aboutUsTitleLabel.text = "حول سيريا بوكينغ"
            redefiningDescriptionLabel.text = "إعادة تعريف السفر والضيافة في سوريا"
            welcomeLabel.text = "مرحباً بكم في سيريا بوكينغ"
            hotelBookingSystemLabel.text = "نظام حجز الفنادق"
            yourTrustedPartnerLabel.text = "شريكك الموثوق لحجوزات الفنادق في جميع أنحاء سوريا"
            atSyriaBookingSYLabel.text = "في SyriaBooking.sy، نعيد تعريف السفر والضيافة داخل سوريا من خلال تقديم تجربة حجز فنادق مريحة وشفافة وآمنة للمسافرين المحليين والدوليين على حد سواء. تأسست برؤية لدعم قطاعي السياحة والأعمال المتناميين في سوريا، تربط منصتنا المسافرين بمجموعة واسعة من الفنادق والاستراحات والمنتجعات - من الإقامات الاقتصادية إلى التجارب الفاخرة - في جميع أنحاء البلاد."
            
            whyChooseUsLabel.text = "لماذا تختارنا"
            wideSelectionOfPropertiesLabel.text = "تشكيلة واسعة من العقارات"
            whetherYouAreVisitingLabel.text = "سواء كنت تزور دمشق، حلب، اللاذقية، طرطوس، حمص، أو أي مدينة سورية أخرى، فقد أقمنا شراكات مع فنادق موثوقة لنقدم لك خيارات مريحة ومتحقق منها."
            bookNowPayOnArrivalLabel.text = "احجز الآن، ادفع عند الوصول"
            noNeedForCreditCardsLabel.text = "لا حاجة لبطاقات الائتمان أو الدفعات المقدمة. ما عليك سوى البحث والاختيار وحجز إقامتك - وادفع مباشرة في الفندق عند وصولك."
            easyBookingProcessLabel.text = "عملية حجز سهلة"
            designedForSimplicityLabel.text = "مصممة للبساطة. ابحث عن الفنادق حسب المدينة أو التواريخ أو الميزانية، وأكمل حجزك ببضع نقرات فقط."
            realInformationNoSurpriseLabel.text = "معلومات حقيقية، لا مفاجآت"
            weProvidedDetailedHotelLabel.text = "نقدم وصفاً مفصلاً للفنادق، صوراً حقيقية، وسائل الراحة، تقييمات الضيوف، وخرائط الموقع - حتى تعرف دائماً ما تتوقعه."
            localExpertiseLabel.text = "خبرة محلية"
            weAreSyrianBasedLabel.text = "نحن منصة سورية تفهم السوق المحلي والثقافة واحتياجات سفرك. فريقنا هنا لإرشادك ودعمك في كل خطوة على الطريق."
            
            ourMissionLabel.text = "مهمتنا"
            toMakeHotelBookingInSyriaLabel.text = "جعل حجز الفنادق في سوريا سهلاً وموثوقاً ومرناً قدر الإمكان للجميع."
            
            ourCommitmentLabel.text = "التزامنا"
            weStriveToOfferSeamLessLabel.text = "نسعى جاهدين لتقديم تجربة سلسة مبنية على مبادئ أساسية:"
            noHiddenFeesLabel.text = "لا رسوم خفية"
            fearReservationLabel.text = "حجز وإلغاء مجاني (في معظم الفنادق)"
            responsiveCustomerSupportLabel.text = "دعم عملاء سريع الاستجابة"
            supportingSyrianTourismLabel.text = "دعم السياحة السورية والأعمال المحلية"
            
        } else {
            aboutUsTitleLabel.text = "About SyriaBooking"
            redefiningDescriptionLabel.text = "Redefining travel and hospitality within Syria."
            welcomeLabel.text = "Welcome to SyriaBooking"
            hotelBookingSystemLabel.text = "Hotel booking system"
            yourTrustedPartnerLabel.text = "Your Trusted Partner for Hotel Bookings Across Syria"
            atSyriaBookingSYLabel.text = "At SyriaBooking.sy, we are redefining travel and hospitality within Syria by offering a convenient, transparent, and secure hotel booking experience for both local and international travelers. Founded with a vision to support Syria's growing tourism and business sectors, our platform connects travelers with a wide range of hotels, guesthouses, and resorts — from affordable stays to luxury experiences — all across the country."
            
            whyChooseUsLabel.text = "Why Choose Us"
            wideSelectionOfPropertiesLabel.text = "Wide Selection of Properties"
            whetherYouAreVisitingLabel.text = "Whether you're visiting Damascus, Aleppo, Latakia, Tartus, Homs, or any other Syrian city, we've partnered with trusted hotels to give you comfortable, verified options."
            bookNowPayOnArrivalLabel.text = "Book Now, Pay on Arrival"
            noNeedForCreditCardsLabel.text = "No need for credit cards or upfront payments. Simply search, choose, and book your stay — and pay directly at the hotel when you arrive."
            easyBookingProcessLabel.text = "Easy Booking Process"
            designedForSimplicityLabel.text = "Designed for simplicity. Search hotels by city, dates, or budget, and complete your reservation in just a few clicks."
            realInformationNoSurpriseLabel.text = "Real Information, No Surprises"
            weProvidedDetailedHotelLabel.text = "We provide detailed hotel descriptions, real photos, amenities, guest reviews, and location maps — so you always know what to expect."
            localExpertiseLabel.text = "Local Expertise"
            weAreSyrianBasedLabel.text = "We are a Syrian-based platform that understands the local market, the culture, and your travel needs. Our team is here to guide and support you every step of the way."
            
            ourMissionLabel.text = "OUR MISSION"
            toMakeHotelBookingInSyriaLabel.text = "To make hotel booking in Syria as easy, reliable, and flexible as possible for everyone."
            
            ourCommitmentLabel.text = "Our Commitment"
            weStriveToOfferSeamLessLabel.text = "We strive to offer a seamless experience built on core principles:"
            noHiddenFeesLabel.text = "No hidden fees"
            fearReservationLabel.text = "Free reservation & cancellation (at most hotels)"
            responsiveCustomerSupportLabel.text = "Responsive customer support"
            supportingSyrianTourismLabel.text = "Supporting Syrian tourism and local businesses"
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
