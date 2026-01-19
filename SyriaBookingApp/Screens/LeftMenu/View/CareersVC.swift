//
//  CareersVC.swift
//  NewProject
//
//  Created by Yarramsetti Yedukondalu on 06/08/25.
//

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
    
    var currentIndex = 0
    
    let testimonials: [TestimonialModel] = [
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ourTeamSaysCollectionView.register(UINib(nibName: "CareersCVC", bundle: nil), forCellWithReuseIdentifier: "CareersCVC")
        if let layout = ourTeamSaysCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.estimatedItemSize = .zero
        }
        
        setupEmailLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
    }
    
    private func setupEmailLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(emailLabelTapped))
        emailLabel.isUserInteractionEnabled = true
        emailLabel.addGestureRecognizer(tapGesture)
        
        let fullText = "Email your CV and a brief introduction to: careers@syriabooking.sy\nSubject: [Job Title] – Application – Your Name here"
        
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
            // Check if device can send emails
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
        let alert = UIAlertController(
            title: "Email Not Available",
            message: "There is no email client configured on this device. You can manually send your application to: careers@syriabooking.sy",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Copy Email", style: .default, handler: { _ in
            UIPasteboard.general.string = "careers@syriabooking.sy"
            self.showCopiedAlert()
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    private func showCopiedAlert() {
        let alert = UIAlertController(
            title: "Copied!",
            message: "Email address copied to clipboard.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
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
    
}

extension CareersVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testimonials.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CareersCVC", for: indexPath) as! CareersCVC
        cell.questionsTitleLabel.text = testimonials[indexPath.row].message
        cell.answersLabel.text = testimonials[indexPath.row].descriptions
        cell.teammembersNameLabel.text = testimonials[indexPath.row].employeeName
        cell.designationLabel.text = testimonials[indexPath.row].jobTitle
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
