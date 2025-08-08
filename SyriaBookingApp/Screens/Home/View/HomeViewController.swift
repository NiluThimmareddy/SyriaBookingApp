//
//  HomeViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import UIKit
//import Reachability

enum DatePickerMode {
    case checkIn
    case checkOut
}

struct WhereToNextList{
    var image : String
    var City : String
    
    init( image: String, City: String) {
        self.image = image
        self.City = City
    }
}

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
    var datePickerContainerView: UIView!
    var datePicker: UIDatePicker!
    var activeButton: UIButton?
    var currentDatePickerMode: DatePickerMode = .checkIn
    var selectedCheckInDate: Date?
    
    var isDatePickerShown = false
    var promotionScrollTimer: Timer?
    
    var cities = [String]()
    var WhereToNextCityList = [WhereToNextList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader()
        setupUI()
        viewModel.fetchHotels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchView.applyCardStyle()
        gradientView.applyTopRightLightGreenGradient()
        gradientView.applyCardStyle()
        topView.addTopShadow()
    }
    
    @IBAction func leftMenuBarButtonAction(_ sender: UIBarButtonItem) {
        sender.isEnabled = false
        let storyboard = UIStoryboard(name: "Leftmenu", bundle: nil)
        let menuVC = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
        //        menuVC.btnMenu = sender
        
        self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        self.navigationController?.navigationBar.isHidden = true
        menuVC.view.layoutIfNeeded()
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
        }, completion:nil)
    }
    
    @IBAction func notificationBarButtonAction(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Rooms", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "RegisterMobileNumberVC") as? RegisterMobileNumberVC else { return }
        
        if let sheet = controller.sheetPresentationController {
            sheet.detents = [
                .custom { context in context.maximumDetentValue * 0.3 },
                .large()
            ]
            sheet.selectedDetentIdentifier = .medium
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
        controller.modalPresentationStyle = .pageSheet
        present(controller, animated: true)
    }
    
    @IBAction func rightMenuBarButtonAction(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard.init(name: "RightMenu", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "RightMenuViewController") as? RightMenuViewController {
            controller.modalPresentationStyle = .popover
            controller.navnController = self.navigationController
            controller.contentSize = CGSize(width: 210.0, height: (51.0 * Double((controller.menuArray.count))))
            controller.sourceView = self.view
            controller.barbuttonItem = sender
            
            if let popoverPresentationController = controller.popoverPresentationController {
                popoverPresentationController.delegate = controller
                popoverPresentationController.barButtonItem = sender
                popoverPresentationController.permittedArrowDirections = .any
                popoverPresentationController.sourceView = self.view
                controller.preferredContentSize = controller.contentSize ?? CGSize(width: 200, height: 200)
            }
            
            DispatchQueue.main.async {
                self.present(controller,animated: true, completion: nil)
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
        let storyboard = storyboard?.instantiateViewController(withIdentifier: "HotelListViewController") as! HotelListViewController
        storyboard.viewModel = self.viewModel
        
        storyboard.selectedCity = self.selectCityButton.titleLabel?.text ?? ""
        storyboard.navigationItem.title = "Hotel List"
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(storyboard, animated: true)
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
            return min(5, viewModel.recentlyViewdHotels.count)
        } else if collectionView == propertyTypeCollectionView {
            return  WhereToNextCityList.count
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
            let item = viewModel.recentlyViewdHotels[indexPath.row]
            cell.configure(with: item)
            return cell
        } else if collectionView == propertyTypeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WhereToNextCVC", for: indexPath) as! WhereToNextCVC
            let item = WhereToNextCityList[indexPath.row]
            cell.configure(with: item)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionsCollectionViewCell", for: indexPath) as! PromotionsCollectionViewCell
            //            let images = viewModel.filteredHotels[indexPath.row]
            //            cell.configuration(with: images)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == propertyTypeCollectionView{
            let HotelCity = WhereToNextCityList[indexPath.row].City
            let storyboard = storyboard?.instantiateViewController(withIdentifier: "HotelListViewController") as! HotelListViewController
            storyboard.viewModel = self.viewModel
            storyboard.selectedCity = HotelCity
            storyboard.navigationItem.title = "Hotel List"
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(storyboard, animated: true)
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
        } else if collectionView == promotionsCollectionView {
            let isIpad = UIDevice.current.userInterfaceIdiom == .pad
            let fullWidth = collectionView.bounds.width
            let fullHeight = collectionView.bounds.height
            
            let width = isIpad ? (fullWidth / 2) : fullWidth
            let height = fullHeight
            
            return CGSize(width: width, height: height)
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
    func setupUI() {
      rightMenuBarButton.image = UIImage(systemName: "ellipsis")?.rotate(radians: .pi / 2)
        viewModel.onDataLoaded = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.viewModel.fetchRecentlyVieeHotels{
                    self.recentlyCollectionView.reloadData()
                }
                
                self.hideLoader()
                
                self.topHotelsCollectionView.reloadData()
                self.promotionsCollectionView.reloadData()
                
                self.propertyTypeCollectionView.reloadData()
                
                var seen = Set<String>()
                self.cities = self.viewModel.hotels?.data.compactMap { $0.city }
                    .filter { seen.insert($0).inserted } ?? ["No cities found"]
                
                if let cityButton = self.selectCityButton {
                    self.configureDropdownMenu(for: cityButton, options: self.cities)
                }
                
                var seenCities = Set<String>()

                self.WhereToNextCityList = self.viewModel.hotels?.data.compactMap { hotel -> WhereToNextList? in
                    let city = hotel.city.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // Ensure city is not empty and not already added (case-insensitive)
                    guard !city.isEmpty, seenCities.insert(city.lowercased()).inserted else {
                        return nil
                    }

                    // Optional image trimming
                    let imageUrl = hotel.images.first?.trimmingCharacters(in: .whitespacesAndNewlines)

                    return WhereToNextList(image: imageUrl ?? "", City: city)
                } ?? []
                print("where to next Hotels List.... \(self.WhereToNextCityList)")
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
        
        updateGreetingMessage()
        setupDatePickerUI()
        startPromotionAutoScroll()
    }
    
    func updateGreetingMessage(with userName: String? = nil) {
        let hour = Calendar.current.component(.hour, from: Date())
        let greeting: String
        
        switch hour {
        case 5..<12:
            greeting = "Good Morning"
        case 12..<17:
            greeting = "Good Afternoon"
        case 17..<22:
            greeting = "Good Evening"
        default:
            greeting = ""
        }
        
        let nameToShow = (userName?.isEmpty == false) ? userName! : "User"
        messageLabel.text = "\(greeting) \(nameToShow)!"
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
            // Allow same-day checkout
            datePicker.minimumDate = checkIn
            datePicker.date = checkIn
        }
    }


    @objc private func dateChanged(_ sender: UIDatePicker) {
        switch currentDatePickerMode {
        case .checkIn:
            selectedCheckInDate = sender.date
            checkOutButton.setTitle("check out", for: .normal)
        case .checkOut :
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
    
}
