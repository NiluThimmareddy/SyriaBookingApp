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
    @IBOutlet weak var exploreSyriaButton: UIButton!
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
    }

    @IBAction func leftMenuBarButtonAction(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func notificationBarButtonAction(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func rightMenuBarButtonAction(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func exploreSyriaButtonAction(_ sender: Any) {
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
        } else {
            let isIpad = UIDevice.current.userInterfaceIdiom == .pad
            let widthMultiplier: CGFloat = isIpad ? 0.49 : 0.9
            return CGSize(width: collectionView.frame.width * widthMultiplier, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
        
        promotionsCollectionView.register(UINib(nibName: "PromotionsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PromotionsCollectionViewCell")
        if let promotionsLayout = topHotelsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            promotionsLayout.estimatedItemSize = .zero
        }
        
        
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 20
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
