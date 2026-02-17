//
//  WhereToNextVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 16/10/25.

import UIKit
import SkeletonView

class WhereToNextVC: BaseViewController, UIViewControllerTransitioningDelegate {
    
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
    
    private var isShowingSkeleton = false
    private var minimumSkeletonTime: TimeInterval = 2.0
    private var skeletonStartTime: Date?
    private var skeletonHideWorkItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setupSkeleton()
        showSkeletonImmediately()
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
    
    private func showSkeletonImmediately() {
        isShowingSkeleton = true
        skeletonStartTime = Date()
        
        if !self.topView.isHidden {
            self.loginDescriptionLabel.showAnimatedGradientSkeleton()
            self.loginButton.showAnimatedGradientSkeleton()
        }
        
        self.citiesTitleLabel.showAnimatedGradientSkeleton()
        self.whereToNextTableview.isSkeletonable = true
        self.whereToNextTableview.showAnimatedGradientSkeleton()
        self.whereToNextTableview.reloadData()
    }
    
    private func loadHotelsData() {
        if HotelDataMaganer.shared.allHotels.isEmpty {
            viewModel.fetchHotels()
            viewModel.onDataLoaded = { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    self?.processDataAndHideSkeleton()
                }
            }
            
            viewModel.onError = { [weak self] error in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    self?.hideSkeleton()
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.processDataAndHideSkeleton()
            }
        }
    }
    
    private func processDataAndHideSkeleton() {
        self.prepareWhereToNextData()
        self.hideSkeleton()
    }

    private func prepareWhereToNextData() {
        let allHotels = HotelDataMaganer.shared.allHotels

        let uniqueCities = Array(Set(allHotels.map { normalizedCity($0.city) }))

        self.whereToNextCityList = uniqueCities.map { cityName in
            let hotelsInCity = allHotels.filter {
                normalizedCity($0.city) == cityName
            }

            let cityImage = hotelsInCity.first?.images.first ?? ""

            return WhereToNextList(
                image: cityImage,
                City: cityName,
                Cityar: cityName
            )
        }
    }

    private func getHotelsForCity(_ cityName: String) -> [Hotel] {
        let normalizedInput = normalizedCity(cityName)

        return HotelDataMaganer.shared.allHotels.filter {
            normalizedCity($0.city) == normalizedInput
        }
    }

    private func normalizedCity(_ city: String) -> String {
        return city.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
    
}

// MARK: - Skeleton Configuration
extension WhereToNextVC {
    private func setupSkeleton() {
        view.isSkeletonable = true
        whereToNextTableview.isSkeletonable = true
        loginDescriptionLabel.isSkeletonable = true
        loginButton.isSkeletonable = true
        citiesTitleLabel.isSkeletonable = true
        loginDescriptionLabel.skeletonTextLineHeight = .relativeToFont
        loginDescriptionLabel.lastLineFillPercent = 70
        loginDescriptionLabel.linesCornerRadius = 4
        citiesTitleLabel.skeletonTextLineHeight = .relativeToFont
        citiesTitleLabel.lastLineFillPercent = 100
        citiesTitleLabel.linesCornerRadius = 4
        whereToNextTableview.skeletonCornerRadius = 8
        loginButton.skeletonCornerRadius = 6
    }
    
    private func showSkeleton() {
        guard !isShowingSkeleton else { return }
        skeletonHideWorkItem?.cancel()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isShowingSkeleton = true
            self.skeletonStartTime = Date()
            if !self.topView.isHidden {
                self.loginDescriptionLabel.showAnimatedGradientSkeleton()
                self.loginButton.showAnimatedGradientSkeleton()
            }
            self.citiesTitleLabel.showAnimatedGradientSkeleton()
            self.whereToNextTableview.isSkeletonable = true
            self.whereToNextTableview.showAnimatedGradientSkeleton()
            self.whereToNextTableview.reloadData()
        }
    }
    
    private func hideSkeleton() {
        skeletonHideWorkItem?.cancel()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let elapsedTime = self.skeletonStartTime.map { Date().timeIntervalSince($0) } ?? 0
            let remainingTime = max(0, self.minimumSkeletonTime - elapsedTime)
            
            if remainingTime > 0 {
                let workItem = DispatchWorkItem { [weak self] in
                    self?.performHideSkeleton()
                }
                self.skeletonHideWorkItem = workItem
                DispatchQueue.main.asyncAfter(deadline: .now() + remainingTime, execute: workItem)
            } else {
                self.performHideSkeleton()
            }
        }
    }
    
    private func performHideSkeleton() {
        guard isShowingSkeleton else { return }
        
        self.isShowingSkeleton = false
        self.skeletonHideWorkItem = nil
        self.loginDescriptionLabel.hideSkeleton()
        self.loginButton.hideSkeleton()
        self.citiesTitleLabel.hideSkeleton()
        self.whereToNextTableview.hideSkeleton()
        self.whereToNextTableview.reloadData()
    }
}

// MARK: - UITableView DataSource & Delegate
extension WhereToNextVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowingSkeleton {
            return 5
        }
        return min(whereToNextCityList.count, 10)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WhereToNextListTVC", for: indexPath) as! WhereToNextListTVC
        
        if isShowingSkeleton {
            cell.showSkeleton()
            return cell
        }
        
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
        guard !isShowingSkeleton else { return }
        
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
        guard !isShowingSkeleton else { return }
        
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

// MARK: - SkeletonTableViewDataSource
extension WhereToNextVC: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "WhereToNextListTVC"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        let cell = skeletonView.dequeueReusableCell(withIdentifier: "WhereToNextListTVC", for: indexPath) as! WhereToNextListTVC
        cell.showSkeleton()
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, prepareCellForSkeleton cell: UITableViewCell, at indexPath: IndexPath) {
        if let whereToNextCell = cell as? WhereToNextListTVC {
            whereToNextCell.showSkeleton()
        }
    }
}

// MARK: - Setup Methods
extension WhereToNextVC {
    func setUpUI() {
        whereToNextTableview.register(UINib(nibName: "WhereToNextListTVC", bundle: nil), forCellReuseIdentifier: "WhereToNextListTVC")
        whereToNextTableview.delegate = self
        whereToNextTableview.dataSource = self
        
        updateLoginViewTexts()
    }
    
    func updateLoginViewTexts() {
        let lang = AppSettings.shared.selectedLanguage
        
        if lang == .english {
            loginDescriptionLabel.text = "Login to book your stay quickly and securely"
            citiesTitleLabel.text = "Cities"
        } else {
            loginDescriptionLabel.text = "سجل الدخول لحجز إقامتك بسرعة وأمان"
            citiesTitleLabel.text = "المدن"
        }
        
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        
        if lang == .english {
            let attributedTitle = NSAttributedString(string: "Login", attributes: attributes)
            loginButton.setAttributedTitle(attributedTitle, for: .normal)
        } else {
            let attributedTitle = NSAttributedString(string: "تسجيل الدخول", attributes: attributes)
            loginButton.setAttributedTitle(attributedTitle, for: .normal)
        }
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
