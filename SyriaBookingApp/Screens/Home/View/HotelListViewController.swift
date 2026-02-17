//
//  HotelListViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import UIKit
import SkeletonView

enum hotelListSource{
    case tabBar
    case search
    case filter
}

class HotelListViewController: BaseViewController, ApplyFilterDelegate, ScrollToTopCapable {
   
    @IBOutlet weak var HotelListtableView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var gridButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var hotelCollectionView: UICollectionView!
    
    var delegate : RecentlyViewedProtocol?
    var viewModel = HotelViewModel()
    var selectedCity = ""
    var shouldSortByRating: Bool = false
    var scrolleView: UIScrollView { HotelListtableView }
    var scrolltoTopHelper : ScrollToTopHelper?
    var scrollToTopButton = UIButton(type: .system)
    var comingFrom : hotelListSource = .tabBar
    var isGridView = false
    var isLoadingData = true
    
    var selectedCheckInDate: Date?
    var selectedCheckOutDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSkeletonView()
        setUpUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        selectedCity = ""
        setupAppNavigationBar()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.fetchHotelData()
        }
    }
    
    func fetchHotelData() {
        showLoader()
        isLoadingData = true
        showSkeletonViews()
        
        viewModel.onDataLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.hideLoader()
                self?.isLoadingData = false
                self?.applyFilterOnHotels()
                self?.hideAllSkeletons()
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.hideLoader()
                self?.isLoadingData = false
                self?.hideAllSkeletons()
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        
        if comingFrom == .tabBar || comingFrom == .search {
            viewModel.fetchHotels()
        } else if comingFrom == .filter {
            // If coming from filter, apply filter immediately if data is already loaded
            if !HotelDataMaganer.shared.allHotels.isEmpty {
                isLoadingData = false
                hideLoader()
                applyFilterOnHotels()
                self.hideAllSkeletons()
            } else {
                viewModel.fetchHotels()
            }
        }
    }

    @IBAction func gridButtonAction(_ sender: Any) {
        isGridView.toggle()
        
        hotelCollectionView.isHidden = !isGridView
        HotelListtableView.isHidden = isGridView
        
        let imageName = isGridView ? "list.bullet" : "square.grid.2x2"
        gridButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        if isGridView {
            hotelCollectionView.reloadData()
        } else {
            HotelListtableView.reloadData()
        }
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "FilterOptionsViewController") as? FilterOptionsViewController else { return }
        
        if let sheet = controller.sheetPresentationController {
            sheet.detents = [
                .custom { context in
                    return context.maximumDetentValue * 0.83
                }
            ]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                sheet.largestUndimmedDetentIdentifier = .medium
                controller.preferredContentSize = CGSize(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height * 0.6
                )
            }
        }
        controller.delegate  = self
        controller.modalPresentationStyle = .pageSheet
        present(controller, animated: true)
    }
}

// MARK: - UITableView Delegate & DataSource
extension HotelListViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoadingData {
            return 6 // Show 6 skeleton cells
        }
        return viewModel.filteredHotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotelListTVC") as! HotelListTVC
        
        if isLoadingData {
            cell.showSkeleton()
        } else {
            cell.hideSkeleton()
            let data = viewModel.filteredHotels[indexPath.row]
            cell.configuration(with: data)
            cell.seeAvailabilityAction = { [weak self] in
                guard let self = self else { return }
                let vc = storyboard?.instantiateViewController(withIdentifier: "HotelDetailsViewController") as! HotelDetailsViewController
                
                let selectedHotel = viewModel.filteredHotels[indexPath.row]
                
                HotelDataMaganer.shared.addRecentlyViewedHotel(id: selectedHotel.id)
                delegate?.reloadRecentlyViewedData()
                vc.selectedHotel = selectedHotel
                vc.navigationItem.title = "Hotel Details"
                let backItem = UIBarButtonItem()
                backItem.title = ""
                self.navigationItem.backBarButtonItem = backItem
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 350 : 270
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isLoadingData {
            cell.showAnimatedGradientSkeleton()
        }
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension HotelListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoadingData {
            return 6 // Show 6 skeleton cells
        }
        return viewModel.filteredHotels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopHotelsCollectionViewCell", for: indexPath) as! TopHotelsCollectionViewCell
        
        if isLoadingData {
            cell.showSkeleton()
        } else {
            cell.hideSkeleton()
            let hotel = viewModel.filteredHotels[indexPath.row]
            cell.configuration(with: hotel)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !isLoadingData else { return }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "HotelDetailsViewController") as! HotelDetailsViewController
        let selectedHotel = viewModel.filteredHotels[indexPath.row]

        HotelDataMaganer.shared.addRecentlyViewedHotel(id: selectedHotel.id)
        delegate?.reloadRecentlyViewedData()
        vc.selectedHotel = selectedHotel
        vc.navigationItem.title = "Hotel Details"

        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        let numberOfItemsPerRow: CGFloat = isIpad ? 2 : 2
        let spacing: CGFloat = layout.minimumInteritemSpacing + layout.sectionInset.left + layout.sectionInset.right
        let availableWidth = collectionView.bounds.width - spacing
        let widthPerItem = availableWidth / numberOfItemsPerRow
        let heightMultiplier: CGFloat = isIpad ? 1 : 1.4
        return CGSize(width: widthPerItem, height: widthPerItem * heightMultiplier)
    }
}

// MARK: - SkeletonView Configuration
extension HotelListViewController {
    
    private func setupSkeletonView() {
        configureSkeletonAppearance()
        makeElementsSkeletonable()
    }
    
