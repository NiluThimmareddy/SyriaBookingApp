//
//  HomeDetailsViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import UIKit
import SkeletonView

class HotelDetailsViewController : BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hotelImagesCollectionView: UICollectionView!
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var averageRatingsLabel: UILabel!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var overViewButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var facilitiesView: UIView!
    @IBOutlet weak var facilitiesButton: UIButton!
    @IBOutlet weak var verticalStackview: UIStackView!
    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var facilitiesViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var availabilityRoomsView: UIView!
    @IBOutlet weak var availabilityButton: UIButton!
    @IBOutlet weak var roomsAvailabilityCollectionView: UICollectionView!
    @IBOutlet weak var availabilityRoomsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var roomsCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addReviewView: UIView!
    @IBOutlet weak var addReviewViewButton: UIButton!
    @IBOutlet weak var enterYourNameTF: UITextField!
    @IBOutlet weak var selectratingButton: UIButton!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var submitReviewButton: UIButton!
    @IBOutlet weak var addReviewViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rateAndReviewsView: UIView!
    @IBOutlet weak var rateAndReviewsLabel: UILabel!
    @IBOutlet weak var rateAndReviewsDownButton: UIButton!
    @IBOutlet weak var rateAndReviewsTableview: UITableView!
    @IBOutlet weak var rateAndReviewsTableviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rateAndReviewsContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var facilitiesLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var addReviewLabel: UILabel!
    @IBOutlet weak var yourNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var contactTypesLabel: UILabel!
    @IBOutlet weak var pleseClickHereButton: UIButton!
    @IBOutlet weak var totalPriceView: UIView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var hotelAddressLabel: UILabel!
    
    @IBOutlet weak var discountImage: UIImageView!
    @IBOutlet weak var discountLabel: UILabel!
    
    var hotelviewModel = HotelViewModel()
    var selectedHotel: Hotel?
    var selectedRoom: RoomElement?
    var selectedRoomRates = [Rate]()
    let imageCache = NSCache<NSString, UIImage>()
    var isDescriptionVisible = true
    var isFacilitiesVisible = false
    var isAvailabilityVisible = false
    var isAddReviewVisible = true
    var isRateAndReviewVisible = true
    var currentHorizontalStack: UIStackView?
    var scrolleView: UIScrollView { scrollView }
    var scrollToTopButton = UIButton(type: .system)
    var scrolltoTopHelper : ScrollToTopHelper?
    
    var selectedRates: [Rate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSkeletonAppearance()
        setupSkeletonableViews()
        hideKeyboardWhenTappedAround()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.showInitialSkeleton()
        }
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showInitialSkeleton()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.setUpUI()
            self.roomsAvailabilityCollectionView.reloadData()
            self.setupAppNavigationBar()
            
            if let hotelId = self.selectedHotel?.id,
               let updatedHotel = HotelDataMaganer.shared.allHotels.first(where: { $0.id == hotelId }) {
                self.selectedHotel = updatedHotel
                self.rateAndReviewsTableview.reloadData()
            }
        }
        selectedRates = []
        selectedRoom = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Hide skeleton after data is loaded (simulate loading time)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.hideAllSkeletons()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateRateAndReviewsTableHeight()
    }
    
    // MARK: - IBActions
    @IBAction func segmentControlAction(_ sender: Any) {
    }
    
    @IBAction func overViewButtonAction(_ sender: Any) {
        isDescriptionVisible.toggle()
        
        descriptionLabel.isHidden = !isDescriptionVisible
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func pleaseClickHereButtonAction(_ sender: Any) {
        let controller = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ReportAnAppVC") as! ReportAnAppVC
        controller.comingfrom = .HotelDetail
        controller.hotelID = selectedHotel?.id ?? ""
        controller.hotelName = selectedHotel?.name ?? ""
        present(controller, animated: true)
    }
    
    @IBAction func facilitiesButtonAction(_ sender: Any) {
        isFacilitiesVisible.toggle()
        
        for subview in verticalStackview.arrangedSubviews {
            if let label = subview as? UILabel {
                continue
            }
            subview.isHidden = !isFacilitiesVisible
        }
        facilitiesViewHeightConstraint.constant = isFacilitiesVisible ? 300 : 40
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func availabilityButtonAction(_ sender: Any) {
        isAvailabilityVisible.toggle()
        
        if isAvailabilityVisible {
            updateAvailabilityRoomsViewHeight()
        } else {
            availabilityRoomsViewHeightConstraint.constant = 40
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func addReviewImgButtonAction(_ sender: Any) {
    }
    
    @IBAction func submitReviewButtonAction(_ sender: Any) {
        guard let user = UserSessionManager.getUser() else { return }
        guard let selectedHotel = selectedHotel else { return}
        
        guard let name = enterYourNameTF?.text else {
            showAlert("Please enter name")
            return
        }
        
        guard (selectratingButton.titleLabel?.text) != nil else {
            showAlert("Please select Rating")
            return
        }
        
        guard let reviewTextView = reviewTextView.text else {
            showAlert("Please enter review")
            return
        }
        
        self.hotelviewModel.onSuccess = { [weak self] review in
            guard let self = self else { return }
            showAlert(title: "Syriabooking", message: "thank you for your valueable review ", onOK:  {
                self.hotelviewModel.fetchReviewsOfHotel(hotelId: selectedHotel.id,reviewId: review.id)
                
                self.hotelviewModel.onSuccess = {[weak self] response in
                }
            })
        }
        
        self.hotelviewModel.onReviewError = { error in
            self.showAlert("something went wrong try again! : \(error.description)")
        }
        
        hotelviewModel.SubmitReview(HotelId: selectedHotel.id, reviewerName:name, rating: selectratingButton.tag, reviewText:  reviewTextView)
    }
    
    @IBAction func rateAndReviewsDownButtonAction(_ sender: Any) {
        isRateAndReviewVisible.toggle()
        
        if isRateAndReviewVisible {
            rateAndReviewsTableview.isHidden = false
            
            let labelHeight: CGFloat = 18
            let buttonHeight: CGFloat = 25
            let padding: CGFloat = 10
            
            let tableHeight = rateAndReviewsTableview.contentSize.height
            let totalHeight = labelHeight + buttonHeight + padding + tableHeight
            rateAndReviewsContainerHeightConstraint.constant = totalHeight
            
        } else {
            let labelHeight: CGFloat = 18
            let buttonHeight: CGFloat = 25
            let padding: CGFloat = 10
            
            let totalHeight = labelHeight + buttonHeight + padding
            rateAndReviewsContainerHeightConstraint.constant = totalHeight
            rateAndReviewsTableview.isHidden = true
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func viewAllRateAndReviewsButtonAction(_ sender: Any) {
        let viewAllVC = storyboard?.instantiateViewController(withIdentifier: "ViewAllRateAndReviewsVC") as! ViewAllRateAndReviewsVC
        viewAllVC.selectedHotel = selectedHotel
        viewAllVC.modalPresentationStyle = .overFullScreen
        present(viewAllVC, animated: true)
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension HotelDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // If skeleton is active, return skeleton count
        if collectionView.sk.isSkeletonActive {
            return collectionSkeletonView(collectionView, numberOfItemsInSection: section)
        }
        
        if collectionView == hotelImagesCollectionView {
//            guard let hotel = selectedHotel else { return 0 }
//            let imageCount = hotel.images.count
//            return Int(ceil(Double(imageCount) / 5.0))
            return 1
        } else {
            return selectedHotel?.rooms.count ?? 0
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
            
            return cell
        }
        
        if collectionView == hotelImagesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsPageHotelImagesCVC", for: indexPath) as! DetailsPageHotelImagesCVC
            guard let hotel = selectedHotel else { return cell }
            let images = hotel.images
            let startIndex = indexPath.row * 5
            let endIndex = min(startIndex + 5, images.count)
            let imagesToShow = Array(images[startIndex..<endIndex])
            
            let imageViews = [
                cell.hotelImageOne,
                cell.hotelImageTwo,
                cell.hotelImageThree,
                cell.hotelImageFour,
                cell.hotelImageFive
            ]
            
            for imageView in imageViews {
                imageView?.image = UIImage(named: "HotelPlaceholder")
                imageView?.stopShimmering()
            }
            
            cell.countLabel.isHidden = true
            cell.shadowView.isHidden = imagesToShow.count < 5
            cell.shadowViewButton.isHidden = imagesToShow.count < 5
            
            for (i, imageView) in imageViews.enumerated() {
                if i < imagesToShow.count {
                    let imageUrl = imagesToShow[i]
                    if let cachedImage = imageCache.object(forKey: imageUrl as NSString) {
                        imageView?.image = cachedImage
                    } else {
                        imageView?.image = nil
                        imageView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
                        imageView?.startPulseShimmer()
                        loadImage(from: imageUrl, into: imageView!) {
                            imageView?.stopShimmering()
                            imageView?.backgroundColor = .clear
                        }
                    }
                }
            }
            
            if imagesToShow.count == 5 {
                let remaining = images.count - (startIndex + 5)
                if remaining > 0 {
                    cell.countLabel.isHidden = false
                    cell.countLabel.text = "+\(remaining)"
                }
            }
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailabilityRoomsCVC", for: indexPath) as! AvailabilityRoomsCVC
            
            // Add safety check for rooms
            guard let rooms = selectedHotel?.rooms, indexPath.row < rooms.count else {
                return cell
            }
            
            let room = rooms[indexPath.row]
            cell.delegate = self
            cell.parentHotel = self.selectedHotel
            cell.onBooknowBottonClick = { selectedRoom in
                if UserSessionManager.getUser() == nil{
                    let storyboard = UIStoryboard(name: "Booking", bundle: nil)
                    guard let controller = storyboard.instantiateViewController(withIdentifier: "RegisterMobileNumberVC") as? RegisterMobileNumberVC else { return }
                    controller.comingFrom = .HomeSliderView
                    controller.modalPresentationStyle = .overFullScreen
                    controller.transitioningDelegate = self
                    controller.reloadScreenAfterDismiss = {
                        self.dismissPopup()
                    }
                    self.present(controller, animated: true)
                } else {
                    guard let room = selectedRoom else { return }
                    self.selectedRoom = room
                    self.selectedRoomRates = room.rates
                    if let selectedRate = room.rates.first(where: { $0.isSelected == true }) {
                        cell.delegate?.didTapBookNow(for: room, selectedRate: selectedRate)
                    } else {
                        cell.delegate?.showAlertForRateSelection()
                    }
                }
            }
            
            cell.onRateSelectionChanged = { [weak self] rate in
                guard let self = self else { return }
                
                if rate.isSelected == true {
                    if let index = self.selectedRates.firstIndex(where: { $0.id == rate.id }) {
                        self.selectedRates[index] = rate
                    } else {
                        self.selectedRates.append(rate)
                    }
                } else {
                    self.selectedRates.removeAll { $0.id == rate.id }
                }
                
                cell.segmentChanged = {
                    self.totalPriceView.isHidden = true
                }
                self.updateTotalPrice()
            }
            cell.configure(with: room)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == hotelImagesCollectionView {
            let totalWidth = collectionView.bounds.width
            let height: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 450 : 250
            return CGSize(width: totalWidth, height: height)
        } else {
            // Add safety checks
            guard let rooms = selectedHotel?.rooms, indexPath.row < rooms.count else {
                return CGSize(width: collectionView.frame.width, height: 400)
            }
            
            let room = rooms[indexPath.row]
            let height = calculateRoomCellHeight(for: room)
            return CGSize(width: collectionView.frame.width, height: height)
        }
    }
    
    func loadImage(from urlString: String, into imageView: UIImageView, completion: @escaping () -> Void) {
        guard let url = URL(string: urlString) else {
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let data = data, let image = UIImage(data: data), error == nil else {
                    completion()
                    return
                }
                
                self?.imageCache.setObject(image, forKey: urlString as NSString)
                imageView.image = image
                completion()
            }
        }.resume()
    }
}

// MARK: - UITableView Delegate & DataSource
extension HotelDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.sk.isSkeletonActive {
            return 3
        }
        return min(selectedHotel?.reviews.count ?? 0, 5)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.sk.isSkeletonActive {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RateAndReviewsTVC", for: indexPath) as! RateAndReviewsTVC
            cell.isSkeletonable = true
            cell.contentView.isSkeletonable = true
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RateAndReviewsTVC") as! RateAndReviewsTVC
        if let reviews = selectedHotel?.reviews, indexPath.row < reviews.count {
            let review = reviews[indexPath.row]
            cell.configure(with: review)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let scrolltoTopHelper = scrolltoTopHelper else { return }
        scrolltoTopHelper.scrollViewDidScroll(scrolleView)
    }
}

// MARK: - SkeletonView Data Source
extension HotelDetailsViewController: SkeletonCollectionViewDataSource, SkeletonTableViewDataSource {
    
    // MARK: Collection View Skeleton Methods
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if skeletonView == hotelImagesCollectionView {
            return 1
        } else if skeletonView == roomsAvailabilityCollectionView {
            return 3
        }
        return 3
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if skeletonView == hotelImagesCollectionView {
            return "DetailsPageHotelImagesCVC"
        } else if skeletonView == roomsAvailabilityCollectionView {
            return "AvailabilityRoomsCVC"
        }
        return "AvailabilityRoomsCVC"
    }
    
    // MARK: Table View Skeleton Methods
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "RateAndReviewsTVC"
    }
}

// MARK: - Main Implementation
extension HotelDetailsViewController : AvailabilityRoomsCVCDelegate, UIViewControllerTransitioningDelegate {
    func didTapBookNow(for room: RoomElement, selectedRate: Rate) {
        if let user = UserSessionManager.getUser(){
            let controller = UIStoryboard(name: "Booking", bundle: nil).instantiateViewController(withIdentifier: "BookingPoliciesVC") as! BookingPoliciesVC
            controller.guestName = user.name
            controller.guestEmail = user.email
            controller.guestMobileNumber = user.mobile
            controller.selectedHotel = self.selectedHotel
            controller.selectedRoom = self.selectedRoom
            controller.selectedRates = self.selectedRates
            self.present(controller, animated: true)
        }
    }
    
    func showRefundPolicy(for room: RoomElement) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let refundVC = storyboard.instantiateViewController(withIdentifier: "RefundPolicyVC") as? RefundPolicyVC else { return }
        refundVC.modalPresentationStyle = .overFullScreen
        self.present(refundVC, animated: true)
    }
    
    func presentationController(forPresented presented: UIViewController,presenting: UIViewController?,source: UIViewController) -> UIPresentationController? {
        return CenteredPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func showAlertForRateSelection() {
        showAlert("Please select a rate and ensure hotel/room data is present.")
    }
    func showLoginRequiredAlert() {

        let alert = UIAlertController(
            title: "Login Required",
            message: "Please login to select a room.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)
    }
    
    func updateTotalPrice() {
        if !selectedRates.isEmpty {
            let isLocal = selectedRates[0].isLocal
            if isLocal {
                let total = selectedRates.reduce(0) {
                    $0 + (($1.localPrice ?? 0) * Double($1.selectedQuantity))
                }
                let selectedRoomsCount = selectedRates.filter { ($0.selectedQuantity) > 0 }.count
                let totalQuantity = selectedRates.reduce(0) { $0 + ($1.selectedQuantity) }
                
                let totalDiscount = selectedRates.reduce(0) { $0 + ($1.localDiscount ?? 0) }
                if total > 0 {
                    totalAmountLabel.text = "\(selectedRoomsCount) Rooms (\(totalQuantity) Qty) - Total: SYP \(total) (\(totalDiscount)% Discount"
                } else {
                    totalAmountLabel.text = ""
                }
                totalPriceView.isHidden = total == 0
            }else{
                let total = selectedRates.reduce(0) {
                    $0 + (($1.price) * Double($1.selectedQuantity))
                }
                let selectedRoomsCount = selectedRates.filter { ($0.selectedQuantity) > 0 }.count
                let totalQuantity = selectedRates.reduce(0) { $0 + ($1.selectedQuantity) }
                
                let totalDiscount = selectedRates.reduce(0) { $0 + ($1.discount ?? 0) }
                if total > 0 {
                    totalAmountLabel.text = "\(selectedRoomsCount) Rooms (\(totalQuantity) Qty) - Total: $ \(total) (\(totalDiscount)% Discount"
                } else {
                    totalAmountLabel.text = ""
                }
                totalPriceView.isHidden = total == 0
            }
        } else {
            totalPriceView.isHidden = true
        }
    }
    
    func setUpUI() {
        if let user = UserSessionManager.getUser() {
            enterYourNameTF.text = user.name
            enterYourNameTF.isUserInteractionEnabled = false
            addReviewViewHeightConstraint.constant = 450
            addReviewView.isHidden = false
        } else {
            addReviewViewHeightConstraint.constant = 0
            addReviewView.isHidden = true
        }
        totalPriceView.isHidden = true
        
        scrollToTopButton.setImage(UIImage(systemName: "arrow.up.to.line.compact"), for: .normal)
        scrollToTopButton.imageView?.contentMode = .scaleToFill
        rateAndReviewsTableview.register(UINib(nibName: "RateAndReviewsTVC", bundle: nil), forCellReuseIdentifier: "RateAndReviewsTVC")
        hotelImagesCollectionView.register(UINib(nibName: "DetailsPageHotelImagesCVC", bundle: nil), forCellWithReuseIdentifier: "DetailsPageHotelImagesCVC")
        hotelImagesCollectionView.reloadData()
        
        roomsAvailabilityCollectionView.register(UINib(nibName: "AvailabilityRoomsCVC", bundle: nil), forCellWithReuseIdentifier: "AvailabilityRoomsCVC")
        if let layouts = roomsAvailabilityCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layouts.estimatedItemSize = .zero
        }
        roomsAvailabilityCollectionView.reloadData()
        DispatchQueue.main.async {
            self.updateAvailabilityRoomsViewHeight()
        }
        
        isAvailabilityVisible = false
        availabilityRoomsViewHeightConstraint.constant = 40
        isAddReviewVisible = true
        isRateAndReviewVisible = true
        
        guard let hotel = selectedHotel else { return }
        let ratingValue = hotel.starRating
        let intRating = Int(ratingValue)
        let hotelNameAttributed = NSMutableAttributedString(
            string: "\(hotel.name) ",
            attributes: [.foregroundColor: UIColor.label]
        )
        let city = hotel.city
        if !city.isEmpty {
            let cityAttributed = NSAttributedString(
                string: "| \(city)  ",
                attributes: [.foregroundColor: UIColor.label]
            )
            hotelNameAttributed.append(cityAttributed)
        }
        if intRating > 0 && intRating <= 5 {
            let stars = String(repeating: "★", count: intRating)
            let starAttributed = NSAttributedString(
                string: stars + " ",
                attributes: [.foregroundColor: UIColor.black]
            )
            hotelNameAttributed.append(starAttributed)
        }
        hotelNameLabel.attributedText = hotelNameAttributed
        hotelAddressLabel.text = hotel.addressLine1
        descriptionLabel.text = hotel.description
        
        if let discount = hotel.discountText {
            discountLabel.isHidden = false
            discountImage.isHidden = false
            discountLabel.text = discount
        }else{
            discountLabel.isHidden = true
            discountImage.isHidden = true
        }
        
        
        rateAndReviewsLabel.text = "Rate & Reviews \(hotel.averageRating) (\(hotel.reviewCount) reviews)"
        if AppSettings.shared.selectedLanguage == .arabic {
            averageRatingsLabel.text = "\(hotel.averageRating) (\(hotel.reviewCount) مراجعات)"
            contactTypesLabel.text = "للتواصل مباشرة مع \(hotel.name) في حالة وجود أي استفسار / ملاحظات / شكوى،"
            rateAndReviewsLabel.text = "التقييمات والمراجعات \(hotel.averageRating) (\(hotel.reviewCount) مراجعات)"
        } else {
            averageRatingsLabel.text = "\(hotel.averageRating) (\(hotel.reviewCount) reviews)"
            contactTypesLabel.text = "To contact directly \(hotel.name) in case of any enquiry / feedback / complaint,"
            rateAndReviewsLabel.text = "Rate & Reviews \(hotel.averageRating) (\(hotel.reviewCount) reviews)"
        }
        setupAmenities(hotel.amenities)
        
        rateAndReviewsTableview.rowHeight = UITableView.automaticDimension
        rateAndReviewsTableview.estimatedRowHeight = 100
        rateAndReviewsTableview.reloadData()
        DispatchQueue.main.async {
            self.updateRateAndReviewsTableHeight()
            self.updateRateAndReviewsContainerHeight()
        }
        
        setupRatingDropdownMenu()
        scrollView.addTopShadow()
        
        averageRatingsLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAverageRating))
        averageRatingsLabel.addGestureRecognizer(tapGesture)
        hideViewAllButton()
        hotelNameLabel.font = .titleFont
        [overViewLabel,facilitiesLabel,availabilityLabel,addReviewLabel,rateAndReviewsLabel].forEach { fontSize in
            fontSize?.font = .subtitleFont
        }
        [yourNameLabel,ratingLabel,reviewLabel].forEach { fontSize in
            fontSize?.font = .bodyFont
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setUpLanguage),
            name: .languageChanged,
            object: nil
        )
        
        setUpLanguage()
    }
    
    func hideViewAllButton() {
        if selectedHotel?.reviews.count ?? 0 > 5 {
            viewAllButton.isHidden = false
        } else {
            viewAllButton.isHidden = true
        }
    }
    
    func setupAmenities(_ amenitiesString: String?) {
        verticalStackview.arrangedSubviews.forEach {
            verticalStackview.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        guard let amenitiesString = amenitiesString, !amenitiesString.isEmpty else { return }
        
        let amenitiesArray = amenitiesString.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        var currentRow = createHorizontalStack()
        verticalStackview.addArrangedSubview(currentRow)
        var currentRowWidth: CGFloat = 0
        let maxRowWidth = view.frame.width - 40
        
        for amenity in amenitiesArray {
            let label = createAmenityLabel(title: amenity)
            let labelWidth = label.intrinsicContentSize.width + 20
            
            if currentRowWidth + labelWidth > maxRowWidth {
                currentRow = createHorizontalStack()
                verticalStackview.addArrangedSubview(currentRow)
                currentRowWidth = 0
            }
            currentRow.addArrangedSubview(label)
            currentRowWidth += labelWidth + currentRow.spacing
        }
    }
    
    func createHorizontalStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        return stack
    }
    
    func createAmenityLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.clipsToBounds = true
        label.backgroundColor = UIColor.systemGray6
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return label
    }
    
    func updateAvailabilityRoomsViewHeight() {
        guard let rooms = selectedHotel?.rooms, !rooms.isEmpty else {
            availabilityRoomsViewHeightConstraint.constant = 0
            roomsCollectionViewHeightConstraint.constant = 0
            return
        }
        
        var totalHeight: CGFloat = 0
        for room in rooms {
            let cellHeight = calculateRoomCellHeight(for: room)
            totalHeight += cellHeight
        }
        
        availabilityRoomsViewHeightConstraint.constant = totalHeight + 100
        roomsCollectionViewHeightConstraint.constant = totalHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func calculateRoomCellHeight(for room: RoomElement) -> CGFloat {
        let baseHeight: CGFloat = 350
        let rateRowHeight: CGFloat = 40
        let rateCount = room.rates.count
        let tableHeight = CGFloat(rateCount) * rateRowHeight
        let spacing: CGFloat = 10
        return baseHeight + tableHeight + spacing
    }
    
    func updateRateAndReviewsTableHeight() {
        rateAndReviewsTableview.layoutIfNeeded()
        let contentHeight = rateAndReviewsTableview.contentSize.height
        rateAndReviewsTableviewHeightConstraint.constant = contentHeight + 50
        rateAndReviewsContainerHeightConstraint.constant = contentHeight + 60
    }
    
    func updateRateAndReviewsContainerHeight() {
        let labelHeight: CGFloat = 18
        let buttonHeight: CGFloat = 25
        let padding: CGFloat = 20
        
        rateAndReviewsTableview.layoutIfNeeded()
        let tableHeight = rateAndReviewsTableview.contentSize.height
        let totalHeight = labelHeight + buttonHeight + padding + tableHeight
        
        rateAndReviewsContainerHeightConstraint.constant = totalHeight + 50
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setupRatingDropdownMenu() {
        let starOptions: [(Int, String)] = [
            (5, "★★★★★ (5 - Excellent)"),
            (4, "★★★★ (4 - Good)"),
            (3, "★★★ (3 - Average)"),
            (2, "★★ (2 - Poor)"),
            (1, "★ (1 - Terrible)")
        ]
        
        var actions: [UIAction] = []
        for (rating, title) in starOptions {
            let action = UIAction(title: title, handler: { [weak self] _ in
                self?.selectratingButton.setTitle(title, for: .normal)
                self?.selectratingButton.tag = rating
            })
            actions.append(action)
        }
        
        let menu = UIMenu(title: "Select Rating", children: actions)
        selectratingButton.showsMenuAsPrimaryAction = true
        selectratingButton.menu = menu
    }
    
    @objc func didTapAverageRating() {
        if !isRateAndReviewVisible {
            rateAndReviewsDownButtonAction(rateAndReviewsDownButton)
        }
        
        let targetPoint = scrollView.convert(rateAndReviewsView.frame.origin, from: rateAndReviewsView.superview)
        let yOffset = max(targetPoint.y - 10, 0)
        
        scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
    }
    
    @objc func setUpLanguage() {
        if AppSettings.shared.selectedLanguage == .english{
            facilitiesLabel.text = "What this place offers (Facilities)"
            availabilityLabel.text = "Availability"
            yourNameLabel.text = "Your Name"
            addReviewLabel.text = " Add a review"
            ratingLabel.text = "Rates"
            submitReviewButton.setTitle("Submit Review", for: .normal)
            viewAllButton.setTitle("View all", for: .normal)
            selectratingButton.setTitle("Select rating", for: .normal)
            reviewLabel.text = "Review"
            overViewLabel.text = "Overview"
            pleseClickHereButton.setTitle("Please click here", for: .normal)
            pleseClickHereButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        } else {
            facilitiesLabel.text = "ما يقدمه هذا المكان (المرافق)"
            availabilityLabel.text = " التوافر"
            yourNameLabel.text = "اسمك"
            addReviewLabel.text = " أضف مراجعة"
            ratingLabel.text = "التقييم"
            submitReviewButton.setTitle( "إرسال المراجعة", for: .normal)
            viewAllButton.setTitle( "عرض الكل", for: .normal)
            selectratingButton.setTitle("اختر التقييم", for: .normal)
            reviewLabel.text = "مراجعة"
            overViewLabel.text = "نظرة عامة"
            pleseClickHereButton.setTitle("يرجى النقر هنا", for: .normal)
            pleseClickHereButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        }
    }
}

extension HotelDetailsViewController: DetailsPageHotelImagesCVCDelegate {
    func didTapImageFive(in cell: DetailsPageHotelImagesCVC) {
        guard let galleryVC = storyboard?.instantiateViewController(withIdentifier: "HotelImagesGalleryVC") as? HotelImagesGalleryVC else {
            return
        }
        galleryVC.selectedHotel = selectedHotel
        galleryVC.galleryType = .hotel
        galleryVC.initialIndex = 0
        present(galleryVC, animated: true)
    }
}

extension HotelDetailsViewController {
    // MARK: - Skeleton Configuration
    private func configureSkeletonAppearance() {
        let gradient = SkeletonGradient(baseColor: UIColor.systemGray5)
        SkeletonAppearance.default.gradient = gradient
        SkeletonAppearance.default.tintColor = UIColor.systemGray4
        SkeletonAppearance.default.multilineHeight = 12
        SkeletonAppearance.default.multilineSpacing = 8
        SkeletonAppearance.default.multilineCornerRadius = 4
    }
    
    private func setupSkeletonableViews() {
        scrollView.isSkeletonable = true
        backView.isSkeletonable = true
        hotelImagesCollectionView.isSkeletonable = true
        roomsAvailabilityCollectionView.isSkeletonable = true
        rateAndReviewsTableview.isSkeletonable = true
        setupStackViewsForSkeleton()
        setupButtonsForSkeleton()
        setupEnhancedButtonSkeleton()
        
        let skeletonViews: [UIView?] = [
            reviewView, hotelNameLabel, overView, facilitiesView,
            availabilityRoomsView, addReviewView, rateAndReviewsView,
            totalPriceView, overViewLabel, contactTypesLabel,
            pleseClickHereButton, facilitiesLabel, averageRatingsLabel,
            descriptionLabel, availabilityLabel, addReviewLabel,
            yourNameLabel, ratingLabel, reviewLabel, rateAndReviewsLabel,
            overViewButton, facilitiesButton, availabilityButton,
            addReviewViewButton, rateAndReviewsDownButton, viewAllButton,
            submitReviewButton, selectratingButton, hotelAddressLabel, discountImage, discountLabel
        ]
        
        skeletonViews.forEach { view in
            guard let view = view else { return }
            view.isSkeletonable = true
            view.skeletonCornerRadius = 4
        }
        configureLabelSkeletonProperties()
    }
    
    private func setupStackViewsForSkeleton() {
        if let horizontalStackView = horizontalStackView {
            horizontalStackView.isSkeletonable = true
            horizontalStackView.clipsToBounds = false
            horizontalStackView.backgroundColor = .clear
            if horizontalStackView.arrangedSubviews.isEmpty {
                addPlaceholderViewsToHorizontalStack()
            } else {
                horizontalStackView.arrangedSubviews.forEach { subview in
                    subview.isSkeletonable = true
                    subview.skeletonCornerRadius = 4
                    subview.clipsToBounds = false
                }
            }
        }
        if let verticalStackview = verticalStackview {
            verticalStackview.isSkeletonable = true
            verticalStackview.arrangedSubviews.forEach { subview in
                subview.isSkeletonable = true
                subview.skeletonCornerRadius = 4
            }
        }
    }
    
    private func addPlaceholderViewsToHorizontalStack() {
        guard let horizontalStackView = horizontalStackView else { return }
        horizontalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for _ in 0..<4 {
            let placeholderView = UIView()
            placeholderView.isSkeletonable = true
            placeholderView.skeletonCornerRadius = 8
            placeholderView.backgroundColor = .clear
            placeholderView.clipsToBounds = false
            placeholderView.translatesAutoresizingMaskIntoConstraints = false
            placeholderView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            placeholderView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            
            horizontalStackView.addArrangedSubview(placeholderView)
        }
    }
    
    private func setupButtonsForSkeleton() {
        let buttons: [UIButton?] = [
            facilitiesButton, availabilityButton, overViewButton,
            addReviewViewButton, rateAndReviewsDownButton, viewAllButton,
            submitReviewButton, selectratingButton, pleseClickHereButton
        ]
        
        buttons.forEach { button in
            guard let button = button else { return }
            button.isSkeletonable = true
            button.skeletonCornerRadius = 8
            
            if button == pleseClickHereButton {
                button.backgroundColor = .clear 
            }
            
            if let titleLabel = button.titleLabel {
                titleLabel.isSkeletonable = true
                titleLabel.skeletonTextLineHeight = .fixed(16)
                titleLabel.lastLineFillPercent = 100
            }
            
            if let imageView = button.imageView {
                imageView.isSkeletonable = true
                imageView.skeletonCornerRadius = 4
            }
        }
    }
    
    private func setupEnhancedButtonSkeleton() {
        let rectangularButtons: [UIButton?] = [
            facilitiesButton, availabilityButton, overViewButton,
            addReviewViewButton, rateAndReviewsDownButton
        ]
        
        rectangularButtons.forEach { button in
            guard let button = button else { return }
            button.isSkeletonable = true
            button.skeletonCornerRadius = 6
            button.layer.cornerRadius = 6
            
            if button.bounds.height < 30 {
                button.translatesAutoresizingMaskIntoConstraints = false
                button.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
            }
        }
        
        let actionButtons: [UIButton?] = [
            viewAllButton, submitReviewButton, pleseClickHereButton
        ]
        
        actionButtons.forEach { button in
            guard let button = button else { return }
            button.isSkeletonable = true
            button.skeletonCornerRadius = 8 // More rounded for action buttons
            button.layer.cornerRadius = 8
            
            if button.bounds.height < 40 {
                button.translatesAutoresizingMaskIntoConstraints = false
                button.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
            }
        }
        
        if let selectratingButton = selectratingButton {
            selectratingButton.isSkeletonable = true
            selectratingButton.skeletonCornerRadius = 6
            selectratingButton.layer.cornerRadius = 6
        }
    }
    
    private func configureLabelSkeletonProperties() {
        hotelNameLabel.lastLineFillPercent = 100
        hotelNameLabel.skeletonTextLineHeight = SkeletonTextLineHeight.fixed(24)
        
        averageRatingsLabel.lastLineFillPercent = 70
        averageRatingsLabel.skeletonTextLineHeight = SkeletonTextLineHeight.fixed(16)
        descriptionLabel.lastLineFillPercent = 50
        descriptionLabel.skeletonTextLineHeight = SkeletonTextLineHeight.fixed(16)
        
        let sectionTitles: [UILabel?] = [overViewLabel, facilitiesLabel, availabilityLabel, addReviewLabel, rateAndReviewsLabel]
        sectionTitles.forEach { label in
            guard let label = label else { return }
            label.lastLineFillPercent = 100
            label.skeletonTextLineHeight = SkeletonTextLineHeight.fixed(18)
        }
        
        let formLabels: [UILabel?] = [yourNameLabel, ratingLabel, reviewLabel, contactTypesLabel]
        formLabels.forEach { label in
            guard let label = label else { return }
            label.lastLineFillPercent = 80
            label.skeletonTextLineHeight = SkeletonTextLineHeight.fixed(16)
        }
    }
    
    private func showInitialSkeleton() {
        let mainSkeletonViews: [UIView?] = [
            reviewView, hotelNameLabel, overView, facilitiesView,
            availabilityRoomsView, addReviewView, rateAndReviewsView,
            totalPriceView,hotelAddressLabel, discountImage, discountLabel
        ]
        
        mainSkeletonViews.forEach { view in
            guard let view = view else { return }
            view.showAnimatedGradientSkeleton()
        }
        
        [hotelNameLabel, averageRatingsLabel, descriptionLabel, overViewLabel,
         facilitiesLabel, availabilityLabel, addReviewLabel, rateAndReviewsLabel,
         yourNameLabel, ratingLabel, reviewLabel, contactTypesLabel,hotelAddressLabel, discountImage, discountLabel].forEach { label in
            guard let label = label else { return }
            label.showAnimatedGradientSkeleton()
        }
        
        hotelImagesCollectionView.showAnimatedGradientSkeleton()
        roomsAvailabilityCollectionView.showAnimatedGradientSkeleton()
        rateAndReviewsTableview.showAnimatedGradientSkeleton()
        showSkeletonOnButtons()
        showSkeletonOnStackViews()
    }
    
    private func showSkeletonOnButtons() {
        let buttons: [UIButton?] = [
            facilitiesButton, availabilityButton, overViewButton,
            addReviewViewButton, rateAndReviewsDownButton, viewAllButton,
            submitReviewButton, selectratingButton, pleseClickHereButton
        ]
        
        buttons.forEach { button in
            guard let button = button else { return }
            button.showAnimatedGradientSkeleton()
            button.titleLabel?.showAnimatedGradientSkeleton()
            button.imageView?.showAnimatedGradientSkeleton()
        }
    }
    
    private func showSkeletonOnStackViews() {
        if let verticalStackview = verticalStackview {
            verticalStackview.showAnimatedGradientSkeleton()
            verticalStackview.arrangedSubviews.forEach {
                $0.showAnimatedGradientSkeleton()
            }
        }
        
        if let horizontalStackView = horizontalStackView {
            horizontalStackView.layoutIfNeeded()
            horizontalStackView.showAnimatedGradientSkeleton()
            horizontalStackView.arrangedSubviews.forEach {
                $0.showAnimatedGradientSkeleton()
            }
            if horizontalStackView.arrangedSubviews.isEmpty {
                addTemporaryContentForSkeleton()
            }
        }
    }
    
    private func addTemporaryContentForSkeleton() {
        guard let horizontalStackView = horizontalStackView else { return }
        
        for _ in 0..<3 {
            let skeletonLabel = UILabel()
            skeletonLabel.isSkeletonable = true
            skeletonLabel.skeletonTextLineHeight = .fixed(16)
            skeletonLabel.lastLineFillPercent = 80
            skeletonLabel.text = "Loading..."
            skeletonLabel.font = UIFont.systemFont(ofSize: 14)
            skeletonLabel.textAlignment = .center
            skeletonLabel.backgroundColor = .clear
            
            skeletonLabel.translatesAutoresizingMaskIntoConstraints = false
            skeletonLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
            skeletonLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
            horizontalStackView.addArrangedSubview(skeletonLabel)
        }
        
        horizontalStackView.arrangedSubviews.forEach {
            $0.showAnimatedGradientSkeleton()
        }
    }
    
    private func hideAllSkeletons() {
        let mainSkeletonViews: [UIView?] = [
            reviewView, hotelNameLabel, overView, facilitiesView,
            availabilityRoomsView, addReviewView, rateAndReviewsView,
            totalPriceView,hotelAddressLabel, discountImage, discountLabel
        ]
        
        mainSkeletonViews.forEach { view in
            guard let view = view else { return }
            view.hideSkeleton()
        }
        
        [hotelNameLabel, averageRatingsLabel, descriptionLabel, overViewLabel,
         facilitiesLabel, availabilityLabel, addReviewLabel, rateAndReviewsLabel,
         yourNameLabel, ratingLabel, reviewLabel, contactTypesLabel,hotelAddressLabel, discountImage, discountLabel].forEach { label in
            guard let label = label else { return }
            label.hideSkeleton()
        }
        
        hotelImagesCollectionView.hideSkeleton()
        roomsAvailabilityCollectionView.hideSkeleton()
        rateAndReviewsTableview.hideSkeleton()
        
        hideSkeletonFromButtons()
        hideSkeletonFromStackViews()
        removeTemporaryContent()
    }
    
    private func hideSkeletonFromButtons() {
        let buttons: [UIButton?] = [
            facilitiesButton, availabilityButton, overViewButton,
            addReviewViewButton, rateAndReviewsDownButton, viewAllButton,
            submitReviewButton, selectratingButton, pleseClickHereButton
        ]
        
        buttons.forEach { button in
            guard let button = button else { return }
            button.hideSkeleton()
            button.titleLabel?.hideSkeleton()
            button.imageView?.hideSkeleton()
            if button == pleseClickHereButton {
                button.backgroundColor = .label
            }
        }
    }
    
    private func hideSkeletonFromStackViews() {
        if let verticalStackview = verticalStackview {
            verticalStackview.hideSkeleton()
            verticalStackview.arrangedSubviews.forEach { $0.hideSkeleton() }
        }
        
        if let horizontalStackView = horizontalStackView {
            horizontalStackView.hideSkeleton()
            horizontalStackView.arrangedSubviews.forEach { $0.hideSkeleton() }
        }
    }
    
    private func removeTemporaryContent() {
        guard let horizontalStackView = horizontalStackView else { return }
        
        let temporaryLabels = horizontalStackView.arrangedSubviews.filter {
            $0 is UILabel && ($0 as? UILabel)?.text == "Loading..."
        }
        
        if !temporaryLabels.isEmpty {
            temporaryLabels.forEach { $0.removeFromSuperview() }
        }
        
        let placeholderViews = horizontalStackView.arrangedSubviews.filter {
            $0.backgroundColor == .clear && $0.subviews.isEmpty
        }
        
        if !placeholderViews.isEmpty {
            placeholderViews.forEach { $0.removeFromSuperview() }
        }
    }
}

class CenteredPresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        
        let height = containerView.bounds.height * 0.3
        let width: CGFloat
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            width = containerView.bounds.width * 0.76
        } else {
            width = containerView.bounds.width
        }
        
        let originX = (containerView.bounds.width - width) / 2
        let originY = (containerView.bounds.height - height) / 2
        
        return CGRect(x: originX, y: originY, width: width, height: height)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = containerView else { return }
        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimmingView.alpha = 0
        dimmingView.tag = 99
        containerView.addSubview(dimmingView)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            dimmingView.alpha = 1
        })
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        containerView?.viewWithTag(99)?.removeFromSuperview()
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.layer.cornerRadius = 20
        presentedView?.clipsToBounds = true
    }
}
