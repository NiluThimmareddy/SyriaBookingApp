//
//  WhereToNextVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 16/10/25.
//

import UIKit

class WhereToNextVC: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var docImgView: UIImageView!
    @IBOutlet weak var loginDescriptionLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var citiesTitleLabel: UILabel!
    @IBOutlet weak var whereToNextTableview: UITableView!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var citiesTopConstaint: NSLayoutConstraint!
    
    var whereToNextCityList: [WhereToNextList] = []
    var selectedLanguage: Languages = .english
    var viewModel = HotelViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        loadHotelsData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
        updateLoginViewVisibility()
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "RegisterMobileNumberVC") as? RegisterMobileNumberVC else { return }
        controller.modalPresentationStyle = .overFullScreen
        controller.transitioningDelegate = self
        controller.reloadScreenAfterDismiss = {
            self.goToHomeTab()
        }
        self.present(controller, animated: true)
    }
    
    private func loadHotelsData() {
        if HotelDataMaganer.shared.allHotels.isEmpty {
            viewModel.fetchHotels()
            viewModel.onDataLoaded = { [weak self] in
                DispatchQueue.main.async {
                    self?.whereToNextTableview.reloadData()
                }
            }
        }
    }
    
    private func getHotelsForCity(_ cityName: String) -> [Hotel] {
        return HotelDataMaganer.shared.allHotels.filter {
            $0.city.lowercased() == cityName.lowercased()
        }
    }
}

// MARK: - UITableView DataSource & Delegate
extension WhereToNextVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return whereToNextCityList.count
        return min(whereToNextCityList.count, 10)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WhereToNextListTVC", for: indexPath) as! WhereToNextListTVC
        let city = whereToNextCityList[indexPath.row]
        let hotels = getHotelsForCity(city.City)
        
        cell.configure(with: city, hotels: hotels, language: selectedLanguage)
        
        cell.onHotelSelected = { [weak self] selectedHotel in
            self?.navigateToHotelDetails(selectedHotel)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 300
        } else {
            return 210
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedCity = whereToNextCityList[indexPath.row]
        let cityName = selectedLanguage == .english ? selectedCity.City : selectedCity.Cityar
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let hotelListVC = storyboard.instantiateViewController(withIdentifier: "HotelListViewController") as? HotelListViewController {
            hotelListVC.viewModel = HotelViewModel()
            hotelListVC.selectedCity = selectedCity.City
            hotelListVC.comingFrom = .filter
            hotelListVC.navigationItem.title = cityName
            
            hotelListVC.viewModel.onDataLoaded = {
                DispatchQueue.main.async {
                    hotelListVC.applyFilterOnHotels()
                }
            }
            hotelListVC.viewModel.fetchHotels()
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(hotelListVC, animated: true)
        }
    }
    
    private func navigateToHotelDetails(_ hotel: Hotel) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HotelDetailsViewController") as! HotelDetailsViewController
        vc.selectedHotel = hotel
        vc.navigationItem.title = "Hotel Details"
        
        HotelDataMaganer.shared.addRecentlyViewedHotel(id: hotel.id)
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Setup Methods
extension WhereToNextVC {
    func setUpUI() {
        whereToNextTableview.register(UINib(nibName: "WhereToNextListTVC", bundle: nil), forCellReuseIdentifier: "WhereToNextListTVC")
        whereToNextTableview.delegate = self
        whereToNextTableview.dataSource = self
    }
    
    func updateLoginViewVisibility() {
        if UserSessionManager.getUser() != nil {
            topViewHeightConstraint.constant = 0
            citiesTopConstaint.constant = 0
            topView.isHidden = true
        } else {
            topViewHeightConstraint.constant = 100
            citiesTopConstaint.constant = 20
            topView.isHidden = false
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}


