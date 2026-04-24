//
//  Covid19FAQsViewController.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 25/03/26.
//

import UIKit

class Covid19FAQsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var insideScrollView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var covidImageView: UIImageView!
    @IBOutlet weak var covidFaqTitleLabel: UILabel!
    @IBOutlet weak var findAnswerAboutTravelLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var travelInformationBookingSupportLabel: UILabel!
    @IBOutlet weak var yourSafetyAndPeaceOfMindLabel: UILabel!
    @IBOutlet weak var frequentlyAskedQuestionsTitleLabel: UILabel!
    @IBOutlet weak var faqsTabelView: UITableView!
    @IBOutlet weak var travelSafelyView: UIView!
    @IBOutlet weak var travelSafelyWithSyriaBookingTitleLabel: UILabel!
    @IBOutlet weak var travelOnlyIfFeelWelllabel: UILabel!
    @IBOutlet weak var healthGuidelinesLabel: UILabel!
    @IBOutlet weak var supportLocalBusinessLabel: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var followLinksView: UIView!
    
    var selectedIndexPath: IndexPath?
    
    var count = ["01","02","03","04","05","06","07"]
    var faqQuestionEnglish = [
        "Can I book hotels after the COVID-19 pandemic?",
        "What safety measures are hotels taking?",
        "Can I cancel or change my booking due to COVID-19?",
        "Do I need to pay in advance?",
        "Are there any travel restrictions in Syria?",
        "Do I need a COVID-19 test or vaccination to stay at a hotel?",
        "Who can I contact if I have a COVID-related concern?"
    ]
    
    var faqAnswersEnglish = [
        "Yes, SyriaBooking.sy remains fully operational. You can search and reserve hotels across Syria, depending on local travel regulations and hotel availability. \nNote: Availability may be affected in certain areas due to local restrictions or limited operations.",
        "Many of our hotel partners are implementing safety and hygiene measures, including:\n✓ Regular cleaning and sanitization\n✓ Social distancing protocols\n✓ Staff health checks\n✓ Hand sanitizers in public areas\n✓ Contactless check-in (where available)\nLook for “Health & Safety Measures” under each hotel listing for more details.",
        "Yes. Most bookings on SyriaBooking.sy are Pay-on-Arrival, so you can cancel without penalty. However:\n✓ Some hotels may have specific cancellation policies\n✓ We advise contacting the hotel directly or reaching out to our customer support team for assistance.",
        "No. All bookings on SyriaBooking.sy follow a “Book Now, Pay on Arrival” policy — no advance payment or credit card is required online.",
        "Travel conditions may vary depending on city or region. We recommend:\n✓ Checking with local authorities before traveling\n✓ Carrying a valid ID or permit, if required\n✓ Following hotel and transportation safety rules\nWe also advise monitoring announcements from Syria’s Ministry of Health and WHO guidelines.",
        "As of now, most hotels do not require proof of vaccination or test, but this can vary by location and property. Always:\n✓ Contact the hotel prior to arrival to confirm current rules\n✓ Be prepared to wear a mask and follow local health guidelines.",
        "You can contact us directly for help with your booking or travel concern:\n• Mail us at info@syriabooking.sy\n• Call our hotline at +963-789-123456"
    ]
    
    var faqQuestionArabic = [
        "هل يمكنني حجز الفنادق بعد جائحة COVID-19؟",
        "ما هي تدابير السلامة التي تتخذها الفنادق؟",
        "هل يمكنني إلغاء أو تعديل حجزي بسبب COVID-19؟",
        "هل يجب علي الدفع مقدمًا؟",
        "هل هناك قيود سفر في سوريا؟",
        "هل أحتاج إلى اختبار COVID-19 أو لقاح للبقاء في الفندق؟",
        "من يمكنني الاتصال به إذا كان لدي استفسار متعلق بـ COVID-19؟"
    ]
    
    var faqAnswersArabic = [
        "نعم، تظل SyriaBooking.sy تعمل بكامل طاقتها. يمكنك البحث وحجز الفنادق في جميع أنحاء سوريا، حسب اللوائح المحلية وتوافر الفندق.\nملاحظة: قد يتأثر التوافر في بعض المناطق بسبب القيود المحلية أو العمليات المحدودة.",
        
        "يقوم العديد من شركائنا من الفنادق بتنفيذ تدابير سلامة ونظافة، بما في ذلك:\n✓ التنظيف والتعقيم المنتظم\n✓ بروتوكولات التباعد الاجتماعي\n✓ فحوصات صحة الموظفين\n✓ معقمات اليدين في الأماكن العامة\n✓ تسجيل الوصول بدون تلامس (عند توفره)\nابحث عن “إجراءات الصحة والسلامة” تحت كل قائمة فندق لمزيد من التفاصيل.",
        
        "نعم. معظم الحجوزات على SyriaBooking.sy هي “الدفع عند الوصول”، لذا يمكنك الإلغاء بدون غرامة. ومع ذلك:\n✓ قد يكون لبعض الفنادق سياسات إلغاء محددة\n✓ ننصح بالاتصال بالفندق مباشرة أو التواصل مع فريق خدمة العملاء للحصول على المساعدة.",
        
        "لا. جميع الحجوزات على SyriaBooking.sy تتبع سياسة “احجز الآن، ادفع عند الوصول” — لا يلزم دفع مقدم أو بطاقة ائتمان عبر الإنترنت.",
        
        "قد تختلف شروط السفر حسب المدينة أو المنطقة. ننصح بـ:\n✓ التحقق من السلطات المحلية قبل السفر\n✓ حمل هوية أو تصريح صالح إذا لزم الأمر\n✓ اتباع قواعد السلامة للفندق ووسائل النقل\nكما ننصح بمتابعة إعلانات وزارة الصحة السورية وإرشادات منظمة الصحة العالمية.",
        
        "حتى الآن، لا تتطلب معظم الفنادق إثبات التطعيم أو الاختبار، لكن هذا قد يختلف حسب الموقع والمكان. دائمًا:\n✓ الاتصال بالفندق قبل الوصول لتأكيد القواعد الحالية\n✓ الاستعداد لارتداء الكمامة واتباع إرشادات الصحة المحلية.",
        
        "يمكنك الاتصال بنا مباشرة لمساعدتك بخصوص حجوزتك أو استفسارك:\n• راسلنا عبر البريد الإلكتروني info@syriabooking.sy\n• اتصل بخط المساعدة على الرقم +963-789-123456"
    ]
    
    var faqQuestion: [String] {
        return AppSettings.shared.selectedLanguage == .arabic ? faqQuestionArabic : faqQuestionEnglish
    }
    
    var faqAnswers: [String] {
        return AppSettings.shared.selectedLanguage == .arabic ? faqAnswersArabic : faqAnswersEnglish
    }
    
    var covid19TitleText: String {
        return AppSettings.shared.selectedLanguage == .arabic
        ? "فيروس كورونا (COVID-19) – الأسئلة الشائعة"
        : "Coronavirus (COVID-19) – FAQs"
    }
    
    var descriptionText: String {
        return AppSettings.shared.selectedLanguage == .arabic
        ? "معلومات السفر ودعم الحجز لعملاء SyriaBooking.sy"
        : "Travel Information & Booking Support for SyriaBooking.sy Customers"
    }
    
    var subDescriptionText: String {
        return AppSettings.shared.selectedLanguage == .arabic
        ? "في SyriaBooking.sy، سلامتك وراحة بالك هما أولويتنا القصوى. هنا ستجد إجابات على أكثر الأسئلة شيوعًا المتعلقة بـ COVID-19، الحجوزات، الإلغاءات، وبروتوكولات الصحة."
        : "At SyriaBooking.sy, your safety and peace of mind are our top priorities. Here you’ll find answers to the most frequently asked questions related to COVID-19, bookings, cancellations, and health protocols."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
    }

}

