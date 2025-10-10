//
//  HomeViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import UIKit

enum DatePickerMode {
    case checkIn
    case checkOut
}

struct WhereToNextList{
    var image : String
    var City : String
    var Cityar: String
    init(image: String, City: String, Cityar: String) {
        self.image = image
        self.City = City
        self.Cityar = Cityar
    }
}

var selectedCheckInDate: Date?
var selectedCheckOutDate: Date?

protocol recentlyViewdHotelsProtocol{
    func reladRecentlyViewedData()
}

class HomeViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var leftMenuBarButton: UIBarButtonItem!
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
    //Mark
    
    @IBOutlet weak var subTitleMessageLabel: UILabel!
    @IBOutlet weak var recentlyHeadLineLabel: UILabel!
    @IBOutlet weak var whereToNextHeadLineLabel: UILabel!
    @IBOutlet weak var topHotelHeadLineLabel: UILabel!
    @IBOutlet weak var navigationTitleNameLabel: UINavigationItem!
    @IBOutlet weak var handpickedHotelsLabel: UILabel!
    @IBOutlet weak var handPickedHotelsDescriptionLabel: UILabel!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var searchViewHeightConstraint:   NSLayoutConstraint!
    @IBOutlet weak var checkoutStackView: UIStackView!
    @IBOutlet weak var tomorrowDateButton: UIButton!
    @IBOutlet weak var dayAfterTomorrowButton: UIButton!
    @IBOutlet weak var selectCityView: UIView!
    @IBOutlet weak var selectCheckInView: UIView!
    @IBOutlet weak var selectCheckOutView: UIView!
    @IBOutlet weak var newYearTitleLabel: UILabel!
    
    var viewModel = HotelViewModel()
    var datePickerContainerView: UIView!
    var datePicker: UIDatePicker!
    var activeButton: UIButton?
    var currentDatePickerMode: DatePickerMode = .checkIn
    
    var isDatePickerShown = false
    var promotionScrollTimer: Timer?
    var cities = [String]()
    var WhereToNextCityList = [WhereToNextList]()
    var leftMenuVC: LeftMenuViewController?
    var isLeftMenuVisible = false
    var scrolltoTopHelper : ScrollToTopHelper?
    var promotionsList: [Hotel] = []
    var selectedLanguage: Languages = .english
    var sliderImages = ["Slider1","Slider2","Slider3","Slider4"]
    var sliderItems : [String] = []
    var sliderAutoScrollTimer: Timer?
    var sliderCurrentIndex = 0
    var isUserInteracting = false
    var delegate : recentlyViewdHotelsProtocol?
    var BookingviewModel = BookingViewModel()
    var isScrollingForward = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        setupAppNavigationBar()
        setupUI()
        
        // Fetch hotels only if data is empty
        if HotelDataMaganer.shared.allHotels.isEmpty {
            viewModel.fetchHotels()
        }
        
        // Fetch user data
        guard let user = UserSessionManager.getUser() else { return }
        
        BookingviewModel.onSuccess = { [weak self] response in
            guard let self = self else { return }
            UserSessionManager.saveUser(response)
            DispatchQueue.main.async {
                self.sliderCollectionView.reloadData()
            }
        }
        
        BookingviewModel.FetchUserData(id: user.id)
        
        // Reload collection view (initial load)
        sliderCollectionView.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopSliderAutoScroll()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        searchView.applyCardStyle()
        setupAppNavigationBar()
        gradientView.applyTopRightLightGreyGradient()
        gradientView.applyCardStyle()
        topView.addTopShadow()
    }
    
    @IBAction func leftMenuBarButtonAction(_ sender: UIBarButtonItem) {
        sender.isEnabled = false
        
        if isLeftMenuVisible {
            closeLeftMenu()
            sender.isEnabled = true
            
            
        } else {
            let storyboard = UIStoryboard(name: "Leftmenu", bundle: nil)
            let menuVC = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
            self.leftMenuVC = menuVC
            
            menuVC.onDismiss = { [weak self] in
                
                self?.closeLeftMenu()
            }
            self.addChild(menuVC)
            self.view.addSubview(menuVC.view)
            menuVC.didMove(toParent: self)
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.navigationBar.tintColor = .white
            menuVC.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            
            UIView.animate(withDuration: 0.3, animations: {
                menuVC.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }) { _ in
                self.isLeftMenuVisible = true
                sender.title = ""
                let config = UIImage.SymbolConfiguration(scale: .medium)
                sender.image = UIImage(systemName: "xmark", withConfiguration: config)
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func checkInButtonAction(_ sender: Any) {
        currentDatePickerMode = .checkIn
        updateDatePickerLimits()
        toggleDatePicker(for: checkInButton)
    }
    
    @IBAction func checkOutButtonAction(_ sender: Any) {
        currentDatePickerMode = .checkOut
        updateDatePickerLimits()
        toggleDatePicker(for: checkOutButton)
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        
        if let selectedCity = self.selectCityButton.titleLabel?.text,  selectedCity != "Select City"{
            let storyboard = storyboard?.instantiateViewController(withIdentifier: "HotelListViewController") as! HotelListViewController
            storyboard.viewModel = self.viewModel
            
            storyboard.delegate = self
            storyboard.comingFrom = .search
            storyboard.selectedCity = selectedCity
            storyboard.navigationItem.title = "Hotel List"
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.navigationBar.tintColor = .white
            self.navigationController?.pushViewController(storyboard, animated: true)
        } else{
            
            showAlert(title: "SyriaBooking", message: "Please select city")
        }
    }
    
    @IBAction func viewAllButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "HotelListViewController") as! HotelListViewController
        controller.comingFrom = .filter
        controller.viewModel = self.viewModel
        controller.shouldSortByRating = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func findDealButtonAction(_ sender: Any) {
    }
    
    @IBAction func tomorrowDateButtonAction(_ sender: UIButton) {
        checkInButton.setTitle(sender.titleLabel?.text, for: .normal)
        
        let formater = DateFormatter()
        formater.dateStyle = .medium
        
        let date = formater.date(from: sender.titleLabel?.text ?? "")
        
        guard let date = date else { return }
        selectedCheckInDate = date
        currentDatePickerMode = .checkOut
        setNextDateInCkechout(checkInDate: date)
        updateDatePickerLimits()
    }
    
    @IBAction func dayAfterTomorrowDateButtonAction(_ sender: UIButton) {
        checkInButton.setTitle(sender.titleLabel?.text, for: .normal)
        let formater = DateFormatter()
        formater.dateStyle = .medium
        
        let date = formater.date(from: sender.titleLabel?.text ?? "")
        selectedCheckInDate = date
        
        guard let date = date else { return }
        setNextDateInCkechout(checkInDate: date)
        currentDatePickerMode = .checkOut
        updateDatePickerLimits()
    }
    
    func setNextDateInCkechout(checkInDate:Date){
        if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: checkInDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy" // You can change format as needed
            formatter.dateStyle = .medium
            let tomorrowDate = formatter.string(from: tomorrow)
            
            
            selectedCheckOutDate = tomorrow
            
            checkOutButton.setTitle(tomorrowDate, for: .normal)
            
        }
    }
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topHotelsCollectionView {
            return min(10, viewModel.filteredHotels.count)
        } else if collectionView == recentlyCollectionView {
            return viewModel.recentlyViewdHotels.isEmpty ? 1 : min(10, viewModel.recentlyViewdHotels.count)
        } else if collectionView == propertyTypeCollectionView {
            return  WhereToNextCityList.count
        } else if collectionView == promotionsCollectionView {
            return min(5, promotionsList.count)
        } else if collectionView == sliderCollectionView{
            return sliderItems.count
        } else  {
            return min(10, viewModel.filteredHotels.count)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topHotelsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopHotelsCollectionViewCell", for: indexPath) as! TopHotelsCollectionViewCell
            let hotel = viewModel.filteredHotels[indexPath.row]
            cell.configuration(with: hotel)
            cell.delegate = self
            return cell
        } else if collectionView == recentlyCollectionView {
            if viewModel.recentlyViewdHotels.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoRecentlyViewedCVC", for: indexPath) as! NoRecentlyViewedCVC
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentlyViewedCVC", for: indexPath) as! RecentlyViewedCVC
                let item = viewModel.recentlyViewdHotels[indexPath.row]
                cell.configure(with: item)
                return cell
            }
        } else if collectionView == propertyTypeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WhereToNextCVC", for: indexPath) as! WhereToNextCVC
            let item = WhereToNextCityList[indexPath.row]
            cell.configure(with: item)
            return cell
        } else if collectionView == sliderCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCollectionViewCell", for: indexPath) as! SliderCollectionViewCell
            cell.greetingMessageLabel.isHidden = true
            if let user = UserSessionManager.getUser()  {
                
                cell.loginButton.isHidden = true
                if indexPath.row == 0{
                    cell.greetingMessageLabel.isHidden = false
                    let greeting = updateGreetingMessage()
                    cell.greetingMessageLabel.text = "\(greeting) \n \(user.name)!"
                }
            } else {
                if indexPath.row == 0{
                    cell.loginButton.isHidden = false
                }else{
                    cell.loginButton.isHidden = true
                }
            }
            cell.imageView.image = UIImage(named: sliderItems[indexPath.row])
            
            cell.loginClicked = {
                
                let storyboard = UIStoryboard(name: "Booking", bundle: nil)
                guard let controller = storyboard.instantiateViewController(withIdentifier: "RegisterMobileNumberVC") as? RegisterMobileNumberVC else { return }
                controller.comingFrom = .HomeSliderView
                controller.modalPresentationStyle = .custom
                controller.transitioningDelegate = self
                controller.comingFrom = .HomeSliderView
                controller.reloadScreenAfterDismiss = {
                    self.reloadDataOnHomeScreen()
                }
                self.showPopup(controller,widthMultiplier: 0.9, heightMultiplier: 0.3)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionsCollectionViewCell", for: indexPath) as! PromotionsCollectionViewCell
            let promoHotel = promotionsList[indexPath.row]
            cell.configuration(with: promoHotel)
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == propertyTypeCollectionView {
            let HotelCity = WhereToNextCityList[indexPath.row].City
            let storyboard = storyboard?.instantiateViewController(withIdentifier: "HotelListViewController") as! HotelListViewController
            storyboard.viewModel = self.viewModel
            storyboard.comingFrom = .filter
            storyboard.selectedCity = HotelCity
            storyboard.navigationItem.title = "Hotel List"
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(storyboard, animated: true)
        } else if collectionView == recentlyCollectionView {
            let vc = storyboard?.instantiateViewController(withIdentifier: "HotelDetailsViewController") as! HotelDetailsViewController
            if !viewModel.recentlyViewdHotels.isEmpty {
                let selectedHotel = viewModel.recentlyViewdHotels[indexPath.row]
                
                vc.selectedHotel = selectedHotel
                vc.navigationItem.title = "Hotel Details"
                let backItem = UIBarButtonItem()
                backItem.title = ""
                self.navigationItem.backBarButtonItem = backItem
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        } else if collectionView == topHotelsCollectionView {
            let vc = storyboard?.instantiateViewController(withIdentifier: "HotelDetailsViewController") as! HotelDetailsViewController
            let selectedHotel = viewModel.filteredHotels[indexPath.row]
            vc.selectedHotel = selectedHotel
            vc.navigationItem.title = "Hotel Details"
            HotelDataMaganer.shared.addRecentlyViewedHotel(id: selectedHotel.id)
            delegate?.reladRecentlyViewedData()
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(vc, animated: true)
            
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
            if viewModel.recentlyViewdHotels.isEmpty {
                return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            } else {
                let itemWidth = collectionView.frame.width * 0.3
                let itemHeight = collectionView.frame.height
                return CGSize(width: itemWidth, height: itemHeight)
            }
        } else if collectionView == propertyTypeCollectionView {
            let isIpad = UIDevice.current.userInterfaceIdiom == .pad
            let itemsPerRow: CGFloat = isIpad ? 5 : (1 / 0.35)
            let spacing: CGFloat = 10
            let totalSpacing = spacing * (itemsPerRow - 1)
            let itemWidth = (collectionView.frame.width - totalSpacing) / itemsPerRow
            let itemHeight = collectionView.frame.height
            return CGSize(width: itemWidth, height: itemHeight)
        } else if collectionView == promotionsCollectionView {
            let isIpad = UIDevice.current.userInterfaceIdiom == .pad
            let fullWidth = collectionView.bounds.width
            let fullHeight = collectionView.bounds.height
            let width = isIpad ? (fullWidth / 2) : fullWidth
            let height = fullHeight
            return CGSize(width: width, height: height)
        } else if collectionView == sliderCollectionView {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
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
    
    func reloadDataOnHomeScreen(){
        print("HomeAge reloading")
//        setupAppNavigationBar()
        self.sliderCollectionView.reloadData()
    }
    
    func setupUI() {
        searchView.isHidden = true
        searchView.applyCardStyle()
        searchViewHeightConstraint.constant = 0
        startSliderAutoScroll()
        //        sliderView.applyCardStyle()
        sliderItems = sliderImages
        
        if UIDevice.current.userInterfaceIdiom != .pad{
            sliderCollectionView.decelerationRate = .normal
            sliderCollectionView.collectionViewLayout = CubeFlowLayout()
        }
        
        DispatchQueue.main.async {
            self.sliderCollectionView.reloadData()
            let middleIndex = IndexPath(item: self.sliderImages.count, section: 0)
            if middleIndex.item < self.sliderImages.count {
                self.sliderCollectionView.scrollToItem(at: middleIndex, at: .centeredHorizontally, animated: false)
            }
        }
        
        sliderCollectionView.register(UINib(nibName: "SliderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SliderCollectionViewCell")
        
        
        let font = UIFont.systemFont(ofSize: 14)
        if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            formatter.dateStyle = .medium
            let tomorrowDate = formatter.string(from: tomorrow)
            
            let attributedTitle = NSAttributedString(
                string: tomorrowDate,
                attributes: [.font: font]
            )
            
            selectedCheckInDate = tomorrow
            checkInButton.setTitle(tomorrowDate, for: .normal)
        }
        
        setUpTomorrowDate()
        viewModel.onDataLoaded = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.viewModel.fetchRecentlyViewedHotels {
                    self.recentlyCollectionView.reloadData()
                }
                
                self.hideLoader()
                
                self.viewModel.filteredHotels = self.viewModel.filteredHotels.sorted {
                    $0.averageRating > $1.averageRating
                }
                
                self.viewModel.filteredHotelsCopy = self.viewModel.filteredHotels
                
                self.topHotelsCollectionView.reloadData()
                self.promotionsList = self.viewModel.filteredHotels.filter {
                    if let desc = $0.shortDescription?.trimmingCharacters(in: .whitespacesAndNewlines) {
                        return !desc.isEmpty
                    }
                    return false
                }
                self.promotionsCollectionView.reloadData()
                self.propertyTypeCollectionView.reloadData()
                
                var seen = Set<String>()
                self.cities = self.viewModel.hotels?.data.compactMap { $0.city }
                    .filter { seen.insert($0).inserted } ?? ["No cities found"]
                
                self.cities.insert("All", at: 0)
                if let cityButton = self.selectCityButton {
                    self.configureDropdownMenu(for: cityButton, options: self.cities)
                }
                
                var seenCities = Set<String>()
                
                self.WhereToNextCityList = self.viewModel.hotels?.data.compactMap { hotel -> WhereToNextList? in
                    let cityEN = hotel.city.trimmingCharacters(in: .whitespacesAndNewlines)
                    let cityAR = hotel.cityAR?.trimmingCharacters(in: .whitespacesAndNewlines) ?? hotel.city
                    
                    // Avoid duplicates (English check)
                    guard !cityEN.isEmpty, seenCities.insert(cityEN.lowercased()).inserted else {
                        return nil
                    }
                    
                    let imageUrl = hotel.images.first?.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    return WhereToNextList(
                        image: imageUrl ?? "",
                        City: cityEN,      // English
                        Cityar: cityAR     // Arabic
                    )
                } ?? []
                
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async{
                self?.hideLoader()
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        
        topHotelsCollectionView.register(UINib(nibName: "TopHotelsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TopHotelsCollectionViewCell")
        if let topHotelsLayout = topHotelsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            topHotelsLayout.estimatedItemSize = .zero
        }
        recentlyCollectionView.register(UINib(nibName: "NoRecentlyViewedCVC", bundle: nil), forCellWithReuseIdentifier: "NoRecentlyViewedCVC")
        recentlyCollectionView.register(UINib(nibName: "RecentlyViewedCVC", bundle: nil), forCellWithReuseIdentifier: "RecentlyViewedCVC")
        if let layouts = recentlyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layouts.estimatedItemSize = .zero
        }
        
        propertyTypeCollectionView.register(UINib(nibName: "WhereToNextCVC", bundle: nil), forCellWithReuseIdentifier: "WhereToNextCVC")
        if let propertyLayouts = propertyTypeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            propertyLayouts.estimatedItemSize = .zero
        }
        
        promotionsCollectionView.register(UINib(nibName: "PromotionsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PromotionsCollectionViewCell")
        if let promotionsLayout = promotionsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            promotionsLayout.scrollDirection = .horizontal
            promotionsLayout.estimatedItemSize = .zero
        }
        
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 20
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        searchView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        setupDatePickerUI()
        startPromotionAutoScroll()
        
        [recentlyHeadLineLabel,whereToNextHeadLineLabel,topHotelHeadLineLabel,handpickedHotelsLabel].forEach { fontSize in
            fontSize?.font = .titleFont
        }
        handPickedHotelsDescriptionLabel.font = .captionFont
        
        NavigationBackGroundColour()
        viewModel.fetchHotels()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTexts),
            name: .languageChanged,
            object: nil
        )
        
        selectCityView.addBottomShadow()
        selectCheckInView.addBottomShadow()
        selectCheckOutView.addBottomShadow()
        updateTexts()
    }
    
    func setUpTomorrowDate() {
        let today = Date()
        let font = UIFont.systemFont(ofSize: 14)
        
        if let tomorrow = Calendar.current.date(byAdding: .day, value: 2, to: today) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            formatter.dateStyle = .medium
            let tomorrowDate = formatter.string(from: tomorrow)
            
            let attributedTitle = NSAttributedString(
                string: tomorrowDate,
                attributes: [.font: font]
            )
            tomorrowDateButton.setAttributedTitle(attributedTitle, for: .normal)
        }
        
        if let dayAfterTomorrow = Calendar.current.date(byAdding: .day, value: 3, to: today) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            formatter.dateStyle = .medium
            let dayAfterTomorrowDate = formatter.string(from: dayAfterTomorrow)
            
            let attributedTitle = NSAttributedString(
                string: dayAfterTomorrowDate,
                attributes: [.font: font]
            )
            dayAfterTomorrowButton.setAttributedTitle(attributedTitle, for: .normal)
        }
    }
    
    
    
    
    func NavigationBackGroundColour(){
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        // ✅ Navigation bar icons (back button, etc.) white
        navigationController?.navigationBar.tintColor = .white
        
        // ✅ Specific bar button icons white
        leftMenuBarButton.tintColor = .white
        navigationController?.setNavigationBarBlack()
    }
    
    @objc func scrollToNext() {
        guard sliderItems.count > 0 else { return }
        
        let currentIndex = Int(sliderCollectionView.contentOffset.x / sliderCollectionView.bounds.width)
        var nextIndex = currentIndex + 1
        
        if nextIndex >= sliderItems.count {
            nextIndex = sliderImages.count
        }
        
        let indexPath = IndexPath(item: nextIndex, section: 0)
        sliderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        topHotelsCollectionView.reloadData()
        propertyTypeCollectionView.reloadData()
        recentlyCollectionView.reloadData()
        
        if lang == .english {
            newYearTitleLabel.text = "New Year, New Adventures"
            dealOfferLabel.text = "Save 15% or more when you book and stay before 31 Decembe 2025"
            handPickedHotelsDescriptionLabel.text = "Experience the finest stays with our handpicked hotels, selected for their exceptional comfort, service, and location."
            handpickedHotelsLabel.text = "Handpicked Hotels"
            navigationTitleNameLabel.title = "SyriaBooking"
            //            messageLabel.text = "Good Morning User!"
            //            subTitleMessageLabel.text = "Your Gateway to Discover Syria"
            recentlyHeadLineLabel.text = "Recently Viewed"
            whereToNextHeadLineLabel.text = "Where to next?"
            topHotelHeadLineLabel.text = "Top Hotels"
            selectCityButton.setTitle("Select City", for: .normal)
            checkInButton.setTitle("Check In", for: .normal)
            checkOutButton.setTitle("Check Out", for: .normal)
            searchButton.setTitle("Search", for: .normal)
            viewAllButton.setTitle("View All", for: .normal)
            let title = "Find early 2025 deals"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 11, weight: .bold)
            ]
            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
            findDealButton.setAttributedTitle(attributedTitle, for: .normal)
        } else {
            dealOfferLabel.text = "وفّر 15% أو أكثر عند الحجز والإقامة قبل 31 ديسمبر 2025."
            newYearTitleLabel.text = "عام جديد، مغامرات جديدة"
            handPickedHotelsDescriptionLabel.text = "ختبر أرقى الإقامات مع فنادقنا المختارة بعناية، والتي تم اختيارها لراحتها الاستثنائية وخدماتها ومواقعها المميزة."
            handpickedHotelsLabel.text = "فنادق مختارة بعناية"
            navigationTitleNameLabel.title = "سيريا بوكينغ"
            //            messageLabel.text = "صباح الخير المستخدم!"
            //            subTitleMessageLabel.text = "بوابتك لاكتشاف سوريا"
            recentlyHeadLineLabel.text = "شوهدت مؤخرا"
            whereToNextHeadLineLabel.text = "إلى أين بعد؟"
            topHotelHeadLineLabel.text = "أفضل الفنادق"
            selectCityButton.setTitle("اختر مدينة", for: .normal)
            checkInButton.setTitle("تسجيل الوصول", for: .normal)
            checkOutButton.setTitle("تسجيل المغادرة", for: .normal)
            searchButton.setTitle("بحث", for: .normal)
            viewAllButton.setTitle("عرض الكل", for: .normal)
            let title = "ابحث مبكرًا 2025 عن عروض"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 11, weight: .bold)
            ]
            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
            findDealButton.setAttributedTitle(attributedTitle, for: .normal)
        }
    }
    
    func updateGreetingMessage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let greeting: String
        
        switch hour {
        case 5..<12:
            greeting = "Good Morning"
        case 12..<16:
            greeting = "Good Afternoon"
        case 16..<24:
            greeting = "Good Evening"
        default:
            greeting = "Good Evening"
        }
        return  "\(greeting)"
    }
    
    func setupDatePickerUI() {
        datePickerContainerView = UIView()
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        updateDatePickerLimits()
        datePickerContainerView.backgroundColor = .systemBackground
        datePickerContainerView.layer.cornerRadius = 8
        datePickerContainerView.layer.borderWidth = 1
        datePickerContainerView.layer.borderColor = UIColor.lightGray.cgColor
        datePickerContainerView.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePickerContainerView.addSubview(datePicker)
        view.addSubview(datePickerContainerView)
        
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: datePickerContainerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerContainerView.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: datePickerContainerView.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: datePickerContainerView.bottomAnchor),
            
            datePickerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePickerContainerView.widthAnchor.constraint(equalToConstant: 320),
            datePickerContainerView.heightAnchor.constraint(equalToConstant: 360)
        ])
        
        datePickerContainerView.isHidden = true
    }
    
    func toggleDatePicker(for button: UIButton) {
        activeButton = button
        
        if button.superview != nil {
            let buttonFrame = button.convert(button.bounds, to: view)
            let topAnchor = datePickerContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: buttonFrame.maxY + 8)
            NSLayoutConstraint.deactivate(datePickerContainerView.constraints)
            NSLayoutConstraint.activate([
                datePicker.leadingAnchor.constraint(equalTo: datePickerContainerView.leadingAnchor),
                datePicker.trailingAnchor.constraint(equalTo: datePickerContainerView.trailingAnchor),
                datePicker.topAnchor.constraint(equalTo: datePickerContainerView.topAnchor),
                datePicker.bottomAnchor.constraint(equalTo: datePickerContainerView.bottomAnchor),
                datePickerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                topAnchor,
                datePickerContainerView.widthAnchor.constraint(equalToConstant: 320),
                datePickerContainerView.heightAnchor.constraint(equalToConstant: 360)
            ])
        }
        datePickerContainerView.isHidden.toggle()
    }
    
    
    func updateDatePickerLimits() {
        let now = Date()
        switch currentDatePickerMode {
        case .checkIn:
            
            datePicker.minimumDate = now
            datePicker.date = now
            
        case .checkOut:
            guard let checkIn = selectedCheckInDate else {
                
                datePicker.minimumDate = now
                datePicker.date = now
                return
            }
            datePicker.minimumDate = checkIn
            datePicker.date = checkIn
            
        }
    }
    
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        switch currentDatePickerMode {
        case .checkIn:
            selectedCheckInDate = sender.date
            setNextDateInCkechout(checkInDate:sender.date)
        case .checkOut :
            selectedCheckOutDate = sender.date
            break
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let selectedDate = formatter.string(from: sender.date)
        activeButton?.setTitle(selectedDate, for: .normal)
        
        datePickerContainerView.isHidden = true
    }
    
    func configureDropdownMenu(for button: UIButton, options: [String]) {
        let actions = options.map { option in
            UIAction(title: option, handler: { [weak button] _ in
                button?.setTitle(option, for: .normal)
            })
        }
        
        let menu = UIMenu(title: "Select City", options: .displayInline, children: actions)
        
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
    }
    
    func startPromotionAutoScroll() {
        promotionScrollTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self = self,
                  let collectionView = self.promotionsCollectionView else { return }
            
            let currentOffset = collectionView.contentOffset.x
            let contentWidth = collectionView.contentSize.width
            let frameWidth = collectionView.frame.size.width
            let nextOffset = currentOffset + frameWidth
            
            if nextOffset >= contentWidth {
                collectionView.setContentOffset(.zero, animated: false)
            } else {
                let newOffset = CGPoint(x: nextOffset, y: 0)
                collectionView.setContentOffset(newOffset, animated: true)
            }
        }
    }
    
    func closeLeftMenu() {
        guard let menuVC = leftMenuVC else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            menuVC.view.frame = CGRect(x: -UIScreen.main.bounds.width,
                                       y: 0,
                                       width: UIScreen.main.bounds.width,
                                       height: UIScreen.main.bounds.height)
        }) { _ in
            menuVC.view.removeFromSuperview()
            menuVC.removeFromParent()
            self.leftMenuVC = nil
            self.isLeftMenuVisible = false
            self.leftMenuBarButton.image = UIImage(systemName: "line.horizontal.3")
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == sliderCollectionView {
            stopSliderAutoScroll()
            isUserInteracting = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == sliderCollectionView {
            isUserInteracting = false
            
            // find the current visible index
            let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
            sliderCurrentIndex = page
            
            // restart auto scroll after 3 sec
            startSliderAutoScroll(after: 3.0)
        }
    }
    
    func startSliderAutoScroll(after delay: TimeInterval = 3.0) {
        stopSliderAutoScroll() // avoid multiple timers
        sliderAutoScrollTimer = Timer.scheduledTimer(timeInterval: delay,target: self,selector: #selector(scrollToNextItem),userInfo: nil,repeats: true)
    }
    
    func stopSliderAutoScroll() {
        sliderAutoScrollTimer?.invalidate()
        sliderAutoScrollTimer = nil
    }
    
    @objc func scrollToNextItem() {
        guard let collectionView = sliderCollectionView else { return }
        let totalItems = sliderImages.count
        if totalItems == 0 { return }
        
        if isScrollingForward {
            if sliderCurrentIndex < totalItems - 1 {
                sliderCurrentIndex += 1
            } else {
                // reached last → reverse direction
                isScrollingForward = false
                sliderCurrentIndex -= 1
            }
        } else {
            if sliderCurrentIndex > 0 {
                sliderCurrentIndex -= 1
            } else {
                // reached first → reverse direction
                isScrollingForward = true
                sliderCurrentIndex += 1
            }
        }
        
        let indexPath = IndexPath(item: sliderCurrentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath,
                                    at: .centeredHorizontally,
                                    animated: true)
    }
    
    
}

extension HomeViewController : recentlyViewdHotelsProtocol, PromotionsCollectionViewCellDelegate , TopHotelsCollectionViewCellDelegate {
    
    func didTapBookNow(for hotel: Hotel) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let hotelDetailsVC = storyboard.instantiateViewController(withIdentifier: "HotelDetailsViewController") as? HotelDetailsViewController {
            hotelDetailsVC.selectedHotel = hotel
            self.navigationController?.pushViewController(hotelDetailsVC, animated: true)
        }
    }
    
    func reladRecentlyViewedData() {
        viewModel.fetchRecentlyViewedHotels {
            
            recentlyCollectionView.reloadData()
        }
    }
    
    func didTapExploreMore(in cell: PromotionsCollectionViewCell) {
        guard let indexPath = promotionsCollectionView.indexPath(for: cell) else { return }
        
        if promotionsList.isEmpty || indexPath.item >= promotionsList.count {
            print("Invalid index or empty list")
            return
        }
        let selectedHotel = promotionsList[indexPath.item]
        if let detailsVC = storyboard?.instantiateViewController(withIdentifier: "PromotionsDetailsVC") as? PromotionsDetailsVC {
            detailsVC.selectedHotel = selectedHotel
            detailsVC.gotoDetails = {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HotelDetailsViewController") as! HotelDetailsViewController
                vc.selectedHotel = selectedHotel
                vc.navigationItem.title = "Hotel Details"
                let backItem = UIBarButtonItem()
                backItem.title = ""
                self.navigationItem.backBarButtonItem = backItem
                self.navigationController?.pushViewController(vc, animated: true)
            }
            present(detailsVC, animated: true)
        } else {
            print("Failed to instantiate PromotionsDetailsVC")
        }
    }
    
    override func didTapSearch(_ sender: UIBarButtonItem) {
        
        print("Search tapped")
        if searchView.isHidden {
            
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                searchViewHeightConstraint.constant = 280
            } else {
                searchViewHeightConstraint.constant = 210
            }
            
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           options: .curveEaseInOut) {
                self.view.layoutIfNeeded()
            }
            searchView.isHidden = false
        } else {
            // Hide with animation
            searchViewHeightConstraint.constant = 0
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                self.view.layoutIfNeeded()
            }) { _ in
                self.searchView.isHidden = true
            }
        }
    }
}

extension UINavigationController {
    func setNavigationBarBlack() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        if #available(iOS 15.0, *) {
            navigationBar.compactScrollEdgeAppearance = appearance
        }
        navigationBar.tintColor = .white
    }
}

