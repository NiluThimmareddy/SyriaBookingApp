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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
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