extension Covid19FAQsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqQuestion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FrequentlyAskedTVC", for: indexPath) as! FrequentlyAskedTVC
        
        let imageName = (selectedIndexPath == indexPath) ? "chevron.up" : "chevron.down"
        cell.imageLabel.image = UIImage(systemName: imageName)
        cell.imageLabel.tintColor = .darkGray
        cell.serialNumLabel.text = count[indexPath.row]
        cell.headLineLabel.text = faqQuestion[indexPath.row]
        cell.descriptionLabel.text = faqAnswers[indexPath.row]
        cell.descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return (selectedIndexPath == indexPath) ? 190 : 80
        } else {
            return (selectedIndexPath == indexPath) ? 230 : 80
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        
        if selectedIndexPath == indexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPathsToReload: [IndexPath] = [indexPath]
        if let previous = previousIndexPath, previous != indexPath {
            indexPathsToReload.append(previous)
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.reloadRows(at: indexPathsToReload, with: .none)
    }
}

extension Covid19FAQsViewController {
    func setUpUI() {
        faqsTabelView.register(UINib(nibName: "FrequentlyAskedTVC", bundle: .main), forCellReuseIdentifier: "FrequentlyAskedTVC")
        
        covidFaqTitleLabel.text = covid19TitleText
        travelInformationBookingSupportLabel.text = descriptionText
        yourSafetyAndPeaceOfMindLabel.text = subDescriptionText
        
        covidImageView.applyFullLightBlackGradientOverlay()
        
        if AppSettings.shared.selectedLanguage == .arabic {
            frequentlyAskedQuestionsTitleLabel.text = "الأسئلة الشائعة"
            travelSafelyWithSyriaBookingTitleLabel.text = "سافر بأمان مع SyriaBooking.sy"
            travelOnlyIfFeelWelllabel.text = "سافر فقط إذا كنت تشعر بتحسن"
            healthGuidelinesLabel.text = "تابع أحدث الإرشادات الصحية"
            supportLocalBusinessLabel.text = "ادعم الأعمال المحلية من خلال الحجز المسؤول"
        } else {
            frequentlyAskedQuestionsTitleLabel.text = "Frequently Asked Questions"
            travelSafelyWithSyriaBookingTitleLabel.text = "Travel Safely with SyriaBooking.sy"
            travelOnlyIfFeelWelllabel.text = "Travel only if you feel well"
            healthGuidelinesLabel.text = "Keep up with the latest health guidelines"
            supportLocalBusinessLabel.text = "Support local businesses by booking responsibly"
        }
        setupSocialMediaView()
        setupEmailUsView()
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
    
    private func setupEmailUsView() {
        let nib = UINib(nibName: "EmailIDView", bundle: nil)
        guard let emailUSView = nib.instantiate(withOwner: nil, options: nil).first as? EmailIDView else {
            return
        }

        emailView.addSubview(emailUSView)
        emailView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emailUSView.topAnchor.constraint(equalTo: emailView.topAnchor),
            emailUSView.bottomAnchor.constraint(equalTo: emailView.bottomAnchor),
            emailUSView.leadingAnchor.constraint(equalTo: emailView.leadingAnchor),
            emailUSView.trailingAnchor.constraint(equalTo: emailView.trailingAnchor)
        ])
    }
}


