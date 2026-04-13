//
//  MyBookingsViewController.swift
//  SyriaBookingApp
//  Created by ToqSoft on 01/08/25.

import UIKit
import SkeletonView

class MyBookingsViewController: BaseViewController {
    
    @IBOutlet weak var HistoryTableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var myBookigsTitleLabel: UILabel!
    @IBOutlet weak var myBookingsDescriptionLabel: UILabel!
    @IBOutlet weak var noBookingsLabel: UILabel!
    
    let viewModel = NotificationViewModel()
    let bookingViewModel = BookingViewModel()
    let hotelViewModel = HotelViewModel()
    var selectedSegmentIndex: Int = 0
    var isLoginPopupPresented = false
    var comingFrom : String?
                                       
    // Skeleton state management - UPDATED
    private var isShowingSkeleton = false
    private var minimumSkeletonTime: TimeInterval = 2.0 // Minimum 2 seconds
    private var skeletonStartTime: Date?
    private var skeletonHideWorkItem: DispatchWorkItem?
    
    var guestName: String?
    var guestEmail: String?
    var guestPhone: String?
    var checkInDate: String?
    var checkOutDate: String?
    var numberOfGuests: String?
    var totalPrice: String?
    var roomType: String?
    
    var selectedHotel: Hotel?
    var selectedRoom: RoomElement?
    var selectedRates: [Rate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSkeleton()
        setupTableView()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
        setupLanguage()
        
        // Reset to "Upcoming" tab every time user visits MyBookings
        segmentControl.selectedSegmentIndex = 0
        
        // Refresh UI + fetch bookings
        refreshBookingData()
    }
    
    private func setupTableView() {
        HistoryTableView.delegate = self
        HistoryTableView.dataSource = self
        
        HistoryTableView.register(
            UINib(nibName: "UpcomingBookingTVC", bundle: nil),
            forCellReuseIdentifier: "UpcomingBookingTVC"
        )
        
        HistoryTableView.register(
            UINib(nibName: "ArchiveTableViewCell", bundle: nil),
            forCellReuseIdentifier: "ArchiveTableViewCell"
        )
        
        HistoryTableView.rowHeight = UITableView.automaticDimension
        HistoryTableView.estimatedRowHeight = 150
    }
    
    private func setupSkeleton() {
        // Configure skeleton appearance for all elements
        view.isSkeletonable = true
        
        HistoryTableView.isSkeletonable = true
        myBookigsTitleLabel.isSkeletonable = true
        myBookingsDescriptionLabel.isSkeletonable = true
        segmentControl.isSkeletonable = true
        noBookingsLabel.isSkeletonable = true
        
        // Skeleton configuration for labels
        myBookigsTitleLabel.skeletonTextLineHeight = .relativeToFont
        myBookigsTitleLabel.lastLineFillPercent = 100
        myBookigsTitleLabel.linesCornerRadius = 4
        
        myBookingsDescriptionLabel.skeletonTextLineHeight = .relativeToFont
        myBookingsDescriptionLabel.lastLineFillPercent = 70
        myBookingsDescriptionLabel.linesCornerRadius = 4
        
        noBookingsLabel.skeletonTextLineHeight = .relativeToFont
        noBookingsLabel.lastLineFillPercent = 100
        noBookingsLabel.linesCornerRadius = 4
        
        // Table view skeleton configuration
        HistoryTableView.skeletonCornerRadius = 8
    }
    
