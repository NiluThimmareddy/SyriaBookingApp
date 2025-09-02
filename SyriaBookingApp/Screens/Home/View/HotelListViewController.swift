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


class HotelListViewController: UIViewController, ApplyFilterDelegate, ScrollToTopCapable {
   
    @IBOutlet weak var HotelListtableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var delegate : recentlyViewdHotelsProtocol?
    var viewModel = HotelViewModel()
    var selectedCity = ""
    var shouldSortByRating: Bool = false
    var scrolleView: UIScrollView { HotelListtableView }
    var scrolltoTopHelper : ScrollToTopHelper?
    var scrollToTopButton = UIButton(type: .system)
    var comingFrom : hotelListSource = .tabBar

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        viewModel.onDataLoaded = {
            DispatchQueue.main.async {
                self.HotelListtableView.reloadData()
            }
        }
        
        if comingFrom == .tabBar{
            viewModel.fetchHotels()
            
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
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

extension HotelListViewController  {
    func setUpUI() {
        

        HotelListtableView.register(UINib(nibName: "HotelListTVC", bundle: nil), forCellReuseIdentifier: "HotelListTVC")
        scrolleView.addTopShadow()
        self.applyFilterOnHotels()
        scrollToTopButton.setImage(UIImage(systemName: "arrow.up.to.line.compact"), for: .normal)
        scrollToTopButton.imageView?.contentMode = .scaleToFill
        scrolltoTopHelper = ScrollToTopHelper(parent: self)
        
        searchBar.placeholder = "Search hotels, City"
        searchBar.delegate = self
    }
    
    func applyFilterOnHotels() {
         guard let hotels = viewModel.hotels?.data else {
             print("No Data")
             return
         }
        var filtered = hotels
        
        if selectedCity != "" && selectedCity != "All" && selectedCity != "Select City"
        {
            filtered = filtered.filter { $0.city == selectedCity }
        }
        
        if shouldSortByRating
        {
            filtered = filtered.sorted { ($0.averageRating) > ($1.averageRating)
            }
    }
        viewModel.filteredHotels = filtered
        viewModel.filteredHotelsCopy =  filtered
        HotelListtableView.reloadData()
    }
    
    //delegate method
    func applyFilter(filterdHotels: [Hotel]) {
        viewModel.filteredHotels = filterdHotels
        viewModel.filteredHotelsCopy = viewModel.filteredHotels
        DispatchQueue.main.async {
            self.HotelListtableView.reloadData()
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
    }
}