    private func configureSkeletonAppearance() {
        let gradient = SkeletonGradient(baseColor: UIColor.systemGray5)
        SkeletonAppearance.default.gradient = gradient
        SkeletonAppearance.default.tintColor = UIColor.systemGray4
        SkeletonAppearance.default.multilineHeight = 12
        SkeletonAppearance.default.multilineSpacing = 8
        SkeletonAppearance.default.multilineCornerRadius = 4
    }
    
    private func makeElementsSkeletonable() {
        // Make table view and collection view skeletonable
        HotelListtableView.isSkeletonable = true
        hotelCollectionView.isSkeletonable = true
        
        // Make sure table view cells are skeletonable
        HotelListtableView.register(UINib(nibName: "HotelListTVC", bundle: nil), forCellReuseIdentifier: "HotelListTVC")
        
        // Make buttons skeletonable
        filterButton.isSkeletonable = true
        gridButton.isSkeletonable = true
        filterButton.skeletonCornerRadius = 6
        gridButton.skeletonCornerRadius = 6
        
        // Make search bar skeletonable
        searchBar.isSkeletonable = true
        searchBar.skeletonCornerRadius = 8
        
        // Configure table view for skeleton
        HotelListtableView.rowHeight = UITableView.automaticDimension
        HotelListtableView.estimatedRowHeight = 250
    }
    
    private func showSkeletonViews() {
        print("Showing skeleton views...")
        
        // Force reload data to ensure skeleton cells are created
        HotelListtableView.reloadData()
        hotelCollectionView.reloadData()
        
        // Show skeleton on main views
        if !isGridView {
            HotelListtableView.showAnimatedGradientSkeleton()
        } else {
            hotelCollectionView.showAnimatedGradientSkeleton()
        }
        
        filterButton.showAnimatedGradientSkeleton()
        gridButton.showAnimatedGradientSkeleton()
        searchBar.showAnimatedGradientSkeleton()
        
        // Force layout update
        self.view.layoutIfNeeded()
    }
    
    private func hideAllSkeletons() {
        print("Hiding all skeletons...")
        
        HotelListtableView.hideSkeleton()
        hotelCollectionView.hideSkeleton()
        filterButton.hideSkeleton()
        gridButton.hideSkeleton()
        searchBar.hideSkeleton()
        
        // Also reload data to ensure proper content display
        DispatchQueue.main.async {
            self.HotelListtableView.reloadData()
            self.hotelCollectionView.reloadData()
        }
    }
}

// MARK: - Main Implementation
extension HotelListViewController  {
    func setUpUI() {
        HotelListtableView.register(UINib(nibName: "HotelListTVC", bundle: nil), forCellReuseIdentifier: "HotelListTVC")
        scrolleView.addTopShadow()
        
        scrollToTopButton.setImage(UIImage(systemName: "arrow.up.to.line.compact"), for: .normal)
        scrollToTopButton.imageView?.contentMode = .scaleToFill
        scrolltoTopHelper = ScrollToTopHelper(parent: self)
        
        searchBar.placeholder = "Search hotels, City"
        searchBar.delegate = self
        
        hotelCollectionView.isHidden = true
        hotelCollectionView.register(UINib(nibName: "TopHotelsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TopHotelsCollectionViewCell")
        if let topHotelsLayout = hotelCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            topHotelsLayout.estimatedItemSize = .zero
        }
        navigationController?.setNavigationBarBlack()
        
        // Show skeleton if data is loading
        if isLoadingData {
            // Small delay to ensure UI is fully loaded before showing skeleton
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showSkeletonViews()
            }
        }
        
        // Apply filter after UI setup
        if comingFrom == .filter {
            applyFilterOnHotels()
        }
    }
    
    func applyFilterOnHotels() {
        guard let hotels = viewModel.hotels?.data else {
            print("No Data")
            return
        }
        var filtered = hotels
        
        // Apply city filter
        if !selectedCity.isEmpty && selectedCity != "All" && selectedCity != "Select City" {
            filtered = filtered.filter { $0.city.lowercased() == selectedCity.lowercased() }
            print("Filtering by city: \(selectedCity), Found \(filtered.count) hotels")
        }
        
        // Apply rating sort if needed
        if shouldSortByRating {
            filtered = filtered.sorted { ($0.averageRating) > ($1.averageRating) }
        }
        
        viewModel.filteredHotels = filtered
        viewModel.filteredHotelsCopy = filtered
        
        // Reload both table view and collection view
        HotelListtableView.reloadData()
        hotelCollectionView.reloadData()
        
        // Show empty state if no hotels found
        if filtered.isEmpty {
            showEmptyState()
        }
    }
    
    private func showEmptyState() {
        // You can add an empty state view here
        print("No hotels found for city: \(selectedCity)")
    }
    
    //delegate method
    func applyFilter(filterdHotels: [Hotel]) {
        viewModel.filteredHotels = filterdHotels
        viewModel.filteredHotelsCopy = viewModel.filteredHotels
        DispatchQueue.main.async {
            self.HotelListtableView.reloadData()
            self.hotelCollectionView.reloadData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let scrolltoTopHelper = scrolltoTopHelper else { return }
        scrolltoTopHelper.scrollViewDidScroll(scrollView)
    }
}

// MARK: - UISearchBarDelegate
extension HotelListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterHotelsBasedOnSearch(searchText: searchText)
        HotelListtableView.reloadData()
        hotelCollectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // Hide skeleton when user starts searching
        hideAllSkeletons()
    }
}
