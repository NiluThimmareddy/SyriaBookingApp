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

class HomeViewController: BaseViewController, UIViewControllerTransitioningDelegate {
    
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
    @IBOutlet weak var recentlyViewedHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topHotelsCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var recentlySeeMoreButton: UIButton!
    @IBOutlet weak var whereToNextSeeMoreButton: UIButton!
    @IBOutlet weak var whereToNextTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var recommendedHotelsTitleLabel: UILabel!
    @IBOutlet weak var recommendedHotelsCollectionView: UICollectionView!
    @IBOutlet weak var viewAllRecommendedButton: UIButton!
    @IBOutlet weak var recommendedHotelsCollectionViewHeightConstraint: NSLayoutConstraint!
    
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
    var sliderAutoScrollTimer: Timer?
    var sliderCurrentIndex = 0
    var isUserInteracting = false
    var delegate : recentlyViewdHotelsProtocol?
    var isScrollingForward = true
    var currentPromotionIndex = 0
    
    var recommendedHotels: [Hotel] {
        let startIndex = 10
        let endIndex = min(30, viewModel.filteredHotels.count)
        
        if startIndex < viewModel.filteredHotels.count {
            return Array(viewModel.filteredHotels[startIndex..<endIndex])
        }
        return []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader()
    }
    
//    override func networkCameBackOnline() {
//        print("✅ Internet is back — refetching hotels")
//        viewModel.fetchHotels()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
        setupUI()
        if HotelDataMaganer.shared.allHotels.isEmpty{
            viewModel.fetchHotels()
        }
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
        gradientView.applyTopRightLightGreyGradient()
        gradientView.applyCardStyle()
        topView.addTopShadow()
    }
    
    @IBAction func recentlySeeMoreButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "RecentlyViewedVC") as! RecentlyViewedVC
        
        controller.recentlyViewedHotels = viewModel.recentlyViewdHotels
        controller.viewModel = viewModel
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func whereToNextSeeMoreButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "WhereToNextVC") as! WhereToNextVC
        controller.whereToNextCityList = self.WhereToNextCityList // Pass the city data
        self.navigationController?.pushViewController(controller, animated: true)
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
            
            let formater = DateFormatter()
            formater.dateStyle = .medium
            
            let date = formater.date(from: checkInButton.titleLabel?.text ?? "")
            
            guard let date = date else { return }
            selectedCheckInDate = date
            
            let checkoutdate = formater.date(from: checkOutButton.titleLabel?.text ?? "")
            
            guard let checkoutdate = checkoutdate else { return }
            selectedCheckOutDate = checkoutdate
            
            
            storyboard.delegate = self
            storyboard.comingFrom = .search
            storyboard.selectedCity = selectedCity
            storyboard.navigationItem.title = "Hotel List"
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.navigationBar.tintColor = .white
            self.navigationController?.pushViewController(storyboard, animated: true)
        } else {
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
        
        currentDatePickerMode = .checkOut
        setNextDateInCkechout(checkInDate: date)
        updateDatePickerLimits()
    }
    
    @IBAction func dayAfterTomorrowDateButtonAction(_ sender: UIButton) {
        checkInButton.setTitle(sender.titleLabel?.text, for: .normal)
        let formater = DateFormatter()
        formater.dateStyle = .medium
        
        let date = formater.date(from: sender.titleLabel?.text ?? "")
        
        
        guard let date = date else { return }
        setNextDateInCkechout(checkInDate: date)
        currentDatePickerMode = .checkOut
        updateDatePickerLimits()
    }
    
    @IBAction func viewAllRecommendedButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "HotelListViewController") as! HotelListViewController
        controller.comingFrom = .filter
        controller.viewModel = self.viewModel
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setNextDateInCkechout(checkInDate:Date){
        if let tomorrow = Calendar.current.date(byAdding: .day, value: 0, to: checkInDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy" // You can change format as needed
            formatter.dateStyle = .medium
            let tomorrowDate = formatter.string(from: tomorrow)
            
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
            return WhereToNextCityList.count
        } else if collectionView == promotionsCollectionView {
            return min(5, promotionsList.count)
        } else if collectionView == sliderCollectionView {
            return sliderImages.count
        } else if collectionView == recommendedHotelsCollectionView {
            return recommendedHotels.count
        } else {
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
                    cell.greetingMessageLabel.text = "\(greeting) \(user.name)"
                }
            } else {
                if indexPath.row == 0{
                    cell.loginButton.isHidden = false
                }else{
                    cell.loginButton.isHidden = true
                }
            }
            cell.imageView.image = UIImage(named: sliderImages[indexPath.row])
            
            cell.loginClicked = {
                
                let storyboard = UIStoryboard(name: "Booking", bundle: nil)
                guard let controller = storyboard.instantiateViewController(withIdentifier: "RegisterMobileNumberVC") as? RegisterMobileNumberVC else { return }
                controller.comingFrom = .HomeSliderView
                controller.modalPresentationStyle = .overFullScreen
                controller.transitioningDelegate = self
                controller.comingFrom = .HomeSliderView
                controller.reloadScreenAfterDismiss = {
                    self.reloadDataOnHomeScreen()
                }
                self.present(controller, animated: true)
            }
            return cell
        } else if collectionView == recommendedHotelsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopHotelsCollectionViewCell", for: indexPath) as! TopHotelsCollectionViewCell
            let hotel = recommendedHotels[indexPath.row]
            cell.configuration(with: hotel)
            cell.delegate = self
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
        } else if collectionView == recommendedHotelsCollectionView {
            let vc = storyboard?.instantiateViewController(withIdentifier: "HotelDetailsViewController") as! HotelDetailsViewController
            let selectedHotel = recommendedHotels[indexPath.row]
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topHotelsCollectionView {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            let isIpad = UIDevice.current.userInterfaceIdiom == .pad
            let numberOfItemsPerRow: CGFloat = isIpad ? 2 : 2
            let spacing: CGFloat = layout.minimumInteritemSpacing + layout.sectionInset.left + layout.sectionInset.right
            let availableWidth = collectionView.bounds.width - spacing
            let widthPerItem = availableWidth / numberOfItemsPerRow
            let heightMultiplier: CGFloat = isIpad ? 0.9 : 1.5
            topHotelsCollectionViewHeightConstraint.constant = CGFloat((widthPerItem * heightMultiplier) * 5) + 10
            return CGSize(width: widthPerItem, height: widthPerItem * heightMultiplier)
        } else if collectionView == recentlyCollectionView {
            if viewModel.recentlyViewdHotels.isEmpty {
                return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            } else {
                let itemWidth = collectionView.frame.width * 0.3
                let itemHeight =  collectionView.frame.height
                recentlyViewedHeightConstraint.constant = itemHeight
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
        } else if collectionView == recommendedHotelsCollectionView {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            let isIpad = UIDevice.current.userInterfaceIdiom == .pad
            let numberOfItemsPerRow: CGFloat = isIpad ? 2 : 2
            let spacing: CGFloat = layout.minimumInteritemSpacing + layout.sectionInset.left + layout.sectionInset.right
            let availableWidth = collectionView.bounds.width - spacing
            let widthPerItem = availableWidth / numberOfItemsPerRow
            let heightMultiplier: CGFloat = isIpad ? 0.9 : 1.5
            recommendedHotelsCollectionViewHeightConstraint.constant = CGFloat((widthPerItem * heightMultiplier) * 10) + 10
            return CGSize(width: widthPerItem, height: widthPerItem * heightMultiplier)
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
        setupAppNavigationBar()
        self.sliderCollectionView.reloadData()
    }
    
    func setupUI() {
        searchView.isHidden = true
        searchView.applyCardStyle()
        searchViewHeightConstraint.constant = 0
        startSliderAutoScroll()
        
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
        if let today = Calendar.current.date(byAdding: .day, value: 0, to: Date()) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            formatter.dateStyle = .medium
            let todayDate = formatter.string(from: today)
            
            let attributedTitle = NSAttributedString(
                string: todayDate,
                attributes: [.font: font]
            )
            
            checkInButton.setTitle(todayDate, for: .normal)
        }
        
        setUpTomorrowDate()
        viewModel.onDataLoaded = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.viewModel.fetchRecentlyViewedHotels {
                    self.recentlyCollectionView.reloadData()
                    self.updateRecentlyViewedSectionVisibility()
                }
                
                self.hideLoader()
                
                self.viewModel.filteredHotels = self.viewModel.filteredHotels.sorted {
                    $0.averageRating > $1.averageRating
                }
                
                self.viewModel.filteredHotelsCopy = self.viewModel.filteredHotels
                
                self.topHotelsCollectionView.reloadData()
                self.recommendedHotelsCollectionView.reloadData()
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
        
        recommendedHotelsCollectionView.register(UINib(nibName: "TopHotelsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TopHotelsCollectionViewCell")
        if let recommendedHotelsLayout = recommendedHotelsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            recommendedHotelsLayout.estimatedItemSize = .zero
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
        
        [recentlyHeadLineLabel,whereToNextHeadLineLabel,topHotelHeadLineLabel,handpickedHotelsLabel,recommendedHotelsTitleLabel].forEach { fontSize in
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
    
    func updateRecentlyViewedSectionVisibility() {
        let hasRecentlyViewedHotels = !viewModel.recentlyViewdHotels.isEmpty
        
        recentlyHeadLineLabel.isHidden = !hasRecentlyViewedHotels
        recentlySeeMoreButton.isHidden = !hasRecentlyViewedHotels
        
        if hasRecentlyViewedHotels {
            if UIDevice.current.userInterfaceIdiom == .pad {
                recentlyViewedHeightConstraint.constant = 200
            } else {
                recentlyViewedHeightConstraint.constant = 150
            }
            whereToNextTopConstraint.constant = 20
        } else {
            recentlyViewedHeightConstraint.constant = 0
            whereToNextTopConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setUpTomorrowDate() {
        let today = Date()
        
        let dayFont = UIFont.boldSystemFont(ofSize: 18) // Bigger font for day
        let restFont = UIFont.systemFont(ofSize: 14)    // Smaller font for month/year
        let dayColor = UIColor.label                      // Color for day
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        func setButton(_ button: UIButton, daysToAdd: Int) {
            if let targetDate = Calendar.current.date(byAdding: .day, value: daysToAdd, to: today) {
                let fullDate = formatter.string(from: targetDate) // e.g. "Oct 12, 2025"
                
                // Extract day component safely
                let calendar = Calendar.current
                let day = calendar.component(.day, from: targetDate)
                
                if let dayRange = fullDate.range(of: "\(day)") {
                    let attributedTitle = NSMutableAttributedString(
                        string: fullDate,
                        attributes: [.font: restFont]
                    )
                    
                    // Make only day bigger and colored
                    let nsRange = NSRange(dayRange, in: fullDate)
                    attributedTitle.addAttributes([.font: dayFont, .foregroundColor: dayColor], range: nsRange)
                    
                    button.setAttributedTitle(attributedTitle, for: .normal)
                } else {
                    // Fallback if day not found
                    button.setTitle(fullDate, for: .normal)
                }
            }
        }
        
        setButton(tomorrowDateButton, daysToAdd: 0)
        setButton(dayAfterTomorrowButton, daysToAdd: 1)
    }
    
    func NavigationBackGroundColour(){
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.tintColor = .white
        leftMenuBarButton.tintColor = .white
        navigationController?.setNavigationBarBlack()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        topHotelsCollectionView.reloadData()
        propertyTypeCollectionView.reloadData()
        recentlyCollectionView.reloadData()
        recommendedHotelsCollectionView.reloadData()
        
        if lang == .english {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 11, weight: .bold)
            ]
            newYearTitleLabel.text = "New Year, New Adventures"
            dealOfferLabel.text = "Save 15% or more when you book and stay before 31 December 2025"
            handPickedHotelsDescriptionLabel.text = "Experience the finest stays with our handpicked hotels, selected for their exceptional comfort, service, and location."
            handpickedHotelsLabel.text = "Handpicked Hotels"
            navigationTitleNameLabel.title = "SyriaBooking"
            recentlyHeadLineLabel.text = "Recently Viewed"
            whereToNextHeadLineLabel.text = "Where to next?"
            topHotelHeadLineLabel.text = "Top Hotels"
            selectCityButton.setTitle("Select City", for: .normal)
            checkInButton.setTitle("Check In", for: .normal)
            checkOutButton.setTitle("Check Out", for: .normal)
            searchButton.setTitle("Search", for: .normal)
            
            // See More buttons
            let seeMoreTitle = "See More"
            let seeMoreAttributedTitle = NSAttributedString(string: seeMoreTitle, attributes: attributes)
            recentlySeeMoreButton.setAttributedTitle(seeMoreAttributedTitle, for: .normal)
            whereToNextSeeMoreButton.setAttributedTitle(seeMoreAttributedTitle, for: .normal)
            
            let viewAllTitle = "View All"
            let viewAllAttributedTitle = NSAttributedString(string: viewAllTitle, attributes: attributes)
            viewAllButton.setAttributedTitle(viewAllAttributedTitle, for: .normal)
            
            let title = "Find early 2025 deals"
            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
            findDealButton.setAttributedTitle(attributedTitle, for: .normal)
            
            recommendedHotelsTitleLabel.text = "Recommended Hotels"
            viewAllRecommendedButton.setTitle("View All", for: .normal)
        } else {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 11, weight: .bold)
            ]
            dealOfferLabel.text = "وفّر 15% أو أكثر عند الحجز والإقامة قبل 31 ديسمبر 2025."
            newYearTitleLabel.text = "عام جديد، مغامرات جديدة"
            handPickedHotelsDescriptionLabel.text = "ختبر أرقى الإقامات مع فنادقنا المختارة بعناية، والتي تم اختيارها لراحتها الاستثنائية وخدماتها ومواقعها المميزة."
            handpickedHotelsLabel.text = "فنادق مختارة بعناية"
            navigationTitleNameLabel.title = "سيريا بوكينغ"
            recentlyHeadLineLabel.text = "شوهدت مؤخرا"
            whereToNextHeadLineLabel.text = "إلى أين بعد؟"
            topHotelHeadLineLabel.text = "أفضل الفنادق"
            selectCityButton.setTitle("اختر مدينة", for: .normal)
            checkInButton.setTitle("تسجيل الوصول", for: .normal)
            checkOutButton.setTitle("تسجيل المغادرة", for: .normal)
            searchButton.setTitle("بحث", for: .normal)
            
            // See More buttons in Arabic
            let seeMoreTitle = "المزيد"
            let seeMoreAttributedTitle = NSAttributedString(string: seeMoreTitle, attributes: attributes)
            recentlySeeMoreButton.setAttributedTitle(seeMoreAttributedTitle, for: .normal)
            whereToNextSeeMoreButton.setAttributedTitle(seeMoreAttributedTitle, for: .normal)
            
            let viewAllTitle = "عرض الكل"
            let viewAllAttributedTitle = NSAttributedString(string: viewAllTitle, attributes: attributes)
            viewAllButton.setAttributedTitle(viewAllAttributedTitle, for: .normal)
            
            let title = "ابحث مبكرًا 2025 عن عروض"
            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
            findDealButton.setAttributedTitle(attributedTitle, for: .normal)
            
            recommendedHotelsTitleLabel.text = "فنادق موصى بها"
            viewAllRecommendedButton.setTitle("عرض جميع", for: .normal)
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
        updateDatePickerLimits()
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        // Container
        datePickerContainerView.backgroundColor = .systemBackground
        datePickerContainerView.layer.cornerRadius = 12
        datePickerContainerView.layer.borderWidth = 1
        datePickerContainerView.layer.borderColor = UIColor.lightGray.cgColor
        datePickerContainerView.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Buttons
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.addTarget(self, action: #selector(cancelDatePicker), for: .touchUpInside)
        
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.systemBlue, for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        doneButton.addTarget(self, action: #selector(doneDatePicker), for: .touchUpInside)
        
        // Button stack (below the picker)
        let buttonStack = UIStackView(arrangedSubviews: [cancelButton, doneButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 16
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        datePickerContainerView.addSubview(datePicker)
        datePickerContainerView.addSubview(buttonStack)
        view.addSubview(datePickerContainerView)
        
        // Constraints (picker + buttons)
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: datePickerContainerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerContainerView.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: datePickerContainerView.topAnchor, constant: 8),
            
            buttonStack.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 12),
            buttonStack.leadingAnchor.constraint(equalTo: datePickerContainerView.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: datePickerContainerView.trailingAnchor, constant: -16),
            buttonStack.heightAnchor.constraint(equalToConstant: 44),
            buttonStack.bottomAnchor.constraint(equalTo: datePickerContainerView.bottomAnchor, constant: -12),
            
            datePickerContainerView.widthAnchor.constraint(equalToConstant: 320),
            datePickerContainerView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        datePickerContainerView.isHidden = true
    }
    
    @objc func cancelDatePicker() {
        UIView.transition(with: datePickerContainerView, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.datePickerContainerView.isHidden = true
        })
    }
    
    @objc func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let selectedDate = formatter.string(from: datePicker.date)
        
        activeButton?.setTitle(selectedDate, for: .normal)
        
        if currentDatePickerMode == .checkIn {
            setNextDateInCkechout(checkInDate: datePicker.date)
        }
        
        UIView.transition(with: datePickerContainerView, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.datePickerContainerView.isHidden = true
        })
    }
    
    func toggleDatePicker(for button: UIButton) {
        activeButton = button
        updateDatePickerLimits()
        
        if let superview = button.superview {
            let buttonFrame = button.convert(button.bounds, to: view)
            
            // Remove old constraints
            datePickerContainerView.removeFromSuperview()
            view.addSubview(datePickerContainerView)
            datePickerContainerView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                datePickerContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: buttonFrame.maxY + 8),
                datePickerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                datePickerContainerView.widthAnchor.constraint(equalToConstant: 320),
                datePickerContainerView.heightAnchor.constraint(equalToConstant: 400)
            ])
        }
        
        // Toggle visibility with animation
        UIView.transition(with: datePickerContainerView, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.datePickerContainerView.isHidden.toggle()
        })
    }
    
    func updateDatePickerLimits() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date()) // Strip time
        
        switch currentDatePickerMode {
        case .checkIn:
            datePicker.minimumDate = today
            datePicker.date = today
            
        case .checkOut:
            let formater = DateFormatter()
            formater.dateStyle = .medium
            let date = formater.date(from: checkInButton.titleLabel?.text ?? "")
            
            guard let date = date else {
                if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) {
                    datePicker.minimumDate = tomorrow
                    datePicker.date = tomorrow
                }
                return
            }
            
            
            if let nextDayBaseOnCheckin = Calendar.current.date(byAdding: .day, value: 1, to: date) {
                datePicker.minimumDate = nextDayBaseOnCheckin
            }
        }
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        switch currentDatePickerMode {
        case .checkIn:
            
            setNextDateInCkechout(checkInDate: sender.date)
        case .checkOut:
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
        promotionScrollTimer?.invalidate()
        promotionScrollTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { [weak self] _ in
            guard let self = self,
                  let collectionView = self.promotionsCollectionView,
                  self.promotionsList.count > 1 else { return }
            
            self.currentPromotionIndex = (self.currentPromotionIndex + 1) % self.promotionsList.count
            let nextIndexPath = IndexPath(item: self.currentPromotionIndex, section: 0)
            
            DispatchQueue.main.async {
                collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
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
            let visibleRect = CGRect(origin: sliderCollectionView.contentOffset, size: sliderCollectionView.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = sliderCollectionView.indexPathForItem(at: visiblePoint) {
                sliderCurrentIndex = visibleIndexPath.item
            }
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
        
        // Check for the end or beginning of the collection view
        if isScrollingForward {
            if sliderCurrentIndex < totalItems - 1 {
                sliderCurrentIndex += 1
            } else {
                // Reached the end, reverse direction
                isScrollingForward = false
                sliderCurrentIndex -= 1
            }
        } else {
            if sliderCurrentIndex > 0 {
                sliderCurrentIndex -= 1
            } else {
                // Reached the beginning, reverse direction
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
            self.recentlyCollectionView.reloadData()
            self.updateRecentlyViewedSectionVisibility()
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


