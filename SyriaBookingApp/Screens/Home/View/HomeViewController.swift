
import UIKit
import SkeletonView

extension NSNotification.Name {
    static let recentlyViewedUpdated = NSNotification.Name("RecentlyViewedUpdated")
}

enum DatePickerMode {
    case checkIn
    case checkOut
}

struct WhereToNextList {
    var image: String
    var City: String
    var Cityar: String
    init(image: String, City: String, Cityar: String) {
        self.image = image
        self.City = City
        self.Cityar = Cityar
    }
}

var selectedCheckInDate: Date?
var selectedCheckOutDate: Date?
var selectedTotalNights: Int?
// MARK: - Protocol with corrected spelling
protocol RecentlyViewedProtocol {
    func reloadRecentlyViewedData()
}

class HomeViewController: BaseViewController, UIViewControllerTransitioningDelegate, RecentlyViewedProtocol, CalenderVCDelegate {
    
    
    
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
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
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
    @IBOutlet weak var hotelSearchView: UIView!
    @IBOutlet weak var whereAreYouGoingButton: UIButton!
    @IBOutlet weak var checkInCheckOutButton: UIButton!
    @IBOutlet weak var searchHotelButton: UIButton!
    @IBOutlet weak var searchStackView: UIStackView!
    
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
    var scrolltoTopHelper: ScrollToTopHelper?
    var promotionsList: [Hotel] = []
    var selectedLanguage: Languages = .english
    var sliderImages = ["ic_B1", "ic_B2", "ic_B3", "ic_B4"]
    var sliderAutoScrollTimer: Timer?
    var sliderCurrentIndex = 0
    var isUserInteracting = false
    var delegate: RecentlyViewedProtocol?
    var isScrollingForward = true
    var currentPromotionIndex = 0
    var selectedDateRange: String?
    var selectedRooms: Int = 1
    
    // Add this property for city mapping
    var cityDisplayToActualMapping: [String: String] = [:]
    
    // Add this property to store selected city
    var selectedCityFromDropdown: String?
    
    var recommendedHotels: [Hotel] {
        let startIndex = 10
        let endIndex = min(30, viewModel.filteredHotels.count)
        
        if startIndex < viewModel.filteredHotels.count {
            return Array(viewModel.filteredHotels[startIndex..<endIndex])
        }
        return []
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasicUI()
        setupSkeletonView()
        
        // Show skeleton immediately
        showSkeletonOnAllElements()
        configureHotelSearchView()
        // Set up notification observers
        setupNotifications()
        
        // Load data after a short delay to ensure skeleton is visible
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadData()
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLoginSuccess),
            name: .didLoginSuccessfully,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLogout),
            name: .didLogoutSuccessfully,
            object: nil
        )
        setupDataBindings()
        debugSkeletonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
        sliderCollectionView.reloadData()
        
        if viewModel.filteredHotels.isEmpty {
            showSkeletonOnAllElements()
        }
        
