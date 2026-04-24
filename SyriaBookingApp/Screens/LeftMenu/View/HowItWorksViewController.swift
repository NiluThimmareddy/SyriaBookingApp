//
//  HowItWorksViewController.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 24/03/26.
//

import UIKit

class HowItWorksViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var insideScrollView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var howItWorksTitleLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchForHotelTitleLabel: UILabel!
    @IBOutlet weak var useOurPowerFullSearchLabel: UILabel!
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var compareView: UIView!
    @IBOutlet weak var compareAndChooseLabel: UILabel!
    @IBOutlet weak var browseDetailedLabel: UILabel!
    @IBOutlet weak var compareViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bookInstantlyView: UIView!
    @IBOutlet weak var bookInstantlyLabel: UILabel!
    @IBOutlet weak var selectYourRoomLabel: UILabel!
    @IBOutlet weak var bookInstantlyHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var receiveView: UIView!
    @IBOutlet weak var receiveConfirmationLabel: UILabel!
    @IBOutlet weak var onceYouBookLabel: UILabel!
    @IBOutlet weak var receiveViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var payView: UIView!
    @IBOutlet weak var payAtHotelLabel: UILabel!
    @IBOutlet weak var arriveAtHotelLabel: UILabel!
    @IBOutlet weak var payViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var followLinksView: UIView!
    @IBOutlet var numberoneLabels: UILabel!
    @IBOutlet var numbertwoLabels: UILabel!
    @IBOutlet var numberthreeLabels: UILabel!
    @IBOutlet var numberfourLabels: UILabel!
    @IBOutlet var numberfiveLabels: UILabel!
    
    private var isSearchExpanded = false
    private var isCompareExpanded = false
    private var isBookExpanded = false
    private var isReceiveExpanded = false
    private var isPayExpanded = false
    
    private var originalSearchHeight: CGFloat = 107
    private var originalCompareHeight: CGFloat = 107
    private var originalBookHeight: CGFloat = 107
    private var originalReceiveHeight: CGFloat = 107
    private var originalPayHeight: CGFloat = 107
    
    // MARK: - English Texts
    private let englishSearchFullText = "Use our powerful search engine to explore hotels across Syria. Filter by city, price, star rating, amenities, and guest reviews to find the perfect stay that fits your needs."
    private let englishCompareFullText = "Browse detailed hotel profiles, real guest photos, amenities, and room types. Compare options and make the best choice based on your travel dates and preferences."
    private let englishBookFullText = "Select your room, enter your details, and click \"Book Now\" — that's it! No credit card or advance payment needed. Your reservation will be instantly confirmed via email or SMS."
    private let englishReceiveFullText = "Once you book, you'll receive a booking confirmation with all your hotel details, directions, and contact information. Your room is reserved and waiting for you."
    private let englishPayFullText = "Arrive at your hotel, show your booking confirmation, and pay directly at the front desk in cash or by card (as accepted by the hotel). It's simple, secure, and commitment-free."
    
    private let englishSearchShortText = "Use our powerful search engine to "
    private let englishCompareShortText = "Browse detailed hotel profiles, real guest photos, "
    private let englishBookShortText = "Select your room, enter your details, and click "
    private let englishReceiveShortText = "Once you book, you'll receive a booking "
    private let englishPayShortText = "Arrive at your hotel, show your booking "
    
    // MARK: - Arabic Texts
    private let arabicSearchFullText = "استخدم محرك البحث القوي الخاص بنا لاستكشاف الفنادق في جميع أنحاء سوريا. قم بالتصفية حسب المدينة، السعر، التقييم بالنجوم، المرافق، وتقييمات النزلاء للعثور على الإقامة المثالية التي تناسب احتياجاتك."
    private let arabicCompareFullText = "تصفح ملفات الفنادق التفصيلية، صور النزلاء الحقيقية، المرافق، وأنواع الغرف. قارن الخيارات واختر أفضل خيار بناءً على تواريخ سفرك وتفضيلاتك."
    private let arabicBookFullText = "اختر غرفتك، أدخل تفاصيلك، وانقر على \"احجز الآن\" — هذا كل شيء! لا حاجة لبطاقة ائتمان أو دفع مسبق. سيتم تأكيد حجزك فوراً عبر البريد الإلكتروني أو الرسائل القصيرة."
    private let arabicReceiveFullText = "بمجرد حجزك، ستتلقى تأكيد الحجز مع جميع تفاصيل الفندق، الاتجاهات، ومعلومات الاتصال. غرفتك محجوزة وفي انتظارك."
    private let arabicPayFullText = "عند وصولك إلى الفندق، اعرض تأكيد حجزك، وادفع مباشرة في مكتب الاستقبال نقداً أو ببطاقة الائتمان (كما هو مقبول في الفندق). إنه بسيط وآمن وبدون التزامات."
    
    private let arabicSearchShortText = "استخدم محرك البحث القوي الخاص بنا لـ "
    private let arabicCompareShortText = "تصفح ملفات الفنادق التفصيلية، صور النزلاء الحقيقية، "
    private let arabicBookShortText = "اختر غرفتك، أدخل تفاصيلك، وانقر على "
    private let arabicReceiveShortText = "بمجرد حجزك، ستتلقى تأكيد "
    private let arabicPayShortText = "عند وصولك إلى الفندق، اعرض تأكيد "
    
    private let englishReadMoreText = "Read More"
    private let englishShowLessText = "\n\nShow Less"
    
    private let arabicReadMoreText = "اقرأ المزيد"
    private let arabicShowLessText = "\n\nإظهار أقل"
    
    // MARK: - Computed Properties
    private var searchFullText: String {
        return AppSettings.shared.selectedLanguage == .arabic ? arabicSearchFullText : englishSearchFullText
    }
    
    private var compareFullText: String {
        return AppSettings.shared.selectedLanguage == .arabic ? arabicCompareFullText : englishCompareFullText
    }
    
    private var bookFullText: String {
        return AppSettings.shared.selectedLanguage == .arabic ? arabicBookFullText : englishBookFullText
    }
    
    private var receiveFullText: String {
        return AppSettings.shared.selectedLanguage == .arabic ? arabicReceiveFullText : englishReceiveFullText
    }
    
    private var payFullText: String {
        return AppSettings.shared.selectedLanguage == .arabic ? arabicPayFullText : englishPayFullText
    }
    
    private var searchShortText: String {
        return AppSettings.shared.selectedLanguage == .arabic ? arabicSearchShortText : englishSearchShortText
    }
    
    private var compareShortText: String {
        return AppSettings.shared.selectedLanguage == .arabic ? arabicCompareShortText : englishCompareShortText
    }
    
    private var bookShortText: String {
        return AppSettings.shared.selectedLanguage == .arabic ? arabicBookShortText : englishBookShortText
    }
    
    private var receiveShortText: String {
        return AppSettings.shared.selectedLanguage == .arabic ? arabicReceiveShortText : englishReceiveShortText
    }
    
    private var payShortText: String {
        return AppSettings.shared.selectedLanguage == .arabic ? arabicPayShortText : englishPayShortText
    }
    
    private var readMoreText: String {
        return AppSettings.shared.selectedLanguage == .arabic ? arabicReadMoreText : englishReadMoreText
    }
    
    private var showLessText: String {
        return AppSettings.shared.selectedLanguage == .arabic ? arabicShowLessText : englishShowLessText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [searchView, compareView, bookInstantlyView, receiveView, payView].forEach { shadow in
            shadow?.applyCardStyle()
        }
        [numberoneLabels, numbertwoLabels,numberthreeLabels,numberfourLabels,numberfiveLabels].forEach { numberLabels in
            numberLabels?.clipsToBounds = true
        }
        imageView.applyFullLightBlackGradientOverlay()
        setupSocialMediaView()
        storeOriginalHeights()
        
        // Set initial texts
        updateTexts()
        
        configureLabels()
        setupInitialLabels()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        
        if lang == .arabic {
            howItWorksTitleLabel.text = "كيف يعمل – احجز إقامتك في سوريا بكل سهولة"
            searchForHotelTitleLabel.text = "البحث عن فندق"
            compareAndChooseLabel.text = "قارن واختر"
            bookInstantlyLabel.text = "احجز فوراً"
            receiveConfirmationLabel.text = "استلام التأكيد"
            payAtHotelLabel.text = "ادفع في الفندق"
        } else {
            howItWorksTitleLabel.text = "How It Works – Book Your Stay in Syria with Ease"
            searchForHotelTitleLabel.text = "Search for Hotel"
            compareAndChooseLabel.text = "Compare & Choose"
            bookInstantlyLabel.text = "Book Instantly"
            receiveConfirmationLabel.text = "Receive Confirmation"
            payAtHotelLabel.text = "Pay at Hotel"
        }
        
        // Reset expansion states when language changes
        resetAllSections()
        
        // Re-setup initial labels with new language texts
        setupInitialLabels()
    }
    
    private func resetAllSections() {
        // Reset expansion flags
        isSearchExpanded = false
        isCompareExpanded = false
        isBookExpanded = false
        isReceiveExpanded = false
        isPayExpanded = false
        
        // Reset height constraints to original
        searchViewHeightConstraint.constant = originalSearchHeight
        compareViewHeightConstraint.constant = originalCompareHeight
        bookInstantlyHeightConstraint.constant = originalBookHeight
        receiveViewHeightConstraint.constant = originalReceiveHeight
        payViewHeightConstraint.constant = originalPayHeight
        
        view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
    }
    
    private func storeOriginalHeights() {
        originalSearchHeight = searchViewHeightConstraint.constant
        originalCompareHeight = compareViewHeightConstraint.constant
        originalBookHeight = bookInstantlyHeightConstraint.constant
        originalReceiveHeight = receiveViewHeightConstraint.constant
        originalPayHeight = payViewHeightConstraint.constant
    }
    
    private func configureLabels() {
        let labels = [useOurPowerFullSearchLabel, browseDetailedLabel, selectYourRoomLabel, onceYouBookLabel, arriveAtHotelLabel]
        labels.forEach { label in
            label?.numberOfLines = 0
            label?.lineBreakMode = .byWordWrapping
            label?.isUserInteractionEnabled = true
        }
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
    
    private func setupInitialLabels() {
        setupLabelWithReadMore(
            label: useOurPowerFullSearchLabel,
            shortText: searchShortText,
            action: #selector(searchLabelTapped)
        )
        
        setupLabelWithReadMore(
            label: browseDetailedLabel,
            shortText: compareShortText,
            action: #selector(compareLabelTapped)
        )
        
        setupLabelWithReadMore(
            label: selectYourRoomLabel,
            shortText: bookShortText,
            action: #selector(bookLabelTapped)
        )
        
        setupLabelWithReadMore(
            label: onceYouBookLabel,
            shortText: receiveShortText,
            action: #selector(receiveLabelTapped)
        )
        
        setupLabelWithReadMore(
            label: arriveAtHotelLabel,
            shortText: payShortText,
            action: #selector(payLabelTapped)
        )
    }
    
    private func setupLabelWithReadMore(label: UILabel, shortText: String, action: Selector) {
        let attributedString = NSMutableAttributedString(string: shortText)
        let readMoreAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: label.font.pointSize, weight: .bold),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        attributedString.append(NSAttributedString(string: readMoreText, attributes: readMoreAttributes))
        label.attributedText = attributedString
        
        label.gestureRecognizers?.forEach { label.removeGestureRecognizer($0) }
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
    }
    
    private func setupLabelWithShowLess(label: UILabel, fullText: String, action: Selector) {
        let attributedString = NSMutableAttributedString(string: fullText)
        let showLessAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: label.font.pointSize, weight: .bold),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        attributedString.append(NSAttributedString(string: showLessText, attributes: showLessAttributes))
        label.attributedText = attributedString
        
        label.gestureRecognizers?.forEach { label.removeGestureRecognizer($0) }
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
    }
    
    // MARK: - Tap Actions
    
    @objc private func searchLabelTapped() {
        if !isSearchExpanded {
            isSearchExpanded = true
            expandSection(
                label: useOurPowerFullSearchLabel,
                fullText: searchFullText,
                heightConstraint: searchViewHeightConstraint,
                expandedHeight: 200,
                action: #selector(searchShowLessTapped)
            )
        }
    }
    
    @objc private func compareLabelTapped() {
        if !isCompareExpanded {
            isCompareExpanded = true
            expandSection(
                label: browseDetailedLabel,
                fullText: compareFullText,
                heightConstraint: compareViewHeightConstraint,
                expandedHeight: 200,
                action: #selector(compareShowLessTapped)
            )
        }
    }
    
    @objc private func bookLabelTapped() {
        if !isBookExpanded {
            isBookExpanded = true
            expandSection(
                label: selectYourRoomLabel,
                fullText: bookFullText,
                heightConstraint: bookInstantlyHeightConstraint,
                expandedHeight: 200,
                action: #selector(bookShowLessTapped)
            )
        }
    }
    
    @objc private func receiveLabelTapped() {
        if !isReceiveExpanded {
            isReceiveExpanded = true
            expandSection(
                label: onceYouBookLabel,
                fullText: receiveFullText,
                heightConstraint: receiveViewHeightConstraint,
                expandedHeight: 200,
                action: #selector(receiveShowLessTapped)
            )
        }
    }
    
    @objc private func payLabelTapped() {
        if !isPayExpanded {
            isPayExpanded = true
            expandSection(
                label: arriveAtHotelLabel,
                fullText: payFullText,
                heightConstraint: payViewHeightConstraint,
                expandedHeight: 200,
                action: #selector(payShowLessTapped)
            )
        }
    }
    
    // MARK: - Show Less Actions
    
    @objc private func searchShowLessTapped() {
        isSearchExpanded = false
        collapseSection(
            label: useOurPowerFullSearchLabel,
            shortText: searchShortText,
            heightConstraint: searchViewHeightConstraint,
            originalHeight: originalSearchHeight,
            action: #selector(searchLabelTapped)
        )
    }
    
    @objc private func compareShowLessTapped() {
        isCompareExpanded = false
        collapseSection(
            label: browseDetailedLabel,
            shortText: compareShortText,
            heightConstraint: compareViewHeightConstraint,
            originalHeight: originalCompareHeight,
            action: #selector(compareLabelTapped)
        )
    }
    
    @objc private func bookShowLessTapped() {
        isBookExpanded = false
        collapseSection(
            label: selectYourRoomLabel,
            shortText: bookShortText,
            heightConstraint: bookInstantlyHeightConstraint,
            originalHeight: originalBookHeight,
            action: #selector(bookLabelTapped)
        )
    }
    
    @objc private func receiveShowLessTapped() {
        isReceiveExpanded = false
        collapseSection(
            label: onceYouBookLabel,
            shortText: receiveShortText,
            heightConstraint: receiveViewHeightConstraint,
            originalHeight: originalReceiveHeight,
            action: #selector(receiveLabelTapped)
        )
    }
    
    @objc private func payShowLessTapped() {
        isPayExpanded = false
        collapseSection(
            label: arriveAtHotelLabel,
            shortText: payShortText,
            heightConstraint: payViewHeightConstraint,
            originalHeight: originalPayHeight,
            action: #selector(payLabelTapped)
        )
    }
    
    private func expandSection(label: UILabel, fullText: String, heightConstraint: NSLayoutConstraint, expandedHeight: CGFloat, action: Selector) {
        setupLabelWithShowLess(label: label, fullText: fullText, action: action)
        
        heightConstraint.constant = expandedHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func collapseSection(label: UILabel, shortText: String, heightConstraint: NSLayoutConstraint, originalHeight: CGFloat, action: Selector) {
        setupLabelWithReadMore(label: label, shortText: shortText, action: action)
        heightConstraint.constant = originalHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
