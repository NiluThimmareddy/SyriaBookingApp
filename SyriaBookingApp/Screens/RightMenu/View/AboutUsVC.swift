
import UIKit
import WebKit

class AboutUsVC: UIViewController {
    
    @IBOutlet weak var followLinksView: UIView!
    @IBOutlet weak var aboutUsTitleLabel: UILabel!
    @IBOutlet weak var redefiningDescriptionLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var hotelBookingSystemLabel: UILabel!
    @IBOutlet weak var yourTrustedPartnerLabel: UILabel!
    @IBOutlet weak var atSyriaBookingSYLabel: UILabel!
    @IBOutlet weak var whatWeOfferLabel: UILabel!
    @IBOutlet weak var wideSelectionLabel: UILabel!
    @IBOutlet weak var whetherYouAreVisitLabel: UILabel!
    @IBOutlet weak var bookNowPayLabel: UILabel!
    @IBOutlet weak var noNeedCreditCardLabel: UILabel!
    @IBOutlet weak var easyBookingProcessLabel: UILabel!
    @IBOutlet weak var designedForSimplicityLabel: UILabel!
    @IBOutlet weak var realInformationLabel: UILabel!
    @IBOutlet weak var weProvideDetailedHotelLabel: UILabel!
    @IBOutlet weak var localExpertiseLabel: UILabel!
    @IBOutlet weak var weAreSyrianBasedLabel: UILabel!
    @IBOutlet weak var ourMissionLabel: UILabel!
    @IBOutlet weak var toMakeHotelBookingLabel: UILabel!
    @IBOutlet weak var ourCommitmentLabel: UILabel!
    @IBOutlet weak var noHiddenFeesLabel: UILabel!
    @IBOutlet weak var freeReservationLabel: UILabel!
    @IBOutlet weak var responsiveCustomerSupportLabel: UILabel!
    @IBOutlet weak var supportingSyrianTourismlabel: UILabel!

    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSocialMediaView()
        updateTexts()
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
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        
        if lang == .arabic {
            aboutUsTitleLabel.text = "معلومات عنا"
            redefiningDescriptionLabel.text = "إعادة تعريف السفر والضيافة داخل سوريا."
            welcomeLabel.text = "مرحباً بكم في سيريا بوكينغ"
            hotelBookingSystemLabel.text = "نظام حجز الفنادق"
            yourTrustedPartnerLabel.text = "شريكك الموثوق لحجوزات الفنادق في جميع أنحاء سوريا"
            atSyriaBookingSYLabel.text = "في SyriaBooking.sy، نعيد تعريف السفر والضيافة داخل سوريا من خلال تقديم تجربة حجز فنادق مريحة وشفافة وآمنة للمسافرين المحليين والدوليين على حد سواء. تأسست برؤية لدعم قطاعي السياحة والأعمال المتناميين في سوريا، تربط منصتنا المسافرين بمجموعة واسعة من الفنادق والاستراحات والمنتجعات - من الإقامات الاقتصادية إلى التجارب الفاخرة - في جميع أنحاء البلاد."
            whatWeOfferLabel.text = "ماذا نقدم"
            wideSelectionLabel.text = "١. تشكيلة واسعة من العقارات"
            whetherYouAreVisitLabel.text = "سواء كنت تزور دمشق، حلب، اللاذقية، طرطوس، حمص، أو أي مدينة سورية أخرى، فقد أقمنا شراكات مع فنادق موثوقة لنقدم لك خيارات مريحة ومتحقق منها."
            bookNowPayLabel.text = "٢. احجز الآن، ادفع عند الوصول"
            noNeedCreditCardLabel.text = "لا حاجة لبطاقات الائتمان أو الدفعات المقدمة. ما عليك سوى البحث والاختيار وحجز إقامتك - وادفع مباشرة في الفندق عند وصولك."
            easyBookingProcessLabel.text = "٣. عملية حجز سهلة"
            designedForSimplicityLabel.text = "مصممة للبساطة. ابحث عن الفنادق حسب المدينة أو التواريخ أو الميزانية، وأكمل حجزك ببضع نقرات فقط."
            realInformationLabel.text = "٤. معلومات حقيقية، لا مفاجآت"
            weProvideDetailedHotelLabel.text = "نقدم وصفاً مفصلاً للفنادق، صوراً حقيقية، وسائل الراحة، تقييمات الضيوف، وخرائط الموقع - حتى تعرف دائماً ما تتوقعه."
            localExpertiseLabel.text = "٥. خبرة محلية"
            weAreSyrianBasedLabel.text = "نحن منصة سورية تفهم السوق المحلي والثقافة واحتياجات سفرك. فريقنا هنا لإرشادك ودعمك في كل خطوة على الطريق."
            ourMissionLabel.text = "مهمتنا"
            toMakeHotelBookingLabel.text = "جعل حجز الفنادق في سوريا سهلاً وموثوقاً ومرناً قدر الإمكان - للجميع."
            ourCommitmentLabel.text = "التزامنا"
            noHiddenFeesLabel.text = "لا رسوم خفية"
            freeReservationLabel.text = "حجز وإلغاء مجاني (في معظم الفنادق)"
            responsiveCustomerSupportLabel.text = "دعم عملاء سريع الاستجابة"
            supportingSyrianTourismlabel.text = "دعم السياحة السورية والأعمال المحلية"
        } else {
            aboutUsTitleLabel.text = "About Us"
            redefiningDescriptionLabel.text = "Redefining travel and hospitality within Syria."
            welcomeLabel.text = "Welcome to SyriaBooking"
            hotelBookingSystemLabel.text = "Hotel booking system"
            yourTrustedPartnerLabel.text = "Your Trusted Partner for Hotel Bookings Across Syria"
            atSyriaBookingSYLabel.text = "At SyriaBooking.sy, we are redefining travel and hospitality within Syria by offering a convenient, transparent, and secure hotel booking experience for both local and international travelers. Founded with a vision to support Syria's growing tourism and business sectors, our platform connects travelers with a wide range of hotels, guesthouses, and resorts — from affordable stays to luxury experiences — all across the country."
            whatWeOfferLabel.text = "What We Offer"
            wideSelectionLabel.text = "1. Wide Selection of Properties"
            whetherYouAreVisitLabel.text = "Whether you're visiting Damascus, Aleppo, Latakia, Tartus, Homs, or any other Syrian city, we've partnered with trusted hotels to give you comfortable, verified options."
            bookNowPayLabel.text = "2. Book Now, Pay on Arrival"
            noNeedCreditCardLabel.text = "No need for credit cards or upfront payments. Simply search, choose, and book your stay — and pay directly at the hotel when you arrive."
            easyBookingProcessLabel.text = "3. Easy Booking Process"
            designedForSimplicityLabel.text = "Designed for simplicity. Search hotels by city, dates, or budget, and complete your reservation in just a few clicks."
            realInformationLabel.text = "4. Real Information, No Surprises"
            weProvideDetailedHotelLabel.text = "We provide detailed hotel descriptions, real photos, amenities, guest reviews, and location maps — so you always know what to expect."
            localExpertiseLabel.text = "5. Local Expertise"
            weAreSyrianBasedLabel.text = "We are a Syrian-based platform that understands the local market, the culture, and your travel needs. Our team is here to guide and support you every step of the way."
            ourMissionLabel.text = "Our Mission"
            toMakeHotelBookingLabel.text = "To make hotel booking in Syria as easy, reliable, and flexible as possible — for everyone."
            ourCommitmentLabel.text = "Our Commitment"
            noHiddenFeesLabel.text = "No hidden fees"
            freeReservationLabel.text = "Free reservation & cancellation (at most hotels)"
            responsiveCustomerSupportLabel.text = "Responsive customer support"
            supportingSyrianTourismlabel.text = "Supporting Syrian tourism and local businesses"
        }
    }
    
}