    private func showSkeleton() {
        guard !isShowingSkeleton else { return }
        
        // Cancel any pending hide operations
        skeletonHideWorkItem?.cancel()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isShowingSkeleton = true
            self.skeletonStartTime = Date()
            
            // Hide actual content first
            self.noBookingsLabel.isHidden = true
            self.HistoryTableView.isHidden = false // Always show table view for skeleton cells
            
            // Show skeleton on labels
            self.myBookigsTitleLabel.showAnimatedGradientSkeleton()
            self.myBookingsDescriptionLabel.showAnimatedGradientSkeleton()
            
            // Hide segment control text during skeleton by making it transparent
            self.hideSegmentControlText()
            
            // Configure and show table view skeleton
            self.HistoryTableView.isSkeletonable = true
            self.HistoryTableView.showAnimatedGradientSkeleton()
            
            self.HistoryTableView.alpha = 1.0
        }
    }
    
    private func hideSegmentControlText() {
        // Store original titles
        let upcomingTitle = segmentControl.titleForSegment(at: 0) ?? ""
        let archiveTitle = segmentControl.titleForSegment(at: 1) ?? ""
        
        // Set empty titles during skeleton
        segmentControl.setTitle("", forSegmentAt: 0)
        segmentControl.setTitle("", forSegmentAt: 1)
        
        // Show skeleton on segment control
        segmentControl.showAnimatedGradientSkeleton()
        
        // Restore titles after skeleton (stored for later use)
        DispatchQueue.main.asyncAfter(deadline: .now() + minimumSkeletonTime) {
            if self.isShowingSkeleton {
                self.segmentControl.setTitle(upcomingTitle, forSegmentAt: 0)
                self.segmentControl.setTitle(archiveTitle, forSegmentAt: 1)
            }
        }
    }
    
    private func restoreSegmentControlText() {
        let isArabic = AppSettings.shared.selectedLanguage == .arabic
        let upcomingTitle = isArabic ? "القادمة" : "Upcoming"
        let archiveTitle = isArabic ? "الأرشيف" : "Archive"
        
        segmentControl.setTitle(upcomingTitle, forSegmentAt: 0)
        segmentControl.setTitle(archiveTitle, forSegmentAt: 1)
    }
    
    private func hideSkeleton() {
        // Cancel any pending hide operations
        skeletonHideWorkItem?.cancel()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let elapsedTime = self.skeletonStartTime.map { Date().timeIntervalSince($0) } ?? 0
            let remainingTime = max(0, self.minimumSkeletonTime - elapsedTime)
            
            if remainingTime > 0 {
                // Schedule hiding after minimum time
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
        
        // Hide skeleton from all elements
        self.myBookigsTitleLabel.hideSkeleton()
        self.myBookingsDescriptionLabel.hideSkeleton()
        self.segmentControl.hideSkeleton()
        self.HistoryTableView.hideSkeleton()
        
        // Restore segment control text
        self.restoreSegmentControlText()
        
        // Ensure table view is properly configured after skeleton
        self.HistoryTableView.reloadData()
    }
    
    private func refreshBookingData() {
        guard presentedViewController == nil else { return }
        
        if let user = UserSessionManager.getUser() {
            showSkeleton() // Show skeleton before API call
            
            viewModel.onSuccess = { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                     
                    self.hideSkeleton() // Hide skeleton when data is ready
                    self.configureSelectedSegment {
                        self.updateUIAfterDataLoad()
                    }
                }
            }
            
            viewModel.onError = { [weak self] error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                     
                    self.hideSkeleton() // Hide skeleton on error
                    self.showAlert(error.userMessage)
                }
            }
            
            // Add delay to ensure skeleton is visible
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.viewModel.fetchNotificationUser(userId: user.id, includePast: true)
            }
            
        } else {
            hideSkeleton()
            setupUI()
        }
    }
    
    private func updateUIAfterDataLoad() {
        // This is called after skeleton is hidden and data is loaded
        if self.viewModel.filteredHistoryArray.isEmpty {
            self.noBookingsLabel.isHidden = false
            self.noBookingsLabel.applyCardStyle()
            self.HistoryTableView.isHidden = true
        } else {
            self.noBookingsLabel.isHidden = true
            self.HistoryTableView.isHidden = false
        }
        self.HistoryTableView.reloadData()
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        
        // Show skeleton when switching segments
        showSkeletonForSegmentSwitch()
        
        configureSelectedSegment {
            // Schedule skeleton hide after minimum time
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.hideSkeleton()
                self.updateUIAfterDataLoad()
            }
        }
    }
    
    private func showSkeletonForSegmentSwitch() {
        // Cancel any pending hide operations
        skeletonHideWorkItem?.cancel()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isShowingSkeleton = true
            self.skeletonStartTime = Date()
            
            // Hide content and show skeleton
            self.noBookingsLabel.isHidden = true
            self.HistoryTableView.isHidden = false
            
            // Hide segment control text during switch
            self.hideSegmentControlText()
            
            self.HistoryTableView.showAnimatedGradientSkeleton()
            self.HistoryTableView.alpha = 1.0
        }
    }
    
    func configureSelectedSegment(completion: @escaping ()->Void) {
        if selectedSegmentIndex == 0 {
            viewModel.filteredHistoryArray = viewModel.BookingHistoryArray.filter { data in
                if let date = data.checkInUtc.toDate() {
                    return date >= Calendar.current.startOfDay(for: Date())
                }
                return false
            }
        } else {
            viewModel.filteredHistoryArray = viewModel.BookingHistoryArray.filter { data in
                if let date = data.checkInUtc.toDate() {
                    return date < Calendar.current.startOfDay(for: Date())
                }
                return false
            }
        }
        
        DispatchQueue.main.async {
            completion()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MyBookingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredHistoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let booking = viewModel.filteredHistoryArray[indexPath.row]
        
        if selectedSegmentIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArchiveTableViewCell", for: indexPath) as! ArchiveTableViewCell
            cell.configure(booking: booking)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingBookingTVC", for: indexPath) as! UpcomingBookingTVC
            cell.configure(booking: booking)
            cell.contactSupprtButtonAction = { booking in
                if let contactVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ReportAnAppVC") as? ReportAnAppVC {
                    contactVC.comingfrom = .BookingHistory
                    contactVC.hotelID = booking.hotelId
                    contactVC.hotelName = booking.hotelName
                    contactVC.BookingID = booking.id
                    contactVC.modalPresentationStyle = .fullScreen
                    self.present(contactVC, animated: true)
                }
            }
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let booking = viewModel.filteredHistoryArray[indexPath.row]
        guard let viewBookingConfirmationVC = UIStoryboard(name: "Booking", bundle: nil).instantiateViewController(withIdentifier: "ViewBookingConfirmationVC") as? ViewBookingConfirmationVC else {
            return
        }
        viewBookingConfirmationVC.isFromMyBookings = true
        viewBookingConfirmationVC.hotelID = booking.hotelId
        viewBookingConfirmationVC.bookingId = booking.id
        viewBookingConfirmationVC.roomType = booking.roomType
        viewBookingConfirmationVC.modalPresentationStyle = .fullScreen
        present(viewBookingConfirmationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedSegmentIndex == 1 {
            return UIDevice.current.userInterfaceIdiom == .pad ? 130 : 110
        } else {
            return UIDevice.current.userInterfaceIdiom == .pad ? 339 : 339
        }
    }
}

