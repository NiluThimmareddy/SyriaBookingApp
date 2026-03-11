//
//  CareersVC.swift
//  NewProject
//
//  Created by Yarramsetti Yedukondalu on 06/08/25.
//

//struct TestimonialModel: Codable {
//    let message: String
//    let descriptions: String
//    let employeeName: String
//    let jobTitle: String
//}
//
//import UIKit
//import WebKit
//
//class CareersVC: UIViewController {
//    
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var contentView: UIView!
//    @IBOutlet weak var insideScrollView: UIView!
//    @IBOutlet weak var careersTitleLabel: UILabel!
//    @IBOutlet weak var redefiningTravelDescriptionLabel: UILabel!
//    @IBOutlet weak var ourTeamSaysCollectionView: UICollectionView!
//    @IBOutlet weak var leftArrowButton: UIButton!
//    @IBOutlet weak var rightArrowButton: UIButton!
//    @IBOutlet weak var applyJobButton: UIButton!
//    @IBOutlet weak var emailLabel: UILabel!
//    @IBOutlet weak var careersAtSyriaBookingLabel: UILabel!
//    @IBOutlet weak var joinTheTeamLabel: UILabel!
//    @IBOutlet weak var weareOnAMessionLabel: UILabel!
//    @IBOutlet weak var whetherYouareTechLabel: UILabel!
//    @IBOutlet weak var whyWorkWithusLabel: UILabel!
//    @IBOutlet weak var innovateLocallyLabel: UILabel!
//    @IBOutlet weak var bePartOfPioneeringLabel: UILabel!
//    @IBOutlet weak var collaborativeAndSupportiveLabel: UILabel!
//    @IBOutlet weak var weValueTeamWorkLabel: UILabel!
//    @IBOutlet weak var careerGrowthOpportunitiesLabel: UILabel!
//    @IBOutlet weak var weAreGrowingFastLabel: UILabel!
//    @IBOutlet weak var workWithPurposeLabel: UILabel!
//    @IBOutlet weak var yourWorkWithDirectlyLabel: UILabel!
//    @IBOutlet weak var didnotSeeARoleLikeThatLabel: UILabel!
//    @IBOutlet weak var weAreAlwaysOpenTohearingLabel: UILabel!
//    @IBOutlet weak var happyToApplyLabel: UILabel!
//    @IBOutlet weak var readyToBuildTheFeatureLabel: UILabel!
//    @IBOutlet weak var bePartOfSomethingLabel: UILabel!
//    @IBOutlet weak var whatOurTeamSaysLabel: UILabel!
//    
//    
//    var currentIndex = 0
//    
//    let testimonials: [TestimonialModel] = [
//        TestimonialModel(
//            message: "Feels like being part of something bigger",
//            descriptions: "Working at SyriaBooking.sy feels like being part of something bigger - we're not just booking hotels, we're helping rebuild confidence in Syrian tourism.",
//            employeeName: "Lina A.",
//            jobTitle: "Hotel Onboarding Manager"
//        ),
//        TestimonialModel(
//            message: "The culture is supportive",
//            descriptions: "The culture is supportive, the mission is meaningful, and there's real space to grow.",
//            employeeName: "Omar K.",
//            jobTitle: "Frontend Developer"
//        ),
//        TestimonialModel(
//            message: "The best booking system",
//            descriptions: "I've been using the hotel booking system for several years now, and it's become my go-to platform for planning my trips.",
//            employeeName: "Sara Mohamed",
//            jobTitle: "Adv. Manager"
//        ),
//        TestimonialModel(
//            message: "The interface is user-friendly",
//            descriptions: "The interface is user-friendly, and I appreciate the detailed information and real-time availability of hotels.",
//            employeeName: "Atend John",
//            jobTitle: "Marketing Executive"
//        )
//    ]
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        ourTeamSaysCollectionView.register(UINib(nibName: "CareersCVC", bundle: nil), forCellWithReuseIdentifier: "CareersCVC")
//        if let layout = ourTeamSaysCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .horizontal
//            layout.estimatedItemSize = .zero
//        }
//        
//        setupEmailLabel()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setupAppNavigationBar()
//    }
//    
//    private func setupEmailLabel() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(emailLabelTapped))
//        emailLabel.isUserInteractionEnabled = true
//        emailLabel.addGestureRecognizer(tapGesture)
//        
//        let fullText = "Email your CV and a brief introduction to: careers@syriabooking.sy\nSubject: [Job Title] – Application – Your Name here"
//        
//        let attributedString = NSMutableAttributedString(string: fullText)
//        
//        let baseFont = UIFont.systemFont(ofSize: emailLabel.font.pointSize)
//        attributedString.addAttribute(.font, value: baseFont, range: NSRange(location: 0, length: fullText.count))
//        
//        if let emailRange = fullText.range(of: "careers@syriabooking.sy") {
//            let nsRange = NSRange(emailRange, in: fullText)
//            
//            attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: nsRange)
//            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
//            
//            let emailFontSize = emailLabel.font.pointSize + 5
//            let emailFont = UIFont.systemFont(ofSize: emailFontSize, weight: .semibold)
//            attributedString.addAttribute(.font, value: emailFont, range: nsRange)
//        }
//        
//        emailLabel.attributedText = attributedString
//        emailLabel.numberOfLines = 0
//        emailLabel.lineBreakMode = .byWordWrapping
//    }
//    
//    @objc private func emailLabelTapped() {
//        openEmailClient()
//    }
//    
//    private func openEmailClient() {
//        let email = "careers@syriabooking.sy"
//        let subject = ""
//        let body = ""
//        
//        if let emailURL = createEmailURL(to: email, subject: subject, body: body) {
//            // Check if device can send emails
//            if UIApplication.shared.canOpenURL(emailURL) {
//                UIApplication.shared.open(emailURL, options: [:]) { success in
//                    if !success {
//                        self.showEmailNotConfiguredAlert()
//                    }
//                }
//            } else {
//                showEmailNotConfiguredAlert()
//            }
//        }
//    }
//    
//    private func createEmailURL(to: String, subject: String, body: String) -> URL? {
//        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let urlString = "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)"
//        return URL(string: urlString)
//    }
//    
//    private func showEmailNotConfiguredAlert() {
//        let alert = UIAlertController(
//            title: "Email Not Available",
//            message: "There is no email client configured on this device. You can manually send your application to: careers@syriabooking.sy",
//            preferredStyle: .alert
//        )
//        
//        alert.addAction(UIAlertAction(title: "Copy Email", style: .default, handler: { _ in
//            UIPasteboard.general.string = "careers@syriabooking.sy"
//            self.showCopiedAlert()
//        }))
//        
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        
//        present(alert, animated: true)
//    }
//    
//    private func showCopiedAlert() {
//        let alert = UIAlertController(
//            title: "Copied!",
//            message: "Email address copied to clipboard.",
//            preferredStyle: .alert
//        )
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true, completion: nil)
//    }
//    
//    
//    @IBAction func leftArrowButtonAction(_ sender: Any) {
//        guard currentIndex > 0 else { return }
//        currentIndex -= 1
//        
//        let indexPath = IndexPath(item: currentIndex, section: 0)
//        ourTeamSaysCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//    }
//        
//    @IBAction func rightArrowButtonAction(_ sender: Any) {
//        guard currentIndex < testimonials.count - 1 else { return }
//        currentIndex += 1
//        
//        let indexPath = IndexPath(item: currentIndex, section: 0)
//        ourTeamSaysCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//    }
//    
//    @IBAction func applyJobButtonAction(_ sender: Any) {
//        let storyboard = storyboard?.instantiateViewController(identifier: "CareerApplicationVC") as! CareerApplicationVC
//        storyboard.modalPresentationStyle = .fullScreen
//        self.present(storyboard, animated: true)
//    }
//    
//}
//
//extension CareersVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return testimonials.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CareersCVC", for: indexPath) as! CareersCVC
//        cell.questionsTitleLabel.text = testimonials[indexPath.row].message
//        cell.answersLabel.text = testimonials[indexPath.row].descriptions
//        cell.teammembersNameLabel.text = testimonials[indexPath.row].employeeName
//        cell.designationLabel.text = testimonials[indexPath.row].jobTitle
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.width * 0.75
//        let height = collectionView.frame.height
//        return CGSize(width: width, height: height)
//    }
//    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let pageWidth = ourTeamSaysCollectionView.frame.width * 0.75
//        let offset = scrollView.contentOffset.x
//        currentIndex = Int(round(offset / pageWidth))
//    }
//}

