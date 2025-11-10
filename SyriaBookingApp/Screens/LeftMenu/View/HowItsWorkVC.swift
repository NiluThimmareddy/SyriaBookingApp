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
    @IBOutlet weak var searchForHotelTitleLabel: UILabel!
    @IBOutlet weak var useYourSearchDescriptionLabel: UILabel!
    @IBOutlet weak var compareAndChooseTitleLabel: UILabel!
    @IBOutlet weak var browseDetaildHotelLabel: UILabel!
    @IBOutlet weak var bookInstantlyTitleLabel: UILabel!
    @IBOutlet weak var selectYourRoomLabel: UILabel!
    @IBOutlet weak var receiveConfirmationTitleLabel: UILabel!
    @IBOutlet weak var onceYouBookLabel: UILabel!
    @IBOutlet weak var payAtHotelTitleLabel: UILabel!
    @IBOutlet weak var arriveAtYourHotelLabel: UILabel!
    @IBOutlet weak var howItWorksTitleLabel: UILabel!
    @IBOutlet weak var redefiningTravelDescriptionLabel: UILabel!
    
    
    weak var delegate: YourNotificationVCDelegate?
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTexts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func setupTexts() {
        if AppSettings.shared.selectedLanguage == .arabic {
            howItWorksTitleLabel.text = "كيف تعمل"
            redefiningTravelDescriptionLabel.text = "إعادة تعريف السفر والضيافة داخل سوريا."
            
            descriptionLabel.text = "في SyriaBooking.sy، جعلنا تجربة حجز الفنادق بسيطة وآمنة ومرنة. مع ميزة «الدفع عند الوصول»، يمكنك التخطيط لإقامتك بثقة — دون الحاجة إلى الدفع المسبق!"
            
            searchForHotelTitleLabel.text = "1. ابحث عن الفنادق:"
            useYourSearchDescriptionLabel.text = "استخدم محرك البحث القوي لدينا لاستكشاف الفنادق في جميع أنحاء سوريا. يمكنك التصفية حسب المدينة والسعر وتصنيف النجوم والمرافق وتقييمات الضيوف للعثور على الإقامة المثالية."
            
            compareAndChooseTitleLabel.text = "2. قارن واختر:"
            browseDetaildHotelLabel.text = "تصفح ملفات الفنادق التفصيلية، صور النزلاء الحقيقية، المرافق، وأنواع الغرف. قارن الخيارات واختر الأفضل بناءً على مواعيد سفرك وتفضيلاتك."
            
            bookInstantlyTitleLabel.text = "3. احجز فوراً — بدون دفع مسبق:"
            selectYourRoomLabel.text = "اختر غرفتك، أدخل بياناتك، واضغط «احجز الآن» — هذا كل شيء! لا حاجة لبطاقة ائتمان أو دفع مقدم. سيتم تأكيد حجزك فوراً عبر البريد الإلكتروني أو الرسائل النصية."
            
            receiveConfirmationTitleLabel.text = "4. استلم التأكيد:"
            onceYouBookLabel.text = "بمجرد الحجز، ستتلقى تأكيداً يتضمن جميع تفاصيل الفندق، الاتجاهات، ومعلومات الاتصال. غرفتك محجوزة وجاهزة لاستقبالك."
            
            payAtHotelTitleLabel.text = "5. ادفع في الفندق:"
            arriveAtYourHotelLabel.text = "عند وصولك إلى الفندق، أظهر تأكيد الحجز وادفع مباشرة في مكتب الاستقبال نقداً أو ببطاقة (بحسب ما يقبله الفندق). الأمر بسيط وآمن وخالٍ من الالتزامات."
        } else {
            howItWorksTitleLabel.text = "How It Works"
            redefiningTravelDescriptionLabel.text = "Redefining travel and hospitality within Syria."
            
            descriptionLabel.text = "At SyriaBooking.sy, we’ve made your hotel booking experience simple, secure, and flexible. With our “Pay on Arrival” feature, you can plan your stay with confidence — no prepayment required!"
            
            searchForHotelTitleLabel.text = "1. Search for Hotels:"
            useYourSearchDescriptionLabel.text = "Use our powerful search engine to explore hotels across Syria. Filter by city, price, star rating, amenities, and guest reviews to find the perfect stay that fits your needs."
            
            compareAndChooseTitleLabel.text = "2. Compare & Choose:"
            browseDetaildHotelLabel.text = "Browse detailed hotel profiles, real guest photos, amenities, and room types. Compare options and make the best choice based on your travel dates and preferences."
            
            bookInstantlyTitleLabel.text = "3. Book Instantly — No Payment Required:"
            selectYourRoomLabel.text = "Select your room, enter your details, and click “Book Now” — that’s it! No credit card or advance payment needed. Your reservation will be instantly confirmed via email or SMS."
            
            receiveConfirmationTitleLabel.text = "4. Receive Confirmation:"
            onceYouBookLabel.text = "Once you book, you’ll receive a booking confirmation with all your hotel details, directions, and contact information. Your room is reserved and waiting for you."
            
            payAtHotelTitleLabel.text = "5. Pay at the Hotel:"
            arriveAtYourHotelLabel.text = "Arrive at your hotel, show your booking confirmation, and pay directly at the front desk in cash or by card (as accepted by the hotel). It’s simple, secure, and commitment-free."
        }
    }
}
