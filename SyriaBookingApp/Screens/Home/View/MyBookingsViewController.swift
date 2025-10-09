//
//  MyBookingsViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 01/08/25.
//

import UIKit

class MyBookingsViewController: UIViewController {
    
    @IBOutlet weak var HistoryTableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var myBookigsTitleLabel: UILabel!
    @IBOutlet weak var myBookingsDescriptionLabel: UILabel!    
    @IBOutlet weak var noBookingsLabel: UILabel!
    
    let viewModel = NotificationViewModel()
    let bookingViewModel = BookingViewModel()
    var selectedSegmentIndex: Int = 0
    //    var selectedHotel: Hotel?
    var isLoginPopupPresented = false
    var comingFrom : String?
    
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
//    var selectedRate = [Rate]()
    var selectedRates: [Rate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        setupAppNavigationBar()
        setupLanguage()
        segmentControl.selectedSegmentIndex = 0
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        configureSelectedSegment(completion:{
            self.HistoryTableView.reloadData()
        })
        
    }
    
    func configureSelectedSegment(completion: @escaping ()->Void){
       if selectedSegmentIndex == 0 {
           // UPCOMING: today or future dates
           viewModel.filteredHistoryArray = viewModel.BookingHistoryArray.filter { data in
               if let date = data.checkInUtc.toDate() {
                   return date >= Calendar.current.startOfDay(for: Date()) // today & future
               }
               return false
           }
       } else {
           // PAST: before today
           viewModel.filteredHistoryArray = viewModel.BookingHistoryArray.filter { data in
               if let date = data.checkInUtc.toDate() {
                   return date < Calendar.current.startOfDay(for: Date()) // strictly past
               }
               return false
           }
       }
        if viewModel.filteredHistoryArray.isEmpty {
            noBookingsLabel.isHidden = false
            noBookingsLabel.applyCardStyle()
            HistoryTableView.isHidden = true
        } else {
            noBookingsLabel.isHidden = true
            HistoryTableView.isHidden = false
        }
       completion()
        
    }
}

extension MyBookingsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.filteredHistoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let booking = viewModel.filteredHistoryArray[indexPath.row]
        
        if selectedSegmentIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArchiveTableViewCell", for: indexPath) as! ArchiveTableViewCell
            cell.configure(booking: booking)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingTableViewCell", for: indexPath) as! MyBookingTableViewCell
            cell.configure(booking: booking)
            cell.contactSupprtButtonAction = { booking in
                if let contactVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ReportAnAppVC") as? ReportAnAppVC {
                    contactVC.comingfrom = .BookingHistory
                    contactVC.hotelID = booking.hotelId
                    contactVC.hotelName = booking.hotelName
                    contactVC.BookingID = booking.id
                    self.showPopup(contactVC, widthMultiplier: 0.85, heightMultiplier: 0.85)
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
            return UIDevice.current.userInterfaceIdiom == .pad ? 180 : 152
        }
    }
    
}

extension MyBookingsViewController: UIViewControllerTransitioningDelegate {
    func setupUI() {
        navigationController?.setNavigationBarBlack()

        if let  user = UserSessionManager.getUser() {
            self.showLoader()
            viewModel.onSuccess = { response in
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.selectedSegmentIndex = 0
                    self.configureSelectedSegment(completion:{
                        self.HistoryTableView.reloadData()
                    })
                }
            }
            
            viewModel.onError = { error in
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.showAlert(error)
                }
            }

            viewModel.fetchNotificationUser(userId: user.id,includePast: true)
            
            messageLabel.isHidden = true
            segmentControl.isHidden = false
            HistoryTableView.isHidden = false
            myBookigsTitleLabel.isHidden = false
            myBookingsDescriptionLabel.isHidden = false
            HistoryTableView.register(
                UINib(nibName: "MyBookingTableViewCell", bundle: nil),
                forCellReuseIdentifier: "MyBookingTableViewCell"
            )
            HistoryTableView.register(UINib(nibName: "ArchiveTableViewCell", bundle: nil), forCellReuseIdentifier: "ArchiveTableViewCell")
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
            segmentControl.addBottomShadow()
            
            
            //            isLoginPopupPresented = false
            DispatchQueue.main.async {
                self.selectedSegmentIndex = 0
                self.HistoryTableView.reloadData()
            }
        } else {
            
            segmentControl.isHidden = true
            HistoryTableView.isHidden = true
            myBookigsTitleLabel.isHidden = true
            myBookingsDescriptionLabel.isHidden = true
            messageLabel.isHidden = false
            
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Booking", bundle: nil)
                guard let controller = storyboard.instantiateViewController(withIdentifier: "RegisterMobileNumberVC") as? RegisterMobileNumberVC else {
                    print("Failed to load RegisterMobileNumberVC")
                    return
                }
                //                controller.
                controller.comingFrom = .tabbarBooking
                controller.reloadScreenAfterDismiss = {
                    DispatchQueue.main.async{
                        self.setupUI()
                    }
                }
                self.showPopup(controller,widthMultiplier: 0.9, heightMultiplier: 0.3)
            }
        }
    }
}

extension MyBookingsViewController: MyBookingCellDelegate, CancelBookingDelegate {
    
    
    func didTapDetails(for booking: BookingHistoryModel) {
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

    func didTapCancel(for booking: BookingHistoryModel) {
        if let cancelVC = storyboard?.instantiateViewController(withIdentifier: "CancelBookingVC") as? CancelBookingVC {
            cancelVC.modalPresentationStyle = .overFullScreen
            cancelVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            cancelVC.booking = booking
            cancelVC.delegate = self
            present(cancelVC, animated: true)
        }
    }
    
    func didConfirmCancellation(for booking: BookingHistoryModel, reason: String) {
        guard let user = UserSessionManager.getUser() else { return }
        bookingViewModel.onError = { error in
            self.hideLoader()
            self.showAlert(error)
        }
        
        showLoader()
        
        bookingViewModel.postCancelBooking(reason: reason, userId: user.id, bookingId: booking.id) { data in
            guard let data = data else {
                self.hideLoader()
                return
            }
            
            self.showAlert(title: "Success", message: data.message, onCancel: {
                self.hideLoader()
                if let index = self.viewModel.filteredHistoryArray.firstIndex(where: { $0.id == data.data.id }) {
                    self.viewModel.filteredHistoryArray[index].status = "cancelled"
                    self.HistoryTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
                
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            })
        }
    }

}

extension String {
    func toDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime] // only internet date time
        if let date = formatter.date(from: self) {
            return date
        }

        // Try with fractional seconds as a fallback
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: self)
    }
}
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