//        selectedCheckInDate = nil
//        selectedCheckOutDate = nil
        refreshRecentlyViewedData()
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
    
    private func configureHotelSearchView() {
        hotelSearchView.layer.cornerRadius = 15
        hotelSearchView.backgroundColor = .white
        
        hotelSearchView.layer.shadowColor = UIColor.black.cgColor
        hotelSearchView.layer.shadowOffset = CGSize(width: 0, height: 2)
        hotelSearchView.layer.shadowOpacity = 0.2
        hotelSearchView.layer.shadowRadius = 6
        hotelSearchView.layer.masksToBounds = false
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRecentlyViewedUpdate),
            name: .recentlyViewedUpdated,
            object: nil
        )
    }
    
    @objc func handleRecentlyViewedUpdate() {
        refreshRecentlyViewedData()
    }
    
    @objc func handleLoginSuccess() {
        showSkeletonOnAllElements()
        loadData()
    }
    
    @objc func handleLogout() {
        print("🚪 Logout received")
        sliderCollectionView.reloadData()
        sliderCollectionView.layoutIfNeeded()
        
        showSkeletonOnAllElements()
    }
    
    // MARK: - Recently Viewed Data Refresh
    func reloadRecentlyViewedData() {
        refreshRecentlyViewedData()
    }
    
    private func refreshRecentlyViewedData() {
        viewModel.fetchRecentlyViewedHotels {
            DispatchQueue.main.async {
                self.recentlyCollectionView.reloadData()
                self.updateRecentlyViewedSectionVisibility()
            }
        }
    }
    
    @IBAction func whereAreYouGoingButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func checkInCheckOutButtonTapped(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "CalenderVC") as? CalenderVC else { return }
        controller.delegate = self
        
        controller.selectedRooms = selectedRooms
        
        if let sheet = controller.sheetPresentationController {
            sheet.detents = [
                .custom { context in
                    return context.maximumDetentValue * 0.65
                }
            ]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                sheet.largestUndimmedDetentIdentifier = .medium
                controller.preferredContentSize = CGSize(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height * 0.8
                )
            }
        }
        
        controller.modalPresentationStyle = .pageSheet
        present(controller, animated: true)
    }
    
    func didSelectDateRange(checkIn: Date?, checkOut: Date?) {
        selectedCheckInDate = checkIn
        selectedCheckOutDate = checkOut

        let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        guard let checkIn, let checkOut else {
            
            let title = "Check-in date － Check-out date"
            
            let attributedTitle = NSAttributedString(
                string: title,
                attributes: [
                    .font: font,
                    .foregroundColor: UIColor.label
                ]
            )

            checkInCheckOutButton.setAttributedTitle(attributedTitle, for: .normal)
            return
        }

        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = .current
        formatter.dateFormat = "EEE dd MMM"

        let startText = formatter.string(from: checkIn)
        let endText = formatter.string(from: checkOut)

        let rawNights = Calendar.current.dateComponents([.day], from: checkIn, to: checkOut).day ?? 0
        let nights = max(rawNights, 1)

        let title = "\(startText) - \(endText) • \(nights) night\(nights > 1 ? "s" : "")"

        
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: font,
                .foregroundColor: UIColor.label
            ]
        )

        checkInCheckOutButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    @IBAction func searchHotelButtonTapped(_ sender: UIButton) {
        var selectedCity: String?
        
        if let attributedTitle = whereAreYouGoingButton.attributedTitle(for: .normal) {
            selectedCity = attributedTitle.string
        } else {
            selectedCity = whereAreYouGoingButton.currentTitle
        }
        
        guard let city = selectedCity else {
            showAlert(title: "SyriaBooking", message: "Please select city")
            return
        }

        let placeholderKeywords = ["Select City", "اختر مدينة",
            "Where are you going","إلى أين أنت ذاهب",
            "Search by city, area, or hotel name","ابحث عن طريق المدينة، المنطقة، أو اسم الفندق"
        ]
        
//        let normalizedCity = city.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
//        let isPlaceholder = placeholderKeywords.contains { keyword in
//            normalizedCity.contains(keyword)
//        }
        
        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)

        let isPlaceholder = placeholderKeywords.contains { keyword in
            trimmedCity.contains(keyword)
        }
        
        if isPlaceholder {
            showAlert(title: "SyriaBooking", message: "Please select city")
            return
        }
        
        let cleanedCity = city
            .replacingOccurrences(of: "\\s*\\(\\d+\\)", with: "", options: .regularExpression)
            .components(separatedBy: "\n")
            .first?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? city

        let vc = storyboard?.instantiateViewController(withIdentifier:"HotelListViewController"
        ) as! HotelListViewController

        
        vc.delegate = self
        vc.comingFrom = .search
        vc.selectedCity = cleanedCity
        
        // Pass dates if they exist (optional)
        vc.selectedCheckInDate = selectedCheckInDate
        vc.selectedCheckOutDate = selectedCheckOutDate
       
        vc.navigationItem.title = "Hotel List"

        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.tintColor = .white
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - IBActions
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
        controller.whereToNextCityList = self.WhereToNextCityList
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
        // Get the button title from attributed string or plain text
        var selectedCity: String?
        
        if let attributedTitle = selectCityButton.attributedTitle(for: .normal) {
            selectedCity = attributedTitle.string
        } else {
            selectedCity = selectCityButton.currentTitle
        }
        
        if let city = selectedCity, city != "Select City" && city != "اختر مدينة" {
            let storyboard = storyboard?.instantiateViewController(withIdentifier: "HotelListViewController") as! HotelListViewController
//            storyboard.viewModel = self.viewModel
            
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
            storyboard.selectedCity = city
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
        controller.selectedCity = "All"
//        controller.viewModel = self.viewModel
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
        controller.selectedCity = "All"
//        controller.viewModel = self.viewModel
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setNextDateInCkechout(checkInDate: Date) {
        if let tomorrow = Calendar.current.date(byAdding: .day, value: 0, to: checkInDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            formatter.dateStyle = .medium
            let tomorrowDate = formatter.string(from: tomorrow)
            
            checkOutButton.setTitle(tomorrowDate, for: .normal)
        }
    }
    
    // MARK: - Debug Helper
    private func debugSkeletonState() {
        print("🔍 Skeleton Debug State:")
        print("Top Hotels CV skeleton active: \(topHotelsCollectionView?.sk.isSkeletonActive ?? false)")
        print("Recently CV skeleton active: \(recentlyCollectionView?.sk.isSkeletonActive ?? false)")
        print("Property Type CV skeleton active: \(propertyTypeCollectionView?.sk.isSkeletonActive ?? false)")
        print("View skeleton active: \(view.sk.isSkeletonActive)")
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Always return skeleton count if skeleton is active
        if collectionView.sk.isSkeletonActive {
            if collectionView == topHotelsCollectionView {
                return 6
            } else if collectionView == recentlyCollectionView {
                return 4
            } else if collectionView == propertyTypeCollectionView {
                return 5
            } else if collectionView == promotionsCollectionView {
                return 3
            } else if collectionView == recommendedHotelsCollectionView {
                return 6
            } else if collectionView == sliderCollectionView {
                return sliderImages.count
            }
            return 4
        }
        
        // Return actual data count only when skeleton is not active
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
        // If skeleton is active, return skeleton cell
        if collectionView.sk.isSkeletonActive {
            let cellIdentifier = collectionSkeletonView(collectionView, cellIdentifierForItemAt: indexPath)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            
            // Make the cell and its content views skeletonable
            cell.isSkeletonable = true
            cell.contentView.isSkeletonable = true
            
            // Show skeleton on the cell
            cell.showAnimatedGradientSkeleton()
            
            return cell
        }
        
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
            if let user = UserSessionManager.getUser() {
                cell.loginButton.isHidden = true
                if indexPath.row == 0 {
                    cell.greetingMessageLabel.isHidden = false
                    let greeting = updateGreetingMessage()
                    cell.greetingMessageLabel.text = "\(greeting), \n\(user.name)"
                }
            } else {
                if indexPath.row == 0 {
                    cell.loginButton.isHidden = false
                } else {
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
        if collectionView.sk.isSkeletonActive { return }
        
        if collectionView == propertyTypeCollectionView {
            let HotelCity = WhereToNextCityList[indexPath.row].City
            let storyboard = storyboard?.instantiateViewController(withIdentifier: "HotelListViewController") as! HotelListViewController
//            storyboard.viewModel = self.viewModel
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
                
                // Add to recently viewed again to update timestamp
                HotelDataMaganer.shared.addRecentlyViewedHotel(id: selectedHotel.id)
                
                // Post notification immediately
                NotificationCenter.default.post(name: .recentlyViewedUpdated, object: nil)
                
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
            
            // Add to recently viewed immediately
            HotelDataMaganer.shared.addRecentlyViewedHotel(id: selectedHotel.id)
            
            // Post notification to update home screen immediately
            NotificationCenter.default.post(name: .recentlyViewedUpdated, object: nil)
            
            // Also call delegate if set
            delegate?.reloadRecentlyViewedData()
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(vc, animated: true)
        } else if collectionView == recommendedHotelsCollectionView {
            let vc = storyboard?.instantiateViewController(withIdentifier: "HotelDetailsViewController") as! HotelDetailsViewController
            let selectedHotel = recommendedHotels[indexPath.row]
            vc.selectedHotel = selectedHotel
            vc.navigationItem.title = "Hotel Details"
            
            // Add to recently viewed immediately
            HotelDataMaganer.shared.addRecentlyViewedHotel(id: selectedHotel.id)
            
            // Post notification to update home screen immediately
            NotificationCenter.default.post(name: .recentlyViewedUpdated, object: nil)
            
            // Also call delegate if set
            delegate?.reloadRecentlyViewedData()
            
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

// MARK: - SkeletonView Data Source
extension HomeViewController: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if skeletonView == topHotelsCollectionView {
            return 6
        } else if skeletonView == recentlyCollectionView {
            return 4
        } else if skeletonView == propertyTypeCollectionView {
            return 5
        } else if skeletonView == promotionsCollectionView {
            return 3
        } else if skeletonView == recommendedHotelsCollectionView {
            return 6
        } else if skeletonView == sliderCollectionView {
            return sliderImages.count
        }
        return 4
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if skeletonView == topHotelsCollectionView {
            return "TopHotelsCollectionViewCell"
        } else if skeletonView == recentlyCollectionView {
            return "RecentlyViewedCVC"
        } else if skeletonView == propertyTypeCollectionView {
            return "WhereToNextCVC"
        } else if skeletonView == promotionsCollectionView {
            return "PromotionsCollectionViewCell"
        } else if skeletonView == sliderCollectionView {
            return "SliderCollectionViewCell"
        } else if skeletonView == recommendedHotelsCollectionView {
            return "TopHotelsCollectionViewCell"
        }
        return "TopHotelsCollectionViewCell"
    }
}

// MARK: - SkeletonView Configuration
extension HomeViewController {
    
    // MARK: - Skeleton Configuration
    func setupSkeletonView() {
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
        makeCollectionViewsSkeletonable()
        makeLabelsSkeletonable()
        makeButtonsSkeletonable()
        makeViewsSkeletonable()
        
        // Make the main view skeletonable
        view.isSkeletonable = true
    }
    
    private func makeCollectionViewsSkeletonable() {
        let skeletonCollectionViews: [UICollectionView] = [
            topHotelsCollectionView,
            recentlyCollectionView,
            propertyTypeCollectionView,
            promotionsCollectionView,
            sliderCollectionView,
            recommendedHotelsCollectionView
        ].compactMap { $0 }
        
        skeletonCollectionViews.forEach { collectionView in
            collectionView.isSkeletonable = true
        }
    }
    
    private func makeLabelsSkeletonable() {
        let skeletonLabels: [UILabel] = [
            recentlyHeadLineLabel,
            whereToNextHeadLineLabel,
            topHotelHeadLineLabel,
            handpickedHotelsLabel,
            handPickedHotelsDescriptionLabel,
            recommendedHotelsTitleLabel,
            dealOfferLabel,
            newYearTitleLabel,
            messageLabel,
            subTitleMessageLabel
        ].compactMap { $0 }
        
        skeletonLabels.forEach { label in
            label.isSkeletonable = true
            label.skeletonTextLineHeight = .fixed(16)
            label.lastLineFillPercent = 100
            label.linesCornerRadius = 4
        }
    }
    
    private func makeButtonsSkeletonable() {
        let skeletonButtons: [UIButton] = [
            recentlySeeMoreButton,
            whereToNextSeeMoreButton,
            viewAllButton,
            viewAllRecommendedButton,
            findDealButton,
            selectCityButton,
            checkInButton,
            checkOutButton,
            searchButton
            
        ].compactMap { $0 }
        
        skeletonButtons.forEach { button in
            // Configure button for skeleton
            button.isSkeletonable = true
            button.skeletonCornerRadius = 6
            
            // Configure title label for skeleton
            button.titleLabel?.isSkeletonable = true
            button.titleLabel?.skeletonTextLineHeight = .fixed(16)
            button.titleLabel?.lastLineFillPercent = 100
            button.titleLabel?.linesCornerRadius = 4
            
            // Set temporary plain titles for skeleton (remove attributed strings)
            let temporaryTitle: String = "Loading..."
            
            // Remove any attributed titles and set plain text for skeleton
            button.setAttributedTitle(nil, for: .normal)
            button.setTitle(temporaryTitle, for: .normal)
        }
    }
    
    private func makeViewsSkeletonable() {
        let skeletonViews: [UIView] = [
            dealsview,
            searchView,
            selectCityView,
            selectCheckInView,
            selectCheckOutView,
            gradientView,
            stackView
        ].compactMap { $0 }
        
        skeletonViews.forEach { view in
            view.isSkeletonable = true
            view.skeletonCornerRadius = 8
        }
    }
    
    private func showSkeletonOnAllElements() {
        // Show skeleton on the main view first
        view.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
        
        // Then show on individual elements
        showSkeletonOnCollectionViews()
        showSkeletonOnLabels()
        showSkeletonOnButtons()
        showSkeletonOnViews()
    }
    
    private func showSkeletonOnCollectionViews() {
        let skeletonCollectionViews: [UICollectionView] = [
            topHotelsCollectionView,
            recentlyCollectionView,
            propertyTypeCollectionView,
            promotionsCollectionView,
            sliderCollectionView,
            recommendedHotelsCollectionView
        ].compactMap { $0 }
        
        skeletonCollectionViews.forEach { collectionView in
            collectionView.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
        }
    }
    
    private func showSkeletonOnLabels() {
        let skeletonLabels: [UILabel] = [
            recentlyHeadLineLabel,
            whereToNextHeadLineLabel,
            topHotelHeadLineLabel,
            handpickedHotelsLabel,
            handPickedHotelsDescriptionLabel,
            recommendedHotelsTitleLabel,
            dealOfferLabel,
            newYearTitleLabel,
            messageLabel,
            subTitleMessageLabel
        ].compactMap { $0 }
        
        skeletonLabels.forEach { label in
            label.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
        }
    }
    
    private func showSkeletonOnButtons() {
        let skeletonButtons: [UIButton] = [
            recentlySeeMoreButton,
            whereToNextSeeMoreButton,
            viewAllButton,
            viewAllRecommendedButton,
            findDealButton,
            selectCityButton,
            checkInButton,
            checkOutButton,
            searchButton
        ].compactMap { $0 }
        
        skeletonButtons.forEach { button in
            button.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
            button.titleLabel?.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
        }
    }
    
    private func showSkeletonOnViews() {
        let skeletonViews: [UIView] = [
            dealsview,
            searchView,
            selectCityView,
            selectCheckInView,
            selectCheckOutView
        ].compactMap { $0 }
        
        skeletonViews.forEach { view in
            view.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
        }
    }
    
    func hideSkeletonViews() {
        // Hide skeleton from main view first
        view.hideSkeleton(transition: .crossDissolve(0.25))
        
        // Then hide from individual elements
        hideSkeletonFromCollectionViews()
        hideSkeletonFromLabels()
        hideSkeletonFromButtons()
        hideSkeletonFromViews()
        restoreOriginalButtonTitles()
    }
    
    private func hideSkeletonFromCollectionViews() {
        let skeletonCollectionViews: [UICollectionView] = [
            topHotelsCollectionView,
            recentlyCollectionView,
            propertyTypeCollectionView,
            promotionsCollectionView,
            sliderCollectionView,
            recommendedHotelsCollectionView
        ].compactMap { $0 }
        
        skeletonCollectionViews.forEach { collectionView in
            collectionView.hideSkeleton(transition: .crossDissolve(0.25))
        }
    }
    
    private func hideSkeletonFromLabels() {
        let skeletonLabels: [UILabel] = [
            recentlyHeadLineLabel,
            whereToNextHeadLineLabel,
            topHotelHeadLineLabel,
            handpickedHotelsLabel,
            handPickedHotelsDescriptionLabel,
            recommendedHotelsTitleLabel,
            dealOfferLabel,
            newYearTitleLabel,
            messageLabel,
            subTitleMessageLabel
        ].compactMap { $0 }
        
        skeletonLabels.forEach { label in
            label.hideSkeleton(transition: .crossDissolve(0.25))
        }
    }
    
    private func hideSkeletonFromButtons() {
        let skeletonButtons: [UIButton] = [
            recentlySeeMoreButton,
            whereToNextSeeMoreButton,
            viewAllButton,
            viewAllRecommendedButton,
            findDealButton,
            selectCityButton,
            checkInButton,
            checkOutButton,
            searchButton
        ].compactMap { $0 }
        
        skeletonButtons.forEach { button in
            button.hideSkeleton(transition: .crossDissolve(0.25))
            button.titleLabel?.hideSkeleton(transition: .crossDissolve(0.25))
        }
    }
    
    private func hideSkeletonFromViews() {
        let skeletonViews: [UIView] = [
            dealsview,
            searchView,
            selectCityView,
            selectCheckInView,
            selectCheckOutView
        ].compactMap { $0 }
        
        skeletonViews.forEach { view in
            view.hideSkeleton(transition: .crossDissolve(0.25))
        }
    }
    
    private func restoreOriginalButtonTitles() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateTexts()
        }
    }
}

// MARK: - Main Implementation
extension HomeViewController {
    
    private func setupBasicUI() {
        searchView.isHidden = true
        searchView.applyCardStyle()
        searchViewHeightConstraint.constant = 0
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            sliderCollectionView.decelerationRate = .normal
            sliderCollectionView.collectionViewLayout = CubeFlowLayout()
        }
        
        sliderCollectionView.register(UINib(nibName: "SliderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SliderCollectionViewCell")
        
        let font = UIFont.systemFont(ofSize: 14)
        if let today = Calendar.current.date(byAdding: .day, value: 0, to: Date()) {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE dd MMM"
            formatter.dateStyle = .medium
            let todayDate = formatter.string(from: today)
            
            let attributedTitle = NSAttributedString(
                string: todayDate,
                attributes: [.font: font]
            )
            
            checkInButton.setTitle(todayDate, for: .normal)
        }
        
        setUpTomorrowDate()
        setupCollectionViews()
        setupDatePickerUI()
        
        // Configure the checkInCheckOutButton
        checkInCheckOutButton.titleLabel?.numberOfLines = 2
        checkInCheckOutButton.titleLabel?.textAlignment = .center
        
        // Configure the whereAreYouGoingButton
        whereAreYouGoingButton.titleLabel?.numberOfLines = 2
        whereAreYouGoingButton.titleLabel?.textAlignment = .left
        
        NavigationBackGroundColour()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTexts),
            name: .languageChanged,
            object: nil
        )
        
        selectCityView.addBottomShadow()
        selectCheckInView.addBottomShadow()
        selectCheckOutView.addBottomShadow()
    }
    
    private func setupCollectionViews() {
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
        
        searchStackView.clipsToBounds = true
        searchStackView.layer.cornerRadius = 20
        searchStackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func loadData() {
        viewModel.fetchHotels()
    }
    
    private func setupDataBindings() {
        viewModel.onDataLoaded = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                // Hide skeleton only after all data is loaded
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.hideSkeletonViews()
                }
                
                self.viewModel.fetchRecentlyViewedHotels {
                    self.recentlyCollectionView.reloadData()
                    self.updateRecentlyViewedSectionVisibility()
                }
                
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
                
                // Calculate hotel counts per city
                var cityHotelCounts: [String: Int] = [:]
                
                // Count hotels per city
                for hotel in self.viewModel.filteredHotels {
                    let city = hotel.city.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    cityHotelCounts[city, default: 0] += 1
                }
                
                // Create an array of city names with counts
                self.cities = cityHotelCounts.keys.map { city in
                    let count = cityHotelCounts[city] ?? 0
                    return "\(city) (\(count))"
                }
                
                // Sort alphabetically
                self.cities.sort()
                
                // Add "All" option with total count
                let totalHotels = self.viewModel.filteredHotels.count
                self.cities.insert("All (\(totalHotels))", at: 0)
                
                // Also create a mapping dictionary for the actual city names
                self.cityDisplayToActualMapping = [:]
                
                // Add mapping for "All"
                self.cityDisplayToActualMapping["All (\(totalHotels))"] = "All"
                
                // Add mapping for each city
                for (city, count) in cityHotelCounts {
                    let displayName = "\(city) (\(count))"
                    self.cityDisplayToActualMapping[displayName] = city
                }
                
                // Configure dropdown menu
                if let cityButton = self.whereAreYouGoingButton {
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
                
                // Start auto scroll only after data is loaded
                self.startSliderAutoScroll()
                self.startPromotionAutoScroll()
                
                // Update texts after data is loaded
                self.updateTexts()
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                // Hide skeleton on error too, but maybe show error state
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.hideSkeletonViews()
                }
            }
        }
    }
    
    func reloadDataOnHomeScreen() {
        print("HomePage reloading")
        setupAppNavigationBar()
        self.sliderCollectionView.reloadData()
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
    
    func NavigationBackGroundColour() {
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
        // Don't update texts if skeleton is still active
        if view.sk.isSkeletonActive { return }
        
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
            searchButton.setTitle("Search", for: .normal)
            checkInButton.setTitle("Check In", for: .normal)
            checkOutButton.setTitle("Check Out", for: .normal)
            
            // Update whereAreYouGoingButton based on whether we have selected a city
            if let selectedCity = selectedCityFromDropdown {
                // We have a city selected from dropdown - show ONLY the city name (remove count if present)
                let cleanedTitle = selectedCity.replacingOccurrences(of: "\\s*\\(\\d+\\)", with: "", options: .regularExpression)
                let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                let attributedString = NSAttributedString(
                    string: cleanedTitle,
                    attributes: [
                        .font: font,
                        .foregroundColor: UIColor.label
                    ]
                )
                whereAreYouGoingButton.setAttributedTitle(attributedString, for: .normal)
            } else if let attributedTitle = whereAreYouGoingButton.attributedTitle(for: .normal),
                      attributedTitle.string != "Where are you going?" &&
                      attributedTitle.string != "Select City" {
                // Check attributed title string
                let cleanedTitle = attributedTitle.string.replacingOccurrences(of: "\\s*\\(\\d+\\)", with: "", options: .regularExpression)
                if cleanedTitle != "Where are you going?" && cleanedTitle != "Select City" {
                    let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                    let attributedString = NSAttributedString(
                        string: cleanedTitle,
                        attributes: [
                            .font: font,
                            .foregroundColor: UIColor.label
                        ]
                    )
                    whereAreYouGoingButton.setAttributedTitle(attributedString, for: .normal)
                } else {
                    // No city selected - show title + subtitle
                    setWhereAreYouGoingButtonWithTitleAndSubtitle()
                }
            } else if let currentTitle = whereAreYouGoingButton.currentTitle,
                      currentTitle != "Select City" && currentTitle != "اختر مدينة" &&
                      currentTitle != "Where are you going?" && currentTitle != "إلى أين أنت ذاهب؟" {
                // We have a city selected - show ONLY the city name (remove count if present)
                let cleanedTitle = currentTitle.replacingOccurrences(of: "\\s*\\(\\d+\\)", with: "", options: .regularExpression)
                let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                let attributedString = NSAttributedString(
                    string: cleanedTitle,
                    attributes: [
                        .font: font,
                        .foregroundColor: UIColor.label
                    ]
                )
                whereAreYouGoingButton.setAttributedTitle(attributedString, for: .normal)
            } else {
                // No city selected - show title + subtitle
                setWhereAreYouGoingButtonWithTitleAndSubtitle()
            }
            
            // Update checkInCheckOutButton based on whether we have selected dates
            if let dateRange = selectedDateRange {
                // We have dates selected - show ONLY the dates (no subtitle)
                let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                let attributedString = NSAttributedString(
                    string: dateRange,
                    attributes: [
                        .font: font,
                        .foregroundColor: UIColor.label
                    ]
                )
                checkInCheckOutButton.setAttributedTitle(attributedString, for: .normal)
            } else {
                // No dates selected - show title + subtitle
                setCheckInCheckOutButtonWithTitleAndSubtitle()
            }
            
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
            searchButton.setTitle("بحث", for: .normal)
            checkInButton.setTitle("تسجيل الوصول", for: .normal)
            checkOutButton.setTitle("تسجيل المغادرة", for: .normal)
            
            // Update whereAreYouGoingButton based on whether we have selected a city
            if let selectedCity = selectedCityFromDropdown {
                // We have a city selected from dropdown - show ONLY the city name (remove count if present)
                let cleanedTitle = selectedCity.replacingOccurrences(of: "\\s*\\(\\d+\\)", with: "", options: .regularExpression)
                let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                let attributedString = NSAttributedString(
                    string: cleanedTitle,
                    attributes: [
                        .font: font,
                        .foregroundColor: UIColor.label
                    ]
                )
                whereAreYouGoingButton.setAttributedTitle(attributedString, for: .normal)
            } else if let attributedTitle = whereAreYouGoingButton.attributedTitle(for: .normal),
                      attributedTitle.string != "إلى أين أنت ذاهب؟" &&
                      attributedTitle.string != "اختر مدينة" {
                // Check attributed title string
                let cleanedTitle = attributedTitle.string.replacingOccurrences(of: "\\s*\\(\\d+\\)", with: "", options: .regularExpression)
                if cleanedTitle != "إلى أين أنت ذاهب؟" && cleanedTitle != "اختر مدينة" {
                    let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                    let attributedString = NSAttributedString(
                        string: cleanedTitle,
                        attributes: [
                            .font: font,
                            .foregroundColor: UIColor.label
                        ]
                    )
                    whereAreYouGoingButton.setAttributedTitle(attributedString, for: .normal)
                } else {
                    // No city selected - show title + subtitle
                    setWhereAreYouGoingButtonWithTitleAndSubtitle()
                }
            } else if let currentTitle = whereAreYouGoingButton.currentTitle,
                      currentTitle != "Select City" && currentTitle != "اختر مدينة" &&
                      currentTitle != "Where are you going?" && currentTitle != "إلى أين أنت ذاهب؟" {
                // We have a city selected - show ONLY the city name (remove count if present)
                let cleanedTitle = currentTitle.replacingOccurrences(of: "\\s*\\(\\d+\\)", with: "", options: .regularExpression)
                let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                let attributedString = NSAttributedString(
                    string: cleanedTitle,
                    attributes: [
                        .font: font,
                        .foregroundColor: UIColor.label
                    ]
                )
                whereAreYouGoingButton.setAttributedTitle(attributedString, for: .normal)
            } else {
                // No city selected - show title + subtitle
                setWhereAreYouGoingButtonWithTitleAndSubtitle()
            }
            
            // Update checkInCheckOutButton based on whether we have selected dates
            if let dateRange = selectedDateRange {
                // We have dates selected - show ONLY the dates (no subtitle)
                let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                let attributedString = NSAttributedString(
                    string: dateRange,
                    attributes: [
                        .font: font,
                        .foregroundColor: UIColor.label
                    ]
                )
                checkInCheckOutButton.setAttributedTitle(attributedString, for: .normal)
            } else {
                // No dates selected - show title + subtitle
                setCheckInCheckOutButtonWithTitleAndSubtitle()
            }
            
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
    
    // MARK: - Helper method to set button with title and subtitle for whereAreYouGoingButton
    private func setWhereAreYouGoingButtonWithTitleAndSubtitle() {
        let lang = AppSettings.shared.selectedLanguage
        let title = lang == .english ? "Where are you going?" : "إلى أين أنت ذاهب؟"
        let subtitle = lang == .english ? "Search by city, area, or hotel name" : "ابحث عن طريق المدينة، المنطقة، أو اسم الفندق"
        
        // Create a combined string with title and subtitle
        let fullText = "\(title)\n\(subtitle)"
        
        // Create attributed string with different styles for title and subtitle
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Style for title (first line) - LEADING (LEFT) ALIGNED
        let titleFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        let titleRange = (fullText as NSString).range(of: title)
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .left  // Changed from .center to .left
        titleParagraphStyle.lineSpacing = 4
        
        attributedString.addAttributes([
            .font: titleFont,
            .foregroundColor: UIColor.label,
            .paragraphStyle: titleParagraphStyle
        ], range: titleRange)
        
        let subtitleFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        let subtitleRange = (fullText as NSString).range(of: subtitle)
        let subtitleParagraphStyle = NSMutableParagraphStyle()
        subtitleParagraphStyle.alignment = .left
        subtitleParagraphStyle.lineSpacing = 4
        
        attributedString.addAttributes([
            .font: subtitleFont,
            .foregroundColor: UIColor.label,
            .paragraphStyle: subtitleParagraphStyle
        ], range: subtitleRange)
        
        whereAreYouGoingButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    // MARK: - Helper method to set button with title and subtitle for checkInCheckOutButton
    private func setCheckInCheckOutButtonWithTitleAndSubtitle() {
        let lang = AppSettings.shared.selectedLanguage
        let title = lang == .english ? "Check-in date － Check-out date" : "تسجيل الوصول -> تسجيل المغادرة"
        let subtitle = lang == .english ? "Select your stay dates" : "حدد مواعيد إقامتك"
        
        // Create a combined string with title and subtitle
        let fullText = "\(title)\n\(subtitle)"
        
        // Create attributed string with different styles for title and subtitle
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Style for title (first line) - CENTER ALIGNED
        let titleFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        let titleRange = (fullText as NSString).range(of: title)
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        titleParagraphStyle.lineSpacing = 4
        
        attributedString.addAttributes([
            .font: titleFont,
            .foregroundColor: UIColor.label,
            .paragraphStyle: titleParagraphStyle
        ], range: titleRange)
        
        let subtitleFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        let subtitleRange = (fullText as NSString).range(of: subtitle)
        let subtitleParagraphStyle = NSMutableParagraphStyle()
        subtitleParagraphStyle.alignment = .left
        subtitleParagraphStyle.lineSpacing = 4
        
        attributedString.addAttributes([
            .font: subtitleFont,
            .foregroundColor: UIColor.label,
            .paragraphStyle: subtitleParagraphStyle
        ], range: subtitleRange)
        
        checkInCheckOutButton.setAttributedTitle(attributedString, for: .normal)
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
    
    func configureDropdownMenu(for button: UIButton, options: [String]) {
        let actions = options.map { option in
            UIAction(title: option, handler: { [weak self] _ in
                // Store the actual city name from mapping
                if let actualCity = self?.cityDisplayToActualMapping[option] {
                    // Store the selected city in the property
                    self?.selectedCityFromDropdown = actualCity
                    
                    // Show just the city name (without count) on the button
                    let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                    let attributedString = NSAttributedString(
                        string: actualCity,
                        attributes: [
                            .font: font,
                            .foregroundColor: UIColor.label
                        ]
                    )
                    button.setAttributedTitle(attributedString, for: .normal)
                } else {
                    // Fallback: remove the count from the display name
                    let cleanedCity = option.replacingOccurrences(of: "\\s*\\(\\d+\\)", with: "", options: .regularExpression)
                    
                    // Store the selected city in the property
                    self?.selectedCityFromDropdown = cleanedCity
                    
                    let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                    let attributedString = NSAttributedString(
                        string: cleanedCity,
                        attributes: [
                            .font: font,
                            .foregroundColor: UIColor.label
                        ]
                    )
                    button.setAttributedTitle(attributedString, for: .normal)
                }
            })
        }
        
        let menu = UIMenu(title: "Select City", options: .displayInline, children: actions)
        
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
    }
    
    func setupDatePickerUI() {
        datePickerContainerView = UIView()
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        updateDatePickerLimits()
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        datePickerContainerView.backgroundColor = .systemBackground
        datePickerContainerView.layer.cornerRadius = 12
        datePickerContainerView.layer.borderWidth = 1
        datePickerContainerView.layer.borderColor = UIColor.lightGray.cgColor
        datePickerContainerView.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        let buttonStack = UIStackView(arrangedSubviews: [cancelButton, doneButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 16
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        datePickerContainerView.addSubview(datePicker)
        datePickerContainerView.addSubview(buttonStack)
        view.addSubview(datePickerContainerView)
        
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
    
//    func startPromotionAutoScroll() {
//        promotionScrollTimer?.invalidate()
//        promotionScrollTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { [weak self] _ in
//            guard let self = self,
//                  let collectionView = self.promotionsCollectionView,
//                  self.promotionsList.count > 1 else { return }
//            
//            self.currentPromotionIndex = (self.currentPromotionIndex + 1) % self.promotionsList.count
//            let nextIndexPath = IndexPath(item: self.currentPromotionIndex, section: 0)
//            
//            DispatchQueue.main.async {
//                collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
//            }
//        }
//    }
    
    func startPromotionAutoScroll() {
        promotionScrollTimer?.invalidate()
        
        promotionScrollTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { [weak self] _ in
            guard let self = self,
                  let collectionView = self.promotionsCollectionView else { return }
            
            let itemCount = collectionView.numberOfItems(inSection: 0)
            guard itemCount > 1 else { return }
            
            self.currentPromotionIndex = (self.currentPromotionIndex + 1) % itemCount
            
            if self.currentPromotionIndex < itemCount {
                let nextIndexPath = IndexPath(item: self.currentPromotionIndex, section: 0)
                
                DispatchQueue.main.async {
                    collectionView.scrollToItem(at: nextIndexPath,
                                                at: .centeredHorizontally,
                                                animated: true)
                }
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

// MARK: - Protocol Implementation Extension
extension HomeViewController: PromotionsCollectionViewCellDelegate, TopHotelsCollectionViewCellDelegate {
    
    func didTapBookNow(for hotel: Hotel) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let hotelDetailsVC = storyboard.instantiateViewController(withIdentifier: "HotelDetailsViewController") as? HotelDetailsViewController {
            hotelDetailsVC.selectedHotel = hotel
            self.navigationController?.pushViewController(hotelDetailsVC, animated: true)
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
