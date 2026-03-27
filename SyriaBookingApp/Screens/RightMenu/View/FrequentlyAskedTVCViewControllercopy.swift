//
//  FrequentlyAskedTVCViewController.swift
//  NewProject
//
//  Created by Yarramsetti Yedukondalu on 06/08/25.
//


import UIKit

class FrequentlyAskedTVCViewControllercopy : UIViewController {
        
    @IBOutlet weak var FrequentlyAskedTVC: UITableView!

    @IBOutlet weak var emailUsView: UIView!
    @IBOutlet weak var followUsLinksView: UIView!
    
    var selectedIndexPath: IndexPath?
    var count = ["01","02","03","04","05","06","07","08","09","10"]
    var faqQuestion: [String] = []
    var faqAnswers: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension FrequentlyAskedTVCViewControllercopy: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqQuestion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FrequentlyAskedTVCell", for: indexPath) as! FrequentlyAskedTVCell
        
        let imageName = (selectedIndexPath == indexPath) ? "chevron.down" : "chevron.right"
        cell.imageLabel.image = UIImage(systemName: imageName)
        cell.imageLabel.tintColor = .darkGray
        cell.serialNumLabel.text = count[indexPath.row]
        cell.headLineLabel.text = faqQuestion[indexPath.row]
        cell.descriptionLabel.text = faqAnswers[indexPath.row]
        
        if selectedIndexPath == indexPath {
            cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.15)
            cell.contentView.layer.cornerRadius = 10
        } else {
            cell.contentView.layer.cornerRadius = 6
                 cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.06)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return (selectedIndexPath == indexPath) ? 150 : 71
        } else {
            return (selectedIndexPath == indexPath) ? 180 : 71
            
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10 // spacing
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}

extension FrequentlyAskedTVCViewControllercopy {
    func setUpUI() {
        FrequentlyAskedTVC.register(UINib(nibName: "FrequentlyAskedTVCell", bundle: .main), forCellReuseIdentifier: "FrequentlyAskedTVCell")
        FrequentlyAskedTVC.dataSource = self
        FrequentlyAskedTVC.delegate = self
        
        setupLanguageContent()
        setupEmailUsView()
        setupSocialMediaView()
    }
    
