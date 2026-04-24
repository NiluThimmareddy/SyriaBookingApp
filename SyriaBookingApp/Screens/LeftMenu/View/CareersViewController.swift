//
//  CareersViewController.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 23/03/26.

import UIKit

struct WorkWithUsModel {
    var imageview : String
    var iconImgView : String
    var title : String
    var description : String
}

struct TestimonialModel: Codable {
    let message: String
    let descriptions: String
    let employeeName: String
    let jobTitle: String
}

class CareersViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var insideScrollView: UIView!
    @IBOutlet weak var redefineTravelTitleLabel: UILabel!
    @IBOutlet weak var careersAtSyriabokkingTitleLabel: UILabel!
    @IBOutlet weak var joinTheTeamLabel: UILabel!
    @IBOutlet weak var applyForJobButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var atSyriaBokkingsyLabel: UILabel!
    @IBOutlet weak var whetherYouareTechExpertLabel: UILabel!
    @IBOutlet weak var whyWorkWithUsTitleLabel: UILabel!
    @IBOutlet weak var whyWorkWithUsCollectionView: UICollectionView!
    @IBOutlet weak var didnotSeeRoleTitleLabel: UILabel!
    @IBOutlet weak var weAreAlwaysOpenToHearingLabel: UILabel!
    @IBOutlet weak var readyToBuildTitleLabel: UILabel!
    @IBOutlet weak var bePartOfSomethingLabel: UILabel!
    @IBOutlet weak var whatOurTeamSaysLabel: UILabel!
    @IBOutlet weak var whatOurTeamSaysCollectionView: UICollectionView!
    @IBOutlet weak var leftArrowButton: UIButton!
    @IBOutlet weak var rightArrowButton: UIButton!
    @IBOutlet weak var howToApplyLabel: UILabel!
    @IBOutlet weak var readyToMakeAnImpactLabel: UILabel!
    @IBOutlet weak var careersEmailButton: UIButton!
    @IBOutlet weak var careerImageView: UIImageView!
    @IBOutlet weak var followLinksView: UIView!
    
    var currentIndex = 0
    
    let workWithUs: [WorkWithUsModel] = [
        WorkWithUsModel(imageview: "ic_inovateLocally", iconImgView: "ic_Bulb", title: "Innovate Locally, Impact Nationally", description: "Be part of a pioneering tech company creating real change in the Syrian travel and tourism industry."),
        WorkWithUsModel(imageview: "ic_collabrative", iconImgView: "ic_PersonBorder", title: "Collaborative & Supportive Culture", description: "We value teamwork, open communication, and mutual growth. Your voice matters here."),
        WorkWithUsModel(imageview: "ic_CareerPersonImg", iconImgView: "ic_CareerGrowth", title: "Career Growth Opportunities", description: "We’re growing fast — and so will you. Learn, lead, and take your career to the next level."),
        WorkWithUsModel(imageview: "ic_businessImg", iconImgView: "ic_workPurpose", title: "Work With Purpose", description: "Your work will directly help travelers, support local businesses, and showcase the beauty of Syria to the world.")
    ]
    
    // Arabic work with us data
    let arabicWorkWithUs: [WorkWithUsModel] = [
        WorkWithUsModel(imageview: "ic_inovateLocally", iconImgView: "ic_Bulb", title: "ابتكر محلياً، أثر وطنياً", description: "كن جزءاً من شركة تقنية رائدة تحدث تغييراً حقيقياً في صناعة السفر والسياحة السورية."),
        WorkWithUsModel(imageview: "ic_collabrative", iconImgView: "ic_PersonBorder", title: "ثقافة تعاونية وداعمة", description: "نحن نقدر العمل الجماعي، والتواصل المفتوح، والنمو المتبادل. صوتك مهم هنا."),
        WorkWithUsModel(imageview: "ic_CareerPersonImg", iconImgView: "ic_CareerGrowth", title: "فرص النمو الوظيفي", description: "نحن ننمو بسرعة - وكذلك ستنمو أنت. تعلم، قُد، واصطحب مسيرتك المهنية إلى المستوى التالي."),
        WorkWithUsModel(imageview: "ic_businessImg", iconImgView: "ic_workPurpose", title: "اعمل بهدف", description: "عملك سيساعد المسافرين مباشرة، ويدعم الأعمال المحلية، ويعرض جمال سوريا للعالم.")
    ]
    
    var currentWorkWithUsData: [WorkWithUsModel] {
        return AppSettings.shared.selectedLanguage == .arabic ? arabicWorkWithUs : workWithUs
    }
    
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
        
        whyWorkWithUsCollectionView.register(UINib(nibName: "WhyWorkWithUsCVC", bundle: nil), forCellWithReuseIdentifier: "WhyWorkWithUsCVC")
        if let layout = whyWorkWithUsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.estimatedItemSize = .zero
        }
        whatOurTeamSaysCollectionView.register(UINib(nibName: "CareersCVC", bundle: nil), forCellWithReuseIdentifier: "CareersCVC")
        if let layout = whatOurTeamSaysCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.estimatedItemSize = .zero
        }
        careerImageView.applyFullBlackGradientOverlay()
        setupSocialMediaView()
        
        updateTexts()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        let bold16Font = UIFont.boldSystemFont(ofSize: 16)
        
        if lang == .arabic {
            // Arabic texts
            redefineTravelTitleLabel.text = "إعادة تعريف السفر في سوريا"
            careersAtSyriabokkingTitleLabel.text = "وظائف في سيريا بوكينغ"
            joinTheTeamLabel.text = "انضم إلى الفريق الذي يقف وراء منصة حجز الفنادق الرائدة في سوريا."
            atSyriaBokkingsyLabel.text = "في SyriaBooking.sy، نحن في مهمة لتحويل كيفية استكشاف وتجربة سوريا - من خلال جعل السفر أبسط وأذكى وأكثر سهولة للجميع. نحن نبني المنصة الرائدة في البلاد لحجز الفنادق، ونبحث عن أفراد متحمسين لينموا معنا."
            whetherYouareTechExpertLabel.text = "سواء كنت خبير تقني، أو بطل خدمة عملاء، أو راوي قصص مبدع، أو استراتيجي أعمال - إذا كنت تؤمن بالابتكار والنزاهة والتأثير، فستشعر وكأنك في منزلك هنا."
            whyWorkWithUsTitleLabel.text = "لماذا تعمل معنا؟"
            didnotSeeRoleTitleLabel.text = "لم ترَ دوراً مناسباً؟"
            weAreAlwaysOpenToHearingLabel.text = "نحن دائماً منفتحون لسماع آراء المحترفين المتحمسين. أرسل لنا سيرتك الذاتية على أي حال!"
            readyToBuildTitleLabel.text = "هل أنت مستعد لبناء مستقبل السفر في سوريا؟"
            bePartOfSomethingLabel.text = "كن جزءاً من شيء مؤثر. انضم إلى سيريا بوكينغ. السفر يبدأ من هنا."
            whatOurTeamSaysLabel.text = "ماذا يقول فريقنا!"
            howToApplyLabel.text = "كيفية التقديم"
            readyToMakeAnImpactLabel.text = "هل أنت مستعد لإحداث تأثير؟ أرسل سيرتك الذاتية ومجموعة أعمالك إلى فريقنا."
            
            // Apply for Job button with bold 16 font
            let applyButtonTitle = NSAttributedString(
                string: "تقدم لوظيفة",
                attributes: [
                    .font: bold16Font,
                    .foregroundColor: applyForJobButton.titleColor(for: .normal) ?? .white
                ]
            )
            applyForJobButton.setAttributedTitle(applyButtonTitle, for: .normal)
            
        } else {
            // English texts
            redefineTravelTitleLabel.text = "REDEFINING TRAVEL IN SYRIA"
            careersAtSyriabokkingTitleLabel.text = "Careers at SyriaBooking.sy"
            joinTheTeamLabel.text = "Join the team behind Syria’s leading hotel booking platform."
            atSyriaBokkingsyLabel.text = "At SyriaBooking.sy, we’re on a mission to transform how people explore and experience Syria — by making travel simpler, smarter, and more accessible for everyone. We’re building the country’s go-to platform for hotel bookings, and we’re looking for passionate individuals to grow with us."
            whetherYouareTechExpertLabel.text = "Whether you’re a tech expert, customer service champion, creative storyteller, or business strategist — if you believe in innovation, integrity, and impact, you’ll feel at home here."
            whyWorkWithUsTitleLabel.text = "Why Work With Us?"
            didnotSeeRoleTitleLabel.text = "Didn’t see a role that fits?"
            weAreAlwaysOpenToHearingLabel.text = "We’re always open to hearing from passionate professionals. Send us your CV anyway!"
            readyToBuildTitleLabel.text = "Ready to Build the Future of Travel in Syria?"
            bePartOfSomethingLabel.text = "Be part of something impactful. Join SyriaBooking.sy. Travel Starts Here."
            whatOurTeamSaysLabel.text = "What Our Team Says!"
            howToApplyLabel.text = "How to Apply"
            readyToMakeAnImpactLabel.text = "Ready to make an impact? Send your CV and portfolio to our team."
            
            // Apply for Job button with bold 16 font
            let applyButtonTitle = NSAttributedString(
                string: "Apply for a Job",
                attributes: [
                    .font: bold16Font,
                    .foregroundColor: applyForJobButton.titleColor(for: .normal) ?? .white
                ]
            )
            applyForJobButton.setAttributedTitle(applyButtonTitle, for: .normal)
        }
        
        // Reload collection views with updated data
        whyWorkWithUsCollectionView.reloadData()
        whatOurTeamSaysCollectionView.reloadData()
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
    
    @IBAction func applyForJobButtonAction(_ sender: Any) {
        guard let storyboard = storyboard?.instantiateViewController(identifier: "CareerApplicationVC") as? CareerApplicationVC else { return }
        storyboard.modalPresentationStyle = .fullScreen
        self.present(storyboard, animated: true)
    }
    
    @IBAction func leftArrowButtonAction(_ sender: Any) {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        
        let indexPath = IndexPath(item: currentIndex, section: 0)
        whatOurTeamSaysCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func rightArrowButtonAction(_ sender: Any) {
        guard currentIndex < testimonials.count - 1 else { return }
        currentIndex += 1
        
        let indexPath = IndexPath(item: currentIndex, section: 0)
        whatOurTeamSaysCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func careersEmailButtonAction(_ sender: Any) {
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CareersViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == whyWorkWithUsCollectionView {
            return currentWorkWithUsData.count
        } else if collectionView == whatOurTeamSaysCollectionView {
            return testimonials.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == whyWorkWithUsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WhyWorkWithUsCVC", for: indexPath) as! WhyWorkWithUsCVC
            let whyWorkData = currentWorkWithUsData[indexPath.row]
            cell.imgView.image = UIImage(named: "\(whyWorkData.imageview)")
            cell.iconImgView.image = UIImage(named: "\(whyWorkData.iconImgView)")
            cell.titleLabel.text = whyWorkData.title
            cell.descriptionLabel.text = whyWorkData.description
            return cell
        } else if collectionView == whatOurTeamSaysCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CareersCVC", for: indexPath) as! CareersCVC
            let testimonial = testimonials[indexPath.row]
            cell.questionsTitleLabel.text = testimonial.message
            cell.answersLabel.text = testimonial.descriptions
            cell.teammembersNameLabel.text = testimonial.employeeName
            cell.designationLabel.text = testimonial.jobTitle
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WhyWorkWithUsCVC", for: indexPath) as! WhyWorkWithUsCVC
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == whyWorkWithUsCollectionView {
            if UIDevice.current.userInterfaceIdiom == .pad {
                let width = collectionView.frame.width * 0.5 - 20
                let height = collectionView.frame.height
                return CGSize(width: width, height: height)
            } else {
                let width = collectionView.frame.width * 0.75 - 20
                let height = collectionView.frame.height
                return CGSize(width: width, height: height)
            }
        } else if collectionView == whatOurTeamSaysCollectionView {
            if UIDevice.current.userInterfaceIdiom == .pad {
                let width = collectionView.frame.width * 0.5 - 10
                let height = collectionView.frame.height
                return CGSize(width: width, height: height)
            } else {
                let width = collectionView.frame.width * 0.75
                let height = collectionView.frame.height
                return CGSize(width: width, height: height)
            }
        } else {
            let width = collectionView.frame.width * 0.75
            let height = collectionView.frame.height
            return CGSize(width: width, height: height)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = whatOurTeamSaysCollectionView.frame.width * 0.75
        let offset = scrollView.contentOffset.x
        currentIndex = Int(round(offset / pageWidth))
    }
}
