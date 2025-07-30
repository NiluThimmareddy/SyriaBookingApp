//
//  HomeViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var leftMenuBarButton: UIBarButtonItem!
    @IBOutlet weak var notificationBarButton: UIBarButtonItem!
    @IBOutlet weak var rightMenuBarButton: UIBarButtonItem!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var selectCityButton: UIButton!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var checkOutButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var topHotelsCollectionView: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var dealsview: UIView!
    @IBOutlet weak var dealOfferLabel: UILabel!
    @IBOutlet weak var findDealButton: UIButton!
    @IBOutlet weak var promotionsCollectionView: UICollectionView!
    @IBOutlet weak var recentlyCollectionView: UICollectionView!
    @IBOutlet weak var propertyTypeCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    
    var viewModel = HotelViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showLoader()
        viewModel.fetchHotels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchView.applyCardStyle()
        gradientView.applyCardStyle()
        topView.addTopShadow()
    }

    @IBAction func leftMenuBarButtonAction(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func notificationBarButtonAction(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func rightMenuBarButtonAction(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func selectCityButtonAction(_ sender: Any) {
    }
    
    @IBAction func checkInButtonAction(_ sender: Any) {
    }
    
    @IBAction func checkOutButtonAction(_ sender: Any) {
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
    }
    
    @IBAction func viewAllButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "HotelListViewController") as! HotelListViewController
        controller.viewModel = self.viewModel
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func findDealButtonAction(_ sender: Any) {
    }
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topHotelsCollectionView {
            return min(10, viewModel.filteredHotels.count)
        } else if collectionView == recentlyCollectionView {
            return min(5, viewModel.filteredHotels.count)
        } else if collectionView == propertyTypeCollectionView {
            return min(5, viewModel.filteredHotels.count)
        } else {
            return min(10, viewModel.filteredHotels.count)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topHotelsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopHotelsCollectionViewCell", for: indexPath) as! TopHotelsCollectionViewCell
            let hotel = viewModel.filteredHotels[indexPath.row]
            cell.configuration(with: hotel)
            return cell
        } else if collectionView == recentlyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentlyViewedCVC", for: indexPath) as! RecentlyViewedCVC
            let item = viewModel.filteredHotels[indexPath.row]
            cell.configure(with: item)
            return cell
        } else if collectionView == propertyTypeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WhereToNextCVC", for: indexPath) as! WhereToNextCVC
            let item = viewModel.filteredHotels[indexPath.row]
            cell.configure(with: item)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionsCollectionViewCell", for: indexPath) as! PromotionsCollectionViewCell
            let images = viewModel.filteredHotels[indexPath.row]
            cell.configuration(with: images)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == topHotelsCollectionView {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            let isIpad = UIDevice.current.userInterfaceIdiom == .pad
            let numberOfItemsPerRow: CGFloat = isIpad ? 2 : 2
            let spacing: CGFloat = layout.minimumInteritemSpacing + layout.sectionInset.left + layout.sectionInset.right
            let availableWidth = collectionView.bounds.width - spacing
            let widthPerItem = availableWidth / numberOfItemsPerRow
            let heightMultiplier: CGFloat = isIpad ? 1 : 1.4
            return CGSize(width: widthPerItem, height: widthPerItem * heightMultiplier)
        } else if collectionView == recentlyCollectionView {
            let itemWidth = collectionView.frame.width * 0.3
            let itemHeight = collectionView.frame.height
            return CGSize(width: itemWidth, height: itemHeight)
        } else if collectionView == propertyTypeCollectionView {
            let isIpad = UIDevice.current.userInterfaceIdiom == .pad
            let itemsPerRow: CGFloat = isIpad ? 5 : (1 / 0.35)
            let spacing: CGFloat = 10
            let totalSpacing = spacing * (itemsPerRow - 1)
            let itemWidth = (collectionView.frame.width - totalSpacing) / itemsPerRow
            let itemHeight = collectionView.frame.height
            return CGSize(width: itemWidth, height: itemHeight)
        } else {
            let isIpad = UIDevice.current.userInterfaceIdiom == .pad
            let widthMultiplier: CGFloat = isIpad ? 0.49 : 0.9
            return CGSize(width: collectionView.frame.width * widthMultiplier, height: collectionView.frame.height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == propertyTypeCollectionView {
            return 10
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HomeViewController {
    func setupUI() {
        viewModel.onDataLoaded = { [weak self]  in
            DispatchQueue.main.async{
                self?.hideLoader()
                self?.topHotelsCollectionView.reloadData()
                self?.promotionsCollectionView.reloadData()
                self?.recentlyCollectionView.reloadData()
                self?.propertyTypeCollectionView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async{
                self?.hideLoader()
            }
        }
        
        topHotelsCollectionView.register(UINib(nibName: "TopHotelsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TopHotelsCollectionViewCell")
        if let topHotelsLayout = topHotelsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            topHotelsLayout.estimatedItemSize = .zero
        }
        recentlyCollectionView.register(UINib(nibName: "RecentlyViewedCVC", bundle: nil), forCellWithReuseIdentifier: "RecentlyViewedCVC")
        if let layouts = recentlyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layouts.estimatedItemSize = .zero
        }
        
        propertyTypeCollectionView.register(UINib(nibName: "WhereToNextCVC", bundle: nil), forCellWithReuseIdentifier: "WhereToNextCVC")
        if let propertyLayouts = propertyTypeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            propertyLayouts.estimatedItemSize = .zero
        }
        
        promotionsCollectionView.register(UINib(nibName: "PromotionsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PromotionsCollectionViewCell")
        if let promotionsLayout = topHotelsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            promotionsLayout.estimatedItemSize = .zero
        }
        
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 20
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        updateGreetingMessage()
    }
    
    func updateGreetingMessage(with userName: String? = nil) {
        let hour = Calendar.current.component(.hour, from: Date())
        let greeting: String

        switch hour {
        case 5..<12:
            greeting = "Good Morning"
        case 12..<17:
            greeting = "Good Afternoon"
        case 17..<21:
            greeting = "Good Evening"
        default:
            greeting = "Good Night"
        }

        let nameToShow = (userName?.isEmpty == false) ? userName! : "User"
        messageLabel.text = "\(greeting) \(nameToShow)!"
    }

}