// MARK: - SkeletonTableViewDataSource
extension MyBookingsViewController: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return selectedSegmentIndex == 1 ? "ArchiveTableViewCell" : "UpcomingBookingTVC"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        let identifier = selectedSegmentIndex == 1 ? "ArchiveTableViewCell" : "UpcomingBookingTVC"
        
        if selectedSegmentIndex == 1 {
            let cell = skeletonView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ArchiveTableViewCell
            cell.showSkeleton()
            return cell
        } else {
            let cell = skeletonView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! UpcomingBookingTVC
            cell.showSkeleton()
            return cell
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, prepareCellForSkeleton cell: UITableViewCell, at indexPath: IndexPath) {
        if let archiveCell = cell as? ArchiveTableViewCell {
            archiveCell.showSkeleton()
        } else if let bookingCell = cell as? UpcomingBookingTVC {
            bookingCell.showSkeleton()
        }
    }
}

// MARK: - UI Setup
extension MyBookingsViewController {
    func setupUI() {
        navigationController?.setNavigationBarBlack()
        
        if let user = UserSessionManager.getUser() {
            // Show skeleton immediately
            showSkeleton()
            
            viewModel.onSuccess = { [weak self] response in
                guard let self = self else { return }
                DispatchQueue.main.async {
                     
                    self.hideSkeleton()
                    self.selectedSegmentIndex = 0
                    self.configureSelectedSegment {
                        self.updateUIAfterDataLoad()
                    }
                }
            }
            
            viewModel.onError = { [weak self] error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                     
                    self.hideSkeleton()
                    self.showAlert(error.userMessage)
                }
            }
            
            // Add delay to ensure skeleton is visible
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.viewModel.fetchNotificationUser(userId: user.id, includePast: true)
            }
            
            messageLabel.isHidden = true
            segmentControl.isHidden = false
            HistoryTableView.isHidden = false
            myBookigsTitleLabel.isHidden = false
            myBookingsDescriptionLabel.isHidden = false
            
