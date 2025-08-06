//
//  DetailsBookingsViewController.swift
//  HotelBooking
//
//  Created by praveenkumar on 03/07/25.
//

import UIKit
import Lottie

class DetailsBookingsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var totalAmountCalculateLbl: UILabel!
    @IBOutlet weak var totalDataLbl: UILabel!
    @IBOutlet weak var roomTypeDataLbl: UILabel!
    @IBOutlet weak var countDataLbl: UILabel!
    @IBOutlet weak var princeDataLbl: UILabel!
    @IBOutlet weak var cancellationReasonDataLbl: UILabel!
    @IBOutlet weak var roomNextListTVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var roomNextListTV: UITableView!
    @IBOutlet weak var scrollViewContentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewContentView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var detailsBookingNextCV: UICollectionView!
    @IBOutlet weak var mailToThisEmailLbl: UILabel!
    @IBOutlet weak var callToThisNumberLbl: UILabel!
    @IBOutlet weak var scrollViewScroll: UIScrollView!
    @IBOutlet weak var emailDarkButton: UIButton!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var emailLottieView: UIView!
    @IBOutlet weak var emailLightButton: UIButton!
    @IBOutlet weak var callDarkButton: UIButton!
    @IBOutlet weak var callNowText: UILabel!
    @IBOutlet weak var callLiteButton: UIButton!
    @IBOutlet weak var callLottieView: UIView!
    @IBOutlet weak var emailSupportView: UIView!
    @IBOutlet weak var emailSupportLbl: UILabel!
    @IBOutlet weak var twentyFourHoursView: UIView!
    @IBOutlet weak var twentyFourHousSupportLbl: UILabel!
    @IBOutlet weak var discussChangesLbl: UILabel!
    @IBOutlet weak var contactPropertyLbl: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var roomTypeLbl: UILabel!
    @IBOutlet weak var reasonForCancellationLbl: UILabel!
    @IBOutlet weak var cancellatioLbl: UILabel!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var warningTextLbl: UILabel!
    @IBOutlet weak var yourAccoummodationTitle: UILabel!
    @IBOutlet weak var getDirectionLbl: UILabel!
    @IBOutlet weak var dirtecttionButton: UIButton!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var reviewsCountLbl: UILabel!
    @IBOutlet weak var goodLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var dotLbl: UILabel!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var sandalView: UIView!
    @IBOutlet weak var centreView: UIView!
    
    var currentIndex = 0
    var isGoingForward = true
    var originalCallDarkButtonCenter: CGPoint!
    var originalEmailDarkButtonCenter: CGPoint!
    var hasChangedNavBarColor = false
    let statusBarBackgroundView = UIView()
    var nextRoomData = [
        NextRoomData(
            roomId: "R001",
            roomImage: "1",
            bookingStatus: "Booked",
            roomType: "Deluxe",
            roomBeds: "1 King Bed",
            roomSize: "300 sqft",
            checkIn: "2025-07-10",
            checkOut: "2025-07-12",
            roomPrice: "$100",
            bookingReason: "Family vacation"
        ),
        NextRoomData(
            roomId: "R002",
            roomImage: "2",
            bookingStatus: "Available",
            roomType: "Deluxe",
            roomBeds: "2 Single Beds",
            roomSize: "250 sqft",
            checkIn: "2025-07-15",
            checkOut: "2025-07-17",
            roomPrice: "$70",
            bookingReason: "Weekend city break"
        ),
        NextRoomData(
            roomId: "R003",
            roomImage: "3",
            bookingStatus: "Booked",
            roomType: "Suite",
            roomBeds: "1 Queen Bed",
            roomSize: "400 sqft",
            checkIn: "2025-07-20",
            checkOut: "2025-07-23",
            roomPrice: "$90",
            bookingReason: "Business meeting"
        ),
        NextRoomData(
            roomId: "R004",
            roomImage: "4",
            bookingStatus: "Available",
            roomType: "Executive",
            roomBeds: "1 King Bed + Sofa",
            roomSize: "450 sqft",
            checkIn: "2025-07-25",
            checkOut: "2025-07-27",
            roomPrice: "$80",
            bookingReason: "Anniversary trip"
        ),
        NextRoomData(
            roomId: "R005",
            roomImage: "5",
            bookingStatus: "Booked",
            roomType: "Economy",
            roomBeds: "1 Double Bed",
            roomSize: "200 sqft",
            checkIn: "2025-07-30",
            checkOut: "2025-08-01",
            roomPrice: "$60",
            bookingReason: "Solo travel"
        )
    ]
    var groupedRoomData: [String: [NextRoomData]] = [:]
    var sortedRoomTypes: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextTableProcess()
        setupLottie()
        setupEmailLottie()
        applyCornerRadiusAndBorder()
        scrollViewScroll.delegate  = self
        setUpWindowStatusBar()
        handleGesture()
        adjustButtonSize()
        applyBackViewShadow()
        setupNavigationBarTitle(mainTitle: "My Bookings", subtitle: "4 Jun – 6 Jun")
        applyTextFont()
        roundCornersOfRatingLabelContainer()
        mailToThisEmailLbl.text = "( \("Hotelbooking@gmail.com") )"
        updateTotalAmountLabel()
    }
    
    func applyBackViewShadow(){
        sandalView.BackViewShadow()
        centreView.BackViewShadow()
        cancelView.BackViewShadow()
        detailsBookingNextCV.register(UINib(nibName: "DetailedBookingNextCVC", bundle: nil), forCellWithReuseIdentifier: "DetailedBookingNextCVC")
        roomNextListTV.register(UINib(nibName: "RoomNextListTVC", bundle: nil), forCellReuseIdentifier: "RoomNextListTVC")
    }
    
    func applyTextFont() {
        hotelName.font = UIFont.poppinsBold(16)
        goodLbl.font = UIFont.poppinsMedium(14)
        dotLbl.font = UIFont.poppinsMedium(14)
        reviewsCountLbl.font = UIFont.poppinsMedium(14)
        getDirectionLbl.font = UIFont.poppinsBold(14)
        addressLbl.font = UIFont.poppinsMedium(14)
        locationLbl.font = UIFont.poppinsMedium(14)
        yourAccoummodationTitle.font = UIFont.poppinsMedium(14)
        warningTextLbl.font = UIFont.poppinsMedium(14)
        cancellatioLbl.font = UIFont.poppinsMedium(14)
        roomTypeLbl.font = UIFont.poppinsMedium(14)
        reasonForCancellationLbl.font = UIFont.poppinsMedium(14)
        contactPropertyLbl.font = UIFont.poppinsBold(14)
        discussChangesLbl.font = UIFont.poppinsMedium(12)
        twentyFourHousSupportLbl.font = UIFont.poppinsBold(14)
        emailSupportLbl.font = UIFont.poppinsBold(14)
        callNowText.font = UIFont.poppinsBold(12)
        emailText.font = UIFont.poppinsBold(12)
        callToThisNumberLbl.font = UIFont.poppinsBold(14)
        mailToThisEmailLbl.font = UIFont.poppinsBold(14)
        ratingLbl.font = UIFont.poppinsMedium(14)
        totalAmountCalculateLbl.font = UIFont.poppinsMedium(14)
        totalDataLbl.font = UIFont.poppinsBold(14)
        roomTypeDataLbl.font = UIFont.poppinsBold(14)
        countDataLbl.font = UIFont.poppinsBold(14)
        princeDataLbl.font = UIFont.poppinsBold(14)
        cancellationReasonDataLbl.font = UIFont.poppinsBold(14)
    }
    
    func setupNavigationBarTitle(mainTitle: String, subtitle: String) {
        let titleLabel = UILabel()
        titleLabel.text = mainTitle
        titleLabel.font = UIFont.poppinsBold(16)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.poppinsMedium( 13)
        subtitleLabel.textColor = .white
        subtitleLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        
        navigationItem.titleView = stackView
    }
    
    func applyCornerRadiusAndBorder(){
        emailSupportView.layer.cornerRadius = 30
        twentyFourHoursView.layer.cornerRadius = 30
        nextButton.BackViewShadowAppyManually(cornerRadius: nextButton.frame.size.height / 2)
    }
    
    func nextTableProcess(){
        for room in nextRoomData {
                if groupedRoomData[room.roomType] == nil {
                    groupedRoomData[room.roomType] = [room]
                    sortedRoomTypes.append(room.roomType)
                } else {
                    groupedRoomData[room.roomType]?.append(room)
                }
            }
    }
    
    private func roundCornersOfRatingLabelContainer() {
        let maskPath = UIBezierPath(
            roundedRect: ratingLbl.bounds,
            byRoundingCorners: [.topLeft, .topRight, .bottomRight],
            cornerRadii: CGSize(width: 8, height: 8)
        )
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        ratingLbl.layer.mask = shape
    }
    
    func adjustButtonSize(){
        let darkMail = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let darkMailimage = UIImage(systemName: "envelope.circle.fill", withConfiguration: darkMail)
        emailDarkButton.setImage(darkMailimage, for: .normal)
        
        let lightMail = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let lightMailimage = UIImage(systemName: "envelope.circle", withConfiguration: lightMail)
        emailLightButton.setImage(lightMailimage, for: .normal)
        
        let darkCall = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let darkCallimage = UIImage(systemName: "phone.circle.fill", withConfiguration: darkCall)
        callDarkButton.setImage(darkCallimage, for: .normal)
        
        let lightCall = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let lightCallimage = UIImage(systemName: "phone.circle", withConfiguration: lightCall)
        callLiteButton.setImage(lightCallimage, for: .normal)
    }
    
    func handleGesture(){
        let callPan = UIPanGestureRecognizer(target: self, action: #selector(handleCallPanGesture(_:)))
        callDarkButton.addGestureRecognizer(callPan)
        
        let emailPan = UIPanGestureRecognizer(target: self, action: #selector(handleEmailPanGesture(_:)))
        emailDarkButton.addGestureRecognizer(emailPan)
    }
    
    func setUpWindowStatusBar() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            
            window.subviews.first(where: { $0 === statusBarBackgroundView })?.removeFromSuperview()
            
            let topInset = window.safeAreaInsets.top
            statusBarBackgroundView.frame = CGRect(x: 0, y: 0, width: window.bounds.width, height: topInset)
            statusBarBackgroundView.backgroundColor = .clear
            window.addSubview(statusBarBackgroundView)
        }
    }
    
    private func setupLottie() {
        let animationView = LottieAnimationView(name: "progressright")
        animationView.frame = callLottieView.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        
        let blueColor = UIColor(red: 0/255, green: 59/255, blue: 149/255, alpha: 1)
        let colorProvider = ColorValueProvider(blueColor.lottieColorValue)
        
        animationView.setValueProvider(colorProvider, keypath: AnimationKeypath(keypath: "**.Fill 1.Color"))
        
        animationView.play()
        callLottieView.addSubview(animationView)
    }
    
    private func setupEmailLottie() {
        let animationView = LottieAnimationView(name: "progressright")
        animationView.frame = emailLottieView.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        
        // Set tint color override
        let blueColor = UIColor(red: 0/255, green: 59/255, blue: 149/255, alpha: 1)
        let colorProvider = ColorValueProvider(blueColor.lottieColorValue)
        animationView.setValueProvider(colorProvider, keypath: AnimationKeypath(keypath: "**.Fill 1.Color"))
        
        // Flip horizontally
        animationView.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        animationView.play()
        emailLottieView.addSubview(animationView)
    }
    
    @objc func handleCallPanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let draggedView = gesture.view else { return }
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            // Hide during swipe
            callLottieView.isHidden = true
            callNowText.isHidden = true
            
            var newCenterX = draggedView.center.x + translation.x
            let containerFrame = twentyFourHoursView.frame
            let halfWidth = draggedView.frame.width / 2
            let minX = containerFrame.minX + halfWidth
            let maxX = containerFrame.maxX - halfWidth
            newCenterX = max(minX, min(newCenterX, maxX))
            draggedView.center.x = newCenterX
            gesture.setTranslation(.zero, in: view)
            
        case .ended:
            if callLiteButton.frame.intersects(draggedView.frame) {
                makePhoneCall()
            }
            
            UIView.animate(withDuration: 0.3) {
                draggedView.center = self.originalCallDarkButtonCenter
            } completion: { _ in
                // Show again after swipe ends
                self.callLottieView.isHidden = false
                self.callNowText.isHidden = false
            }
            
        default:
            break
        }
    }
    
    @objc func handleEmailPanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let draggedView = gesture.view else { return }
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            // Hide during swipe
            emailText.isHidden = true
            emailLottieView.isHidden = true
            
            var newCenterX = draggedView.center.x + translation.x
            let containerFrame = emailSupportView.frame
            let halfWidth = draggedView.frame.width / 2
            let minX = containerFrame.minX + halfWidth
            let maxX = containerFrame.maxX - halfWidth
            newCenterX = max(minX, min(newCenterX, maxX))
            draggedView.center.x = newCenterX
            gesture.setTranslation(.zero, in: view)
            
        case .ended:
            if emailLightButton.frame.intersects(draggedView.frame) {
                sendSupportEmail()
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                draggedView.center = self.originalEmailDarkButtonCenter
            }, completion: { _ in
                // Show again after swipe completes
                self.emailText.isHidden = false
                self.emailLottieView.isHidden = false
            })
            
        default:
            break
        }
    }
    
    func adjustHeightsBasedOnRoomData() {
        let sectionCount = sortedRoomTypes.count
        let rowHeight: CGFloat = 50
        let baseScrollHeight: CGFloat = 1350

        let newTableHeight = CGFloat(sectionCount) * rowHeight
        roomNextListTVHeightConstraint.constant = newTableHeight

        let extraRows = max(0, sectionCount - 1)
        let newScrollHeight = baseScrollHeight + (CGFloat(extraRows) * rowHeight)
        scrollViewContentViewHeightConstraint.constant = newScrollHeight

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }


    func sendSupportEmail() {
        let rawText = mailToThisEmailLbl.text ?? ""
        let email = rawText
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let url = URL(string: "mailto:\(email)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    func makePhoneCall() {
        let rawText = callToThisNumberLbl.text ?? ""
        let digitsOnly = rawText
            .components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
        
        if let url = URL(string: "tel://\(digitsOnly)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBarBackgroundView.backgroundColor = .clear
        resetNavAndStatusBarToTransparent()
        hasChangedNavBarColor = false
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusBarBackgroundView.removeFromSuperview()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustHeightsBasedOnRoomData()
        if originalCallDarkButtonCenter == nil {
            originalCallDarkButtonCenter = callDarkButton.center
        }
        
        if originalEmailDarkButtonCenter == nil {
            originalEmailDarkButtonCenter = emailDarkButton.center
        }
    }
    
    // MARK: - Scroll Detection
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navBarFrame = navigationController?.navigationBar.superview?.convert(navigationController!.navigationBar.frame, to: nil) else { return }
        let navBarBottom = navBarFrame.maxY
        let centreViewFrameInWindow = centreView.convert(centreView.bounds, to: nil)
        
        if centreViewFrameInWindow.minY <= navBarBottom {
            if !hasChangedNavBarColor {
                applyDefaultColorToNavAndStatusBar()
                hasChangedNavBarColor = true
            }
        } else {
            if hasChangedNavBarColor {
                resetNavAndStatusBarToTransparent()
                hasChangedNavBarColor = false
            }
        }
    }
    
    // MARK: - Navigation Bar Color Control
    
    func applyDefaultColorToNavAndStatusBar() {
        if let color = UIColor(named: "defaultColor") {
            navigationController?.navigationBar.barTintColor = color
            navigationController?.navigationBar.backgroundColor = color
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.tintColor = .white
            statusBarBackgroundView.backgroundColor = color
        }
    }
    
    func resetNavAndStatusBarToTransparent() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        statusBarBackgroundView.backgroundColor = .clear
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkScrollAndUpdateNavBar()
    }
    
    func checkScrollAndUpdateNavBar() {
        guard let navBarFrame = navigationController?.navigationBar.superview?.convert(navigationController!.navigationBar.frame, to: nil) else { return }
        let navBarBottom = navBarFrame.maxY
        let centreViewFrameInWindow = centreView.convert(centreView.bounds, to: nil)
        
        if centreViewFrameInWindow.minY <= navBarBottom {
            applyDefaultColorToNavAndStatusBar()
            hasChangedNavBarColor = true
        } else {
            resetNavAndStatusBarToTransparent()
            hasChangedNavBarColor = false
        }
    }
    
    @IBAction func callLightButton(_ sender: Any) {
    }
    
    @IBAction func callDarkLight(_ sender: Any) {
    }
    
    @IBAction func directionButton(_ sender: Any) {
    }
    
    @IBAction func emailLightButton(_ sender: Any) {
    }
    
    @IBAction func emailDarkButton(_ sender: Any) {
    }
    
    @IBAction func nextButton(_ sender: Any) {
        if isGoingForward {
            if currentIndex < nextRoomData.count - 1 {
                currentIndex += 1
            }
            
            if currentIndex == nextRoomData.count - 1 {
                isGoingForward = false
            }
        } else {
            if currentIndex > 0 {
                currentIndex -= 1
            }
            
            if currentIndex == 0 {
                isGoingForward = true
            }
        }
        
        let indexPath = IndexPath(item: currentIndex, section: 0)
        detailsBookingNextCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        updateNextButtonImage()
    }
    
    func updateTotalAmountLabel() {
        let total = nextRoomData.reduce(0) { sum, room in
            let priceString = room.roomPrice.replacingOccurrences(of: "$", with: "")
            return sum + (Int(priceString) ?? 0)
        }
        totalAmountCalculateLbl.text = "$\(total)"
    }

    func updateNextButtonImage() {
        if isGoingForward {
            nextButton.setImage(UIImage(named: "chevron.right"), for: .normal)
        } else {
            nextButton.setImage(UIImage(named: "chevron.left"), for: .normal)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        currentIndex = Int(scrollView.contentOffset.x / pageWidth)

        if currentIndex == nextRoomData.count - 1 {
            isGoingForward = false
        } else if currentIndex == 0 {
            isGoingForward = true
        }

        updateNextButtonImage()
    }

}


