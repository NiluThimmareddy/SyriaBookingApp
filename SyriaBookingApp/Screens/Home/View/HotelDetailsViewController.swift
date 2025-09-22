//
//  HomeDetailsViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import UIKit

class HotelDetailsViewController : UIViewController, ScrollToTopCapable {
  
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hotelImagesCollectionView: UICollectionView!
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var averageRatingsLabel: UILabel!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var overViewButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabelHeightConstraint: NSLayoutConstraint!
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
    
    var  hotelviewModel = HotelViewModel()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
        roomsAvailabilityCollectionView.reloadData()
        setupAppNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateRateAndReviewsTableHeight()
    }
    
    @IBAction func overViewButtonAction(_ sender: Any) {
        isDescriptionVisible.toggle()
        
        descriptionLabel.isHidden = !isDescriptionVisible
        descriptionLabelHeightConstraint.constant = isDescriptionVisible ? 300 : 40
        
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
//        isAddReviewVisible.toggle()
//
//        addReviewViewHeightConstraint.constant = isAddReviewVisible ? 450 : 40
//
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
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
                    //fisrt fetch the particular hotels reviews
                    self.hotelviewModel.fetchReviewsOfHotel(hotelId: selectedHotel.id,reviewId: review.id)
                    
                    self.hotelviewModel.onSuccess = {[weak self] response in
                        self?.selectedHotel?.reviews.insert(response, at: 0)
                        //here main hotelviewmodel hotel variable i want to add review means i whhole application i want to add this review where review is using
                        if let index = HotelDataMaganer.shared.allHotels.firstIndex(where: {$0.id == selectedHotel.id}){
                            HotelDataMaganer.shared.allHotels[index].reviews.insert(response, at: 0)
                        }
                        DispatchQueue.main.async {
                            self?.rateAndReviewsTableview.reloadData()
                        }
                        // then Reload revie Tableview
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
        viewAllVC.modalPresentationStyle = .fullScreen
        present(viewAllVC, animated: true)
    }
    
}

extension HotelDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hotelImagesCollectionView {
            guard let hotel = selectedHotel else { return 0 }
            let imageCount = hotel.images.count
            return Int(ceil(Double(imageCount) / 5.0))
        } else {
            return selectedHotel?.rooms.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
            let rooms = (selectedHotel?.rooms[indexPath.row])!
            cell.delegate = self
            cell.onBooknowBottonClick = { selectedRoom in
                if UserSessionManager.getUser() == nil{
                    // open loginin
                    let storyboard = UIStoryboard(name: "Booking", bundle: nil)
                    guard let controller = storyboard.instantiateViewController(withIdentifier: "RegisterMobileNumberVC") as? RegisterMobileNumberVC else { return }
                    controller.comingFrom = .HotelDetails
                    controller.modalPresentationStyle = .custom
                    controller.transitioningDelegate = self
                    controller.preferredContentSize = CGSize(width: UIScreen.main.bounds.width * 0.8,
                                                             height: UIScreen.main.bounds.height * 0.5)
                    controller.isFullScreenIfMobileNotRegistered = false
                    controller.reloadScreenAfterDismiss = {
                        self.viewDidLoad()
                        self.viewWillAppear(true)
                    }
                    self.present(controller, animated: true)
                }else{
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
                
                self.updateTotalPrice()
            }
            cell.configure(with: rooms)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == hotelImagesCollectionView {
            let totalWidth = collectionView.bounds.width
            return CGSize(width: totalWidth, height: totalWidth * 0.6)
        } else {
            if let room = selectedHotel?.rooms[indexPath.row] {
                let height = calculateRoomCellHeight(for: room)
                return CGSize(width: collectionView.frame.width, height: height)
            } else {
                return CGSize(width: collectionView.frame.width, height: 400)
            }
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

extension HotelDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(selectedHotel?.reviews.count ?? 0, 5)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

extension HotelDetailsViewController : AvailabilityRoomsCVCDelegate, UIViewControllerTransitioningDelegate {
    
    func didTapBookNow(for room: RoomElement, selectedRate: Rate) {
        if let user = UserSessionManager.getUser(){
            let controller = UIStoryboard(name: "Booking", bundle: nil).instantiateViewController(withIdentifier: "ConfirmYourBookingVC") as! ConfirmYourBookingVC
            controller.guestName = user.name
            controller.guestEmail = user.email
            controller.guestMobileNumber = user.mobile
           
            controller.selectedHotel = self.selectedHotel
            controller.selectedRoom = self.selectedRoom
            controller.selectedRate = room.rates
            self.present(controller, animated: true)
        }
    }
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return CenteredPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func showAlertForRateSelection() {
        showAlert("Please select a rate and ensure hotel/room data is present.")
    }
    
//    func updateTotalPrice() {
//        let total = selectedRates.reduce(0) { $0 + (($1.price ?? 0) * Double($1.selectedQuantity ?? 1)) }
//        totalAmountLabel.text = "Total : $\(total)"
//        totalPriceView.isHidden = total == 0
//    }
    
    func updateTotalPrice() {
        let total = selectedRates.reduce(0) {
            $0 + (($1.price ?? 0) * Double($1.selectedQuantity ?? 1))
        }
        // Count distinct room rates selected
        let selectedRoomsCount = selectedRates.filter { ($0.selectedQuantity ?? 0) > 0 }.count
        
        // Total quantity (all selected rooms added together)
        let totalQuantity = selectedRates.reduce(0) { $0 + ($1.selectedQuantity ?? 0) }
        
        if total > 0 {
            totalAmountLabel.text = "\(selectedRoomsCount) Rooms (\(totalQuantity) Qty) - Total: $\(total)"
        } else {
            totalAmountLabel.text = ""
        }
        totalPriceView.isHidden = total == 0
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
        
        scrolltoTopHelper = ScrollToTopHelper(parent: self)
        
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
        averageRatingsLabel.text = "\(hotel.averageRating) (\(hotel.reviewCount) reviews)"
        descriptionLabel.text = hotel.description
        rateAndReviewsLabel.text = "Rate & Reviews \(hotel.averageRating) (\(hotel.reviewCount) reviews)"
        contactTypesLabel.text = "To contact directly \(hotel.name) in case of any enquiry / feedback / complaint,"
        
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
    }
    
    func hideViewAllButton() {
        if selectedHotel?.reviews.count ?? 0 > 5 {
            viewAllButton.isHidden = false
        }else{
            
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
        let baseHeight: CGFloat = 300
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

}

extension HotelDetailsViewController: DetailsPageHotelImagesCVCDelegate {
    func didTapImageFive(in cell: DetailsPageHotelImagesCVC) {
        guard let galleryVC = storyboard?.instantiateViewController(withIdentifier: "HotelImagesGalleryVC") as? HotelImagesGalleryVC else {
            return
        }
        galleryVC.selectedHotel = selectedHotel
        present(galleryVC, animated: true)
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