            let selectedTextAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white
            ]
            let normalAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black
            ]
            
            segmentControl.setTitleTextAttributes(normalAttributes, for: .normal)
            segmentControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
            segmentControl.layer.backgroundColor = UIColor.white.cgColor
            segmentControl.selectedSegmentTintColor = UIColor.black
        } else {
            hideSkeleton()
            segmentControl.isHidden = true
            HistoryTableView.isHidden = true
            myBookigsTitleLabel.isHidden = true
            myBookingsDescriptionLabel.isHidden = true
            messageLabel.isHidden = false
            
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Booking", bundle: nil)
                guard let controller = storyboard.instantiateViewController(withIdentifier: "RegisterMobileNumberVC") as? RegisterMobileNumberVC else {
                    return
                }
                controller.modalPresentationStyle = .overFullScreen
                controller.comingFrom = .tabbarBooking
                controller.reloadScreenAfterDismiss = {
                    DispatchQueue.main.async{
                        self.setupUI()
                    }
                }
                self.present(controller, animated: true)
            }
        }
    }
}

// MARK: - MyBookingCellDelegate, CancelBookingDelegate
extension MyBookingsViewController: MyBookingCellDelegate, CancelBookingDelegate {
    
    func didTapDetails(for booking: BookingHistoryModel) {
        guard let viewBookingConfirmationVC = UIStoryboard(name: "Booking", bundle: nil)
            .instantiateViewController(withIdentifier: "ViewBookingConfirmationVC") as? ViewBookingConfirmationVC else {
            return
        }
        
        viewBookingConfirmationVC.isFromMyBookings = true
        viewBookingConfirmationVC.hotelID = booking.hotelId
        viewBookingConfirmationVC.bookingId = booking.id
        viewBookingConfirmationVC.roomType = booking.roomType
        viewBookingConfirmationVC.modalPresentationStyle = .fullScreen
        present(viewBookingConfirmationVC, animated: true)
    }
    
    func didTapCancel(for booking: BookingHistoryModel) {
        if let cancelVC = storyboard?.instantiateViewController(withIdentifier: "CancelBookingViewController") as? CancelBookingViewController {
            cancelVC.modalPresentationStyle = .overFullScreen
            cancelVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            cancelVC.booking = booking
            cancelVC.delegate = self
            present(cancelVC, animated: true)
        }
    }
    
    func didConfirmCancellation(for booking: BookingHistoryModel, reason: String) {
        guard let user = UserSessionManager.getUser() else { return }
        
        bookingViewModel.onError = { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                 
                self.showAlert(error.userMessage)
            }
        }

        bookingViewModel.postCancelBooking(reason: reason, userId: user.id, bookingId: booking.id) { [weak self] data in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let data = data else { return }
                self.presentedViewController?.dismiss(animated: true) {
                    self.showAlert(title: "Success", message: data.message, onOK: {
                        self.fetchUpdatedBookings()
                    })
                }
            }
        }
    }
    
    private func fetchUpdatedBookings() {
        guard let user = UserSessionManager.getUser() else { return }
        showSkeleton()
        viewModel.onSuccess = { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hideSkeleton()
                self.configureSelectedSegment {
                    self.updateUIAfterDataLoad()
                }
            }
        }
        
        viewModel.onError = { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hideSkeleton()
                self.showAlert(error.userMessage)
            }
        }
        viewModel.fetchNotificationUser(userId: user.id, includePast: true)
    }
}

// MARK: - Language Setup
extension MyBookingsViewController {
    func setupLanguage() {
        let isArabic = AppSettings.shared.selectedLanguage == .arabic
        myBookigsTitleLabel.text = isArabic ? "حجوزاتي" : "My Bookings"
        myBookingsDescriptionLabel.text = isArabic ? "راجع إقاماتك القادمة والحجوزات المؤرشفة" : "Review your upcoming stays and archived bookings"
        noBookingsLabel.text = isArabic ? "لا توجد حجوزات" : "No Bookings Found"
        messageLabel.text = isArabic ? "يرجى تسجيل الدخول لعرض سجل الحجوزات الخاصة بك" : "Please Login to view your booking history"
        segmentControl.setTitle(isArabic ? "القادمة" : "Upcoming", forSegmentAt: 0)
        segmentControl.setTitle(isArabic ? "الأرشيف" : "Archive", forSegmentAt: 1)
        myBookigsTitleLabel.textAlignment = isArabic ? .center : .center
        myBookingsDescriptionLabel.textAlignment = isArabic ? .center : .center
        noBookingsLabel.textAlignment = isArabic ? .center : .center
        messageLabel.textAlignment = isArabic ? .center : .center
        segmentControl.semanticContentAttribute = isArabic ? .forceLeftToRight : .forceLeftToRight
    }
}

// MARK: - String Extension for Date Conversion
extension String {
    func toDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        if let date = formatter.date(from: self) {
            return date
        }        
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: self)
    }
}