    private func setupSocialMediaView() {
        let nib = UINib(nibName: "SocialMedia", bundle: nil)
        guard let socialView = nib.instantiate(withOwner: nil, options: nil).first as? SocialMediaView else {
            return
        }

        followUsLinksView.addSubview(socialView)

        socialView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            socialView.topAnchor.constraint(equalTo: followUsLinksView.topAnchor),
            socialView.bottomAnchor.constraint(equalTo: followUsLinksView.bottomAnchor),
            socialView.leadingAnchor.constraint(equalTo: followUsLinksView.leadingAnchor),
            socialView.trailingAnchor.constraint(equalTo: followUsLinksView.trailingAnchor)
        ])
    }
    
    private func setupEmailUsView() {
        let nib = UINib(nibName: "EmailIDView", bundle: nil)
        guard let emailView = nib.instantiate(withOwner: nil, options: nil).first as? EmailIDView else {
            return
        }

        emailUsView.addSubview(emailView)
        emailView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emailView.topAnchor.constraint(equalTo: emailUsView.topAnchor),
            emailView.bottomAnchor.constraint(equalTo: emailUsView.bottomAnchor),
            emailView.leadingAnchor.constraint(equalTo: emailUsView.leadingAnchor),
            emailView.trailingAnchor.constraint(equalTo: emailUsView.trailingAnchor)
        ])
    }
    
    func setupLanguageContent() {
        if AppSettings.shared.selectedLanguage == .arabic {
            
            faqQuestion = [
                "كيف أحجز فندقاً على SyriaBooking.sy؟",
                "هل يجب أن أدفع مقدماً؟",
                "هل يتم تأكيد الحجز على الفور؟",
                "هل يمكنني إلغاء أو تعديل الحجز؟",
                "هل أحتاج إلى بطاقة ائتمان للحجز؟",
                "كيف أعرف أن الفندق موثوق؟",
                "ما طرق الدفع المقبولة في الفندق؟",
                "لم أستلم تأكيد الحجز، ماذا أفعل؟",
                "هل توجد رسوم للحجز؟",
                "هل يتوفر دعم العملاء؟"
            ]
            
            faqAnswers = [
                "ابحث عن وجهتك، اختر تواريخ سفرك، تصفح الفنادق المتاحة، وانقر على 'احجز الآن' للفندق المفضل لديك. لا يلزم الدفع المسبق أو بطاقة الائتمان — سيتم تأكيد حجزك فوراً.",
                "لا. تتبع SyriaBooking.sy نموذج “الدفع عند الوصول”. ستدفع مباشرة في الفندق عند تسجيل الوصول، نقداً أو ببطاقة (حسب قبول الفندق).",
                "نعم. بمجرد إكمال الحجز، ستتلقى تأكيداً عبر البريد الإلكتروني أو رسالة نصية على الفور. غرفتك محجوزة ومضمونة من قبل الفندق.",
                "نعم، معظم الفنادق توفر الإلغاء المجاني أو التعديل حتى وقت معين قبل تسجيل الوصول. تحقق دائماً من سياسة الإلغاء الخاصة بالفندق في صفحة الحجز أو في بريد التأكيد.",
                "لا. على عكس المنصات الأخرى، لا نطلب بطاقة ائتمان أو تفاصيل دفع عند الحجز.",
                "جميع الفنادق المدرجة على SyriaBooking.sy معتمدة ومتحققة من قبل فريقنا المحلي. نقوم بتحديث القوائم بانتظام بالصور والوصف والتقييمات الحقيقية.",
                "تقبل معظم الفنادق النقد بالليرة السورية والدولار الأمريكي. قد تقبل بعض الفنادق بطاقات الائتمان/الخصم. تحقق من ملف الفندق للخيارات المقبولة قبل الحجز.",
                "يرجى التحقق من مجلد البريد غير المرغوب فيه أولاً. إذا لم تتلق التأكيد خلال 5 دقائق، اتصل بدعم العملاء على info@syriabooking.sy أو هاتف الدعم.",
                "لا. لا تفرض SyriaBooking.sy أي رسوم للحجز أو الخدمة. تدفع فقط مقابل إقامتك مباشرة للفندق.",
                "نعم. يتوفر فريق دعم العملاء المحلي لدينا 7 أيام في الأسبوع لمساعدتك في الحجز أو الإلغاء أو أي استفسارات. نحن هنا لجعل رحلتك بلا قلق."
            ]
        } else {
            faqQuestion = [
                "How do I book a hotel on SyriaBooking.sy?",
                "Do I need to pay in advance?",
                "Is my booking confirmed immediately?",
                "Can I cancel or modify my booking?",
                "Do I need a credit card to book?",
                "How do I know the hotel is legitimate?",
                "What payment methods are accepted at the hotel?",
                "I didn’t receive my booking confirmation. What should I do?",
                "Are there any booking fees?",
                "Is customer support available?"
            ]
            
            faqAnswers = [
                "Simply search for your destination, select your travel dates, browse the available hotels, and click 'Book Now' on your preferred property. No prepayment or credit card is required — your booking will be confirmed instantly.",
                "No. SyriaBooking.sy follows a “Pay on Arrival” model. You will pay directly at the hotel upon check-in, in cash or by card (as accepted by the hotel).",
                "Yes. Once you complete your booking, you will receive a confirmation email or SMS instantly. Your room is reserved and guaranteed by the hotel.",
                "Yes, most hotels offer free cancellation or modifications up to a certain time before check-in. Always check the hotel’s cancellation policy on the booking page or in your confirmation email.",
                "No. Unlike other platforms, we do not require a credit card or payment details at the time of booking.",
                "All hotels listed on SyriaBooking.sy are verified and approved by our local team. We regularly update listings with accurate photos, descriptions, and reviews from real guests.",
                "Most hotels accept cash in Syrian Pounds and US Dollar. Some may also accept credit/debit cards. Check the hotel’s profile for accepted payment options before booking.",
                "Please check your spam/junk folder first. If you still haven’t received it within 5 minutes, contact our customer support at info@syriabooking.sy or call our helpline.",
                "No. SyriaBooking.sy does not charge any booking or service fees. You pay only for your stay, directly to the hotel.",
                "Yes. Our local customer support team is available 7 days a week to assist with bookings, cancellations, or any inquiries. We're here to help you travel worry-free."
            ]
        }
    }
}


