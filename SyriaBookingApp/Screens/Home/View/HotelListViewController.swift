//
//  HotelListViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import UIKit

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
    
    var delegate : recentlyViewdHotelsProtocol?
    var viewModel = HotelViewModel()
    var selectedCity = ""
    var shouldSortByRating: Bool = false
    var scrolleView: UIScrollView { HotelListtableView }
    var scrolltoTopHelper : ScrollToTopHelper?
    var scrollToTopButton = UIButton(type: .system)
    var comingFrom : hotelListSource = .tabBar
    
    var isGridView = false

    override func viewDidLoad() {
        super.viewDidLoad()
       
        viewModel.onDataLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.applyFilterOnHotels()
            }
        }
        
        if comingFrom == .tabBar {
            viewModel.fetchHotels()
        } else if comingFrom == .filter {
            // If coming from filter, apply filter immediately if data is already loaded
            if !HotelDataMaganer.shared.allHotels.isEmpty {
                applyFilterOnHotels()
            } else {
                viewModel.fetchHotels()
            }
        }
    }
    
//    override func networkCameBackOnline() {
//        print("✅ Internet is back — refetching hotels")
//        viewModel.fetchHotels()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
        setUpUI()
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

extension HotelListViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredHotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotelListTVC") as! HotelListTVC
        let data = viewModel.filteredHotels[indexPath.row]
        cell.configuration(with: data)
        cell.seeAvailabilityAction = { [weak self] in
            guard let self = self else { return }
            let vc = storyboard?.instantiateViewController(withIdentifier: "HotelDetailsViewController") as! HotelDetailsViewController
            
            let selectedHotel = viewModel.filteredHotels[indexPath.row]
            
            HotelDataMaganer.shared.addRecentlyViewedHotel(id: selectedHotel.id)
            delegate?.reladRecentlyViewedData()
            vc.selectedHotel = selectedHotel
            vc.navigationItem.title = "Hotel Details"
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 350 : 250
    }
}

extension HotelListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredHotels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopHotelsCollectionViewCell", for: indexPath) as! TopHotelsCollectionViewCell
        let hotel = viewModel.filteredHotels[indexPath.row]
        cell.configuration(with: hotel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HotelDetailsViewController") as! HotelDetailsViewController
        let selectedHotel = viewModel.filteredHotels[indexPath.row]

        HotelDataMaganer.shared.addRecentlyViewedHotel(id: selectedHotel.id)
        delegate?.reladRecentlyViewedData()
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

extension HotelListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterHotelsBasedOnSearch(searchText: searchText)
        HotelListtableView.reloadData()
        hotelCollectionView.reloadData()
    }
}