struct TestimonialModel: Codable {
    let message: String
    let descriptions: String
    let employeeName: String
    let jobTitle: String
}

import UIKit
import WebKit

class CareersVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var insideScrollView: UIView!
    @IBOutlet weak var careersTitleLabel: UILabel!
    @IBOutlet weak var redefiningTravelDescriptionLabel: UILabel!
    @IBOutlet weak var ourTeamSaysCollectionView: UICollectionView!
    @IBOutlet weak var leftArrowButton: UIButton!
    @IBOutlet weak var rightArrowButton: UIButton!
    @IBOutlet weak var applyJobButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var careersAtSyriaBookingLabel: UILabel!
    @IBOutlet weak var joinTheTeamLabel: UILabel!
    @IBOutlet weak var weareOnAMessionLabel: UILabel!
    @IBOutlet weak var whetherYouareTechLabel: UILabel!
    @IBOutlet weak var whyWorkWithusLabel: UILabel!
    @IBOutlet weak var innovateLocallyLabel: UILabel!
    @IBOutlet weak var bePartOfPioneeringLabel: UILabel!
    @IBOutlet weak var collaborativeAndSupportiveLabel: UILabel!
    @IBOutlet weak var weValueTeamWorkLabel: UILabel!
    @IBOutlet weak var careerGrowthOpportunitiesLabel: UILabel!
    @IBOutlet weak var weAreGrowingFastLabel: UILabel!
    @IBOutlet weak var workWithPurposeLabel: UILabel!
    @IBOutlet weak var yourWorkWithDirectlyLabel: UILabel!
    @IBOutlet weak var didnotSeeARoleLikeThatLabel: UILabel!
    @IBOutlet weak var weAreAlwaysOpenTohearingLabel: UILabel!
    @IBOutlet weak var happyToApplyLabel: UILabel!
    @IBOutlet weak var readyToBuildTheFeatureLabel: UILabel!
    @IBOutlet weak var bePartOfSomethingLabel: UILabel!
    @IBOutlet weak var whatOurTeamSaysLabel: UILabel!
    
    var currentIndex = 0
    
    // English testimonials
    let englishTestimonials: [TestimonialModel] = [
        TestimonialModel(
            message: "Feels like being part of something bigger",
            descriptions: "Working at SyriaBooking.sy feels like being part of something bigger - we're not just booking hotels, we're helping rebuild confidence in Syrian tourism.",
            employeeName: "Lina A.",
            jobTitle: "Hotel Onboarding Manager"
        ),
        TestimonialModel(
            message: "The culture is supportive",
            descriptions: "The culture is supportive, the mission is meaningful, and there's real space to grow.",
            employeeName: "Omar K.",
            jobTitle: "Frontend Developer"
        ),
        TestimonialModel(
            message: "The best booking system",
            descriptions: "I've been using the hotel booking system for several years now, and it's become my go-to platform for planning my trips.",
            employeeName: "Sara Mohamed",
            jobTitle: "Adv. Manager"
        ),
        TestimonialModel(
            message: "The interface is user-friendly",
            descriptions: "The interface is user-friendly, and I appreciate the detailed information and real-time availability of hotels.",
            employeeName: "Atend John",
            jobTitle: "Marketing Executive"
        )
    ]
    
    // Arabic testimonials
    let arabicTestimonials: [TestimonialModel] = [
        TestimonialModel(
            message: "الشعور بأنك جزء من شيء أكبر",
            descriptions: "العمل في سيريا بوكينغ يمنحك الشعور بأنك جزء من شيء أكبر - نحن لا نحجز الفنادق فحسب، بل نساعد في إعادة بناء الثقة في السياحة السورية.",
            employeeName: "لينا أ.",
            jobTitle: "مديرة تأهيل الفنادق"
        ),
        TestimonialModel(
            message: "ثقافة العمل داعمة",
            descriptions: "ثقافة العمل داعمة، والرسالة ذات معنى، وهناك مساحة حقيقية للنمو.",
            employeeName: "عمر ك.",
            jobTitle: "مطور واجهات أمامية"
        ),
        TestimonialModel(
            message: "أفضل نظام حجز",
            descriptions: "أستخدم نظام حجز الفنادق منذ عدة سنوات، وأصبح منصتي المفضلة للتخطيط لرحلاتي.",
            employeeName: "سارة محمد",
            jobTitle: "مديرة إعلانات"
        ),
        TestimonialModel(
            message: "الواجهة سهلة الاستخدام",
            descriptions: "الواجهة سهلة الاستخدام، وأقدر المعلومات التفصيلية والتوفر الفوري للفنادق.",
            employeeName: "أتند جون",
            jobTitle: "مدير تسويق"
        )
    ]
    
    var testimonials: [TestimonialModel] {
        return AppSettings.shared.selectedLanguage == .english ? englishTestimonials : arabicTestimonials
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add language change notification observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTexts),
            name: .languageChanged,
            object: nil
        )
        
        ourTeamSaysCollectionView.register(UINib(nibName: "CareersCVC", bundle: nil), forCellWithReuseIdentifier: "CareersCVC")
        if let layout = ourTeamSaysCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.estimatedItemSize = .zero
        }
        
        setupEmailLabel()
        updateTexts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        let buttonFont = UIFont.systemFont(ofSize: 15, weight: .medium)
        if lang == .english {
            // English texts
            careersTitleLabel.text = "Careers"
            redefiningTravelDescriptionLabel.text = "Redefining travel and hospitality within Syria."
            careersAtSyriaBookingLabel.text = "Careers at SyriaBooking.sy"
            joinTheTeamLabel.text = "Join the Team Behind Syria’s Leading Hotel Booking Platform"
            weareOnAMessionLabel.text = "At SyriaBooking.sy, we’re on a mission to transform how people explore and experience Syria — by making travel simpler, smarter, and more accessible for everyone. We’re building the country’s go-to platform for hotel bookings, and we’re looking for passionate individuals to grow with us."
            whetherYouareTechLabel.text = "Whether you’re a tech expert, customer service champion, creative storyteller, or business strategist — if you believe in innovation, integrity, and impact, you’ll feel at home here."
            whyWorkWithusLabel.text = "Why Work With Us?"
            innovateLocallyLabel.text = "Innovate Locally, Impact Nationally:"
            bePartOfPioneeringLabel.text = "Be part of a pioneering tech company creating real change in the Syrian travel and tourism industry."
            collaborativeAndSupportiveLabel.text = "Collaborative & Supportive Culture:"
            weValueTeamWorkLabel.text = "We value teamwork, open communication, and mutual growth. Your voice matters here."
            careerGrowthOpportunitiesLabel.text = "Career Growth Opportunities:"
            weAreGrowingFastLabel.text = "We’re growing fast — and so will you. Learn, lead, and take your career to the next level."
            workWithPurposeLabel.text = "Work With Purpose:"
            yourWorkWithDirectlyLabel.text = "Your work will directly help travelers, support local businesses, and showcase the beauty of Syria to the world."
            didnotSeeARoleLikeThatLabel.text = "Didn’t see a role that fits?"
            weAreAlwaysOpenTohearingLabel.text = "We’re always open to hearing from passionate professionals. Send us your CV anyway!"
            happyToApplyLabel.text = "How to Apply?"
            readyToBuildTheFeatureLabel.text = "Ready to Build the Future of Travel in Syria?"
            bePartOfSomethingLabel.text = "Be part of something impactful. Join SyriaBooking.sy. Travel Starts Here."
            whatOurTeamSaysLabel.text = "What Our Team Says!"
            
            let attributedTitle = NSAttributedString(
                string: "Apply for a Job",
                attributes: [
                    .font: buttonFont,
                    .foregroundColor: applyJobButton.titleColor(for: .normal) ?? .white
                ]
            )
            applyJobButton.setAttributedTitle(attributedTitle, for: .normal)
            
        } else {
            // Arabic texts
            careersTitleLabel.text = "وظائف"
            redefiningTravelDescriptionLabel.text = "إعادة تعريف السفر والضيافة في سوريا."
            careersAtSyriaBookingLabel.text = "وظائف في سيريا بوكينغ"
            joinTheTeamLabel.text = "انضم إلى الفريق الذي يقف وراء منصة حجز الفنادق الرائدة في سوريا"
            weareOnAMessionLabel.text = "في سيريا بوكينغ، نحن في مهمة لتحويل كيفية استكشاف وتجربة سوريا - من خلال جعل السفر أبسط وأذكى وأكثر سهولة للجميع. نحن نبني المنصة الرائدة في البلاد لحجز الفنادق، ونبحث عن أفراد متحمسين لينموا معنا."
            whetherYouareTechLabel.text = "سواء كنت خبير تقني، أو بطل خدمة عملاء، أو راوي قصص مبدع، أو استراتيجي أعمال - إذا كنت تؤمن بالابتكار والنزاهة والتأثير، فستشعر وكأنك في منزلك هنا."
            whyWorkWithusLabel.text = "لماذا تعمل معنا؟"
            innovateLocallyLabel.text = "ابتكر محلياً، أثر وطنياً:"
            bePartOfPioneeringLabel.text = "كن جزءاً من شركة تقنية رائدة تحدث تغييراً حقيقياً في صناعة السفر والسياحة السورية."
            collaborativeAndSupportiveLabel.text = "ثقافة تعاونية وداعمة:"
            weValueTeamWorkLabel.text = "نحن نقدر العمل الجماعي، والتواصل المفتوح، والنمو المتبادل. صوتك مهم هنا."
            careerGrowthOpportunitiesLabel.text = "فرص النمو الوظيفي:"
            weAreGrowingFastLabel.text = "نحن ننمو بسرعة - وكذلك ستنمو أنت. تعلم، قُد، واصطحب مسيرتك المهنية إلى المستوى التالي."
            workWithPurposeLabel.text = "اعمل بهدف:"
            yourWorkWithDirectlyLabel.text = "عملك سيساعد المسافرين مباشرة، ويدعم الأعمال المحلية، ويعرض جمال سوريا للعالم."
            didnotSeeARoleLikeThatLabel.text = "لم ترَ دوراً مناسباً؟"
            weAreAlwaysOpenTohearingLabel.text = "نحن دائماً منفتحون لسماع آراء المحترفين المتحمسين. أرسل لنا سيرتك الذاتية على أي حال!"
            happyToApplyLabel.text = "كيفية التقديم؟"
            readyToBuildTheFeatureLabel.text = "هل أنت مستعد لبناء مستقبل السفر في سوريا؟"
            bePartOfSomethingLabel.text = "كن جزءاً من شيء مؤثر. انضم إلى سيريا بوكينغ. السفر يبدأ من هنا."
            whatOurTeamSaysLabel.text = "ماذا يقول فريقنا!"
            
            let attributedTitle = NSAttributedString(
                string: "تقدم لوظيفة",
                attributes: [
                    .font: buttonFont,
                    .foregroundColor: applyJobButton.titleColor(for: .normal) ?? .white
                ]
            )
            applyJobButton.setAttributedTitle(attributedTitle, for: .normal)
        }
        
        // Update email label
        setupEmailLabel()
        
        // Reload collection view with new testimonials
        ourTeamSaysCollectionView.reloadData()
    }
    
    private func setupEmailLabel() {
        let lang = AppSettings.shared.selectedLanguage
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(emailLabelTapped))
        emailLabel.isUserInteractionEnabled = true
        emailLabel.addGestureRecognizer(tapGesture)
        
        let fullText: String
        if lang == .english {
            fullText = "Email your CV and a brief introduction to: careers@syriabooking.sy\nSubject: [Job Title] – Application – Your Name here"
        } else {
            fullText = "أرسل سيرتك الذاتية ومقدمة موجزة إلى: careers@syriabooking.sy\nالموضوع: [المسمى الوظيفي] – طلب توظيف – اسمك هنا"
        }
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let baseFont = UIFont.systemFont(ofSize: emailLabel.font.pointSize)
        attributedString.addAttribute(.font, value: baseFont, range: NSRange(location: 0, length: fullText.count))
        
        if let emailRange = fullText.range(of: "careers@syriabooking.sy") {
            let nsRange = NSRange(emailRange, in: fullText)
            
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: nsRange)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
            
            let emailFontSize = emailLabel.font.pointSize + 5
            let emailFont = UIFont.systemFont(ofSize: emailFontSize, weight: .semibold)
            attributedString.addAttribute(.font, value: emailFont, range: nsRange)
        }
        
        emailLabel.attributedText = attributedString
        emailLabel.numberOfLines = 0
        emailLabel.lineBreakMode = .byWordWrapping
    }
    
    @objc private func emailLabelTapped() {
        openEmailClient()
    }
    
    private func openEmailClient() {
        let email = "careers@syriabooking.sy"
        let subject = ""
        let body = ""
        
        if let emailURL = createEmailURL(to: email, subject: subject, body: body) {
            if UIApplication.shared.canOpenURL(emailURL) {
                UIApplication.shared.open(emailURL, options: [:]) { success in
                    if !success {
                        self.showEmailNotConfiguredAlert()
                    }
                }
            } else {
                showEmailNotConfiguredAlert()
            }
        }
    }
    
    private func createEmailURL(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)"
        return URL(string: urlString)
    }
    
    private func showEmailNotConfiguredAlert() {
        let lang = AppSettings.shared.selectedLanguage
        let title = lang == .english ? "Email Not Available" : "البريد الإلكتروني غير متاح"
        let message = lang == .english ?
            "There is no email client configured on this device. You can manually send your application to: careers@syriabooking.sy" :
            "لا يوجد عميل بريد إلكتروني مهيأ على هذا الجهاز. يمكنك إرسال طلبك يدوياً إلى: careers@syriabooking.sy"
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let copyTitle = lang == .english ? "Copy Email" : "نسخ البريد الإلكتروني"
        alert.addAction(UIAlertAction(title: copyTitle, style: .default, handler: { _ in
            UIPasteboard.general.string = "careers@syriabooking.sy"
            self.showCopiedAlert()
        }))
        
        let okTitle = lang == .english ? "OK" : "حسناً"
        alert.addAction(UIAlertAction(title: okTitle, style: .default))
        
        present(alert, animated: true)
    }
    
    private func showCopiedAlert() {
        let lang = AppSettings.shared.selectedLanguage
        let title = lang == .english ? "Copied!" : "تم النسخ!"
        let message = lang == .english ? "Email address copied to clipboard." : "تم نسخ عنوان البريد الإلكتروني إلى الحافظة."
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: lang == .english ? "OK" : "حسناً", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func leftArrowButtonAction(_ sender: Any) {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        
        let indexPath = IndexPath(item: currentIndex, section: 0)
        ourTeamSaysCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
        
    @IBAction func rightArrowButtonAction(_ sender: Any) {
        guard currentIndex < testimonials.count - 1 else { return }
        currentIndex += 1
        
        let indexPath = IndexPath(item: currentIndex, section: 0)
        ourTeamSaysCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func applyJobButtonAction(_ sender: Any) {
        let storyboard = storyboard?.instantiateViewController(identifier: "CareerApplicationVC") as! CareerApplicationVC
        storyboard.modalPresentationStyle = .fullScreen
        self.present(storyboard, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CareersVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testimonials.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CareersCVC", for: indexPath) as! CareersCVC
        let testimonial = testimonials[indexPath.row]
        cell.questionsTitleLabel.text = testimonial.message
        cell.answersLabel.text = testimonial.descriptions
        cell.teammembersNameLabel.text = testimonial.employeeName
        cell.designationLabel.text = testimonial.jobTitle
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * 0.75
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = ourTeamSaysCollectionView.frame.width * 0.75
        let offset = scrollView.contentOffset.x
        currentIndex = Int(round(offset / pageWidth))
    }
}
