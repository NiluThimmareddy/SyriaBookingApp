//
//  SplashScreensVC.swift
//  HotelBooking
//
//  Created by toqsoft on 15/07/25.
//

import UIKit

class SplashScreensVC: UIViewController {

    @IBOutlet weak var splashImagesView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextPageButton: UIButton!
    
    var splashData: [SplashData] = [
        SplashData(imageName: "ic_splashScreen4", title: "Away from Home, Yet Feels Like Home", description: "Enjoy the warmth, comfort, and care of home wherever you go"),
        SplashData(imageName: "ic_splashScreen5", title: "Seamless Booking, Exceptional Services", description: "Book your stay, explore amenities, and enjoy exclusive deals—all in one place"),
        SplashData(imageName: "ic_splashScreen6", title: "Customized Especially for You", description: "Get personalized recommendations and offers to make your stay unforgettable.")
    ]
    
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    @IBAction func pageControlAction(_ sender: UIPageControl) {
        currentPage = sender.currentPage
        updateContent()
    }
    
    @IBAction func skipButtonAction(_ sender: UIButton) {
        openHomePage()
    }
    
    @IBAction func nextPageButtonAction(_ sender: UIButton) {
        if currentPage < splashData.count - 1 {
            currentPage += 1
            updateContent()
        } else {
            openHomePage()
        }
    }
    
    func openHomePage(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "CustomTabBarController") as? UITabBarController {
            tabBarVC.modalPresentationStyle = .fullScreen
            self.present(tabBarVC, animated: true)
        }
    }
}

extension SplashScreensVC {
    
    func setUpUI() {
        pageControl.numberOfPages = splashData.count
        pageControl.currentPage = currentPage
        updateContent()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    func updateContent() {
        let data = splashData[currentPage]
        splashImagesView.image = UIImage(named: data.imageName)
        pageControl.currentPage = currentPage

        if currentPage == splashData.count - 1 {
            nextPageButton.setTitle("Get Started", for: .normal)
            nextPageButton.setImage(nil, for: .normal)
            nextPageButton.setImage(nil, for: .highlighted)
            nextPageButton.setImage(nil, for: .selected)
            nextPageButton.configuration = nil
            nextPageButton.semanticContentAttribute = .forceLeftToRight
            nextPageButton.titleEdgeInsets = .zero
            nextPageButton.imageEdgeInsets = .zero
            nextPageButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            skipButton.isHidden = true
        } else {
            nextPageButton.setTitle("", for: .normal)
            let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
            let arrowImage = UIImage(systemName: "chevron.right", withConfiguration: config)
            nextPageButton.setImage(arrowImage, for: .normal)
            nextPageButton.semanticContentAttribute = .unspecified
            nextPageButton.titleEdgeInsets = .zero
            nextPageButton.imageEdgeInsets = .zero
            nextPageButton.contentEdgeInsets = .zero
            skipButton.isHidden = false
        }
    }


    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if currentPage < splashData.count - 1 {
                currentPage += 1
                updateContent()
            }
        } else if gesture.direction == .right {
            if currentPage > 0 {
                currentPage -= 1
                updateContent()
            }
        }
    }
}