extension DetailsBookingsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DetailedBookingNextCVCDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height =  detailsBookingNextCV.frame.size.height
        let width =  detailsBookingNextCV.frame.size.width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nextRoomData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailedBookingNextCVC", for: indexPath)as! DetailedBookingNextCVC
        let data = nextRoomData[indexPath.row]
        cell.bookingIdLvl.text = "ID: \(data.roomId)"
        cell.cancelledBgLbl.text = data.bookingStatus
        cell.checkInDate.text = data.checkIn
        cell.checkOutDate.text = data.checkOut
        cell.deluxeRoomLbl.text = data.roomType
        cell.howManyBedsLbl.text = data.roomBeds
        cell.sizeLblMeter.text = data.roomSize
        cell.hotelImage.image = UIImage(named: data.roomImage)
        cell.delegate = self
         return cell
    }
    func didTapCopyButton(with text: String) {
            UIPasteboard.general.string = text

            let alert = UIAlertController(title: nil, message: "Booking ID copied!", preferredStyle: .alert)
            self.present(alert, animated: true)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
}


extension DetailsBookingsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedRoomTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomNextListTVC") as! RoomNextListTVC
        
        let roomType = sortedRoomTypes[indexPath.section]
            if let roomList = groupedRoomData[roomType] {
                let count = roomList.count
                let firstRoom = roomList.first!

                let totalPrice = roomList.reduce(0) { sum, roomData in
                    let priceString = roomData.roomPrice.replacingOccurrences(of: "$", with: "")
                    return sum + (Int(priceString) ?? 0)
                }
                
                cell.roomType.text = roomType
                cell.roomCount.text = String(count)
                cell.roomPrice.text = "$\(totalPrice)"
                cell.reasonLbl.text = count == 1 ? firstRoom.bookingReason : "Multiple bookings"
            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
