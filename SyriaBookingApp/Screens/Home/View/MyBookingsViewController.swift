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
    
    let viewModel = HotelViewModel()
    var selectedSegmentIndex: Int = 0
    var selectedHotel: Hotel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserSessionManager.getUser() == nil {
            // Automatically show login form when opening bookings
            DispatchQueue.main.async {
                self.presentLoginForm(isFullScreen: true)
            }
        }
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        if selectedSegmentIndex == 0 {
            viewModel.filteredBookings = [
                Booking(id: "1", hotelName: "Dar Al Noor", roomType: "Single Room", checkIn: "2025-09-05", checkOut: "2025-09-10", totalAmount: 300, status: "cancelled"),
                Booking(id: "2", hotelName: "Dar Al Noor", roomType: "Single Room", checkIn: "2025-09-05", checkOut: "2025-09-10", totalAmount: 350, status: "pending"),
                Booking(id: "3", hotelName: "Louis Inn Hotel", roomType: "Double Room", checkIn: "2025-09-05", checkOut: "2025-09-07", totalAmount: 280, status: "cancelled"),
                Booking(id: "4", hotelName: "Sea View", roomType: "Single Room", checkIn: "2025-10-01", checkOut: "2025-10-05", totalAmount: 40, status: "cancelled")
            ]
        } else {
            viewModel.filteredBookings = [
                Booking(id: "1", hotelName: "Dar Al Noor", roomType: "Single Room", checkIn: "2025-09-05", checkOut: "2025-09-10", totalAmount: 300, status: "cancelled"),
                Booking(id: "2", hotelName: "Dar Al Noor", roomType: "Single Room", checkIn: "2025-09-05", checkOut: "2025-09-10", totalAmount: 350, status: "confirmed"), // changed
                Booking(id: "3", hotelName: "Louis Inn Hotel", roomType: "Double Room", checkIn: "2025-09-05", checkOut: "2025-09-07", totalAmount: 280, status: "cancelled"),
                Booking(id: "4", hotelName: "Sea View", roomType: "Single Room", checkIn: "2025-10-01", checkOut: "2025-10-05", totalAmount: 40, status: "cancelled")
            ]
        }
        HistoryTableView.reloadData()
    }
    
}

extension MyBookingsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(5, viewModel.filteredBookings.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingTableViewCell", for: indexPath) as! MyBookingTableViewCell
        let hotel = viewModel.filteredBookings[indexPath.row]
        cell.configure(booking: hotel)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 250 : 152
    }
}

extension MyBookingsViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,presenting: UIViewController?,source: UIViewController) -> UIPresentationController? {
        return CenteredPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func setupUI() {
        
        if UserSessionManager.getUser() != nil {
            viewModel.filteredBookings = [
                Booking(id: "1", hotelName: "Dar Al Noor", roomType: "Single Room", checkIn: "2025-09-05", checkOut: "2025-09-10", totalAmount: 300, status: "cancelled"),
                Booking(id: "2", hotelName: "Dar Al Noor", roomType: "Single Room", checkIn: "2025-09-05", checkOut: "2025-09-10", totalAmount: 350, status: "pending"),
                Booking(id: "3", hotelName: "Louis Inn Hotel", roomType: "Double Room", checkIn: "2025-09-05", checkOut: "2025-09-07", totalAmount: 280, status: "cancelled"),
                Booking(id: "4", hotelName: "Sea View", roomType: "Single Room", checkIn: "2025-10-01", checkOut: "2025-10-05", totalAmount: 40, status: "cancelled")
            ]
            // ✅ Logged in → show booking table
            HistoryTableView.register(
                UINib(nibName: "MyBookingTableViewCell", bundle: nil),
                forCellReuseIdentifier: "MyBookingTableViewCell"
            )
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
            viewModel.filteredHotels = HotelDataMaganer.shared.allHotels
            viewModel.filteredHotelsCopy = viewModel.filteredHotels
            
            DispatchQueue.main.async {
                self.HistoryTableView.reloadData()
            }
            messageLabel.isHidden = true
            segmentControl.isHidden = false
        } else {
            // ❌ Not logged in → show message, hide booking table
            messageLabel.isHidden = false
            segmentControl.isHidden = true
        }
        navigationController?.setNavigationBarBlack()
    }
    
    func presentLoginForm(isFullScreen: Bool) {
        print("Login tapped from gesture...")

        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "RegisterMobileNumberVC") as? RegisterMobileNumberVC else {
            print("Failed to load RegisterMobileNumberVC")
            return
        }
//        controller.dismissButton.isEnabled = false
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        controller.preferredContentSize = CGSize(
            width: UIScreen.main.bounds.width * 0.8,
            height: UIScreen.main.bounds.height * 0.5
        )
        controller.isFullScreenIfMobileNotRegistered = isFullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
}

extension MyBookingsViewController: MyBookingCellDelegate {
    func didTapDetails(for booking: Booking) {
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "ViewBookingConfirmationVC") as? ViewBookingConfirmationVC {
            detailsVC.status = booking.status
            detailsVC.guestName = "John Doe"
            detailsVC.guestEmail = "john@example.com"
            detailsVC.guestPhone = "+91 9876543210"
            detailsVC.numberOfGuests = "2"
            detailsVC.roomType = booking.roomType
            detailsVC.checkInDate = booking.checkIn
            detailsVC.checkOutDate = booking.checkOut
            detailsVC.totalPrice = "$\(booking.totalAmount)"
            detailsVC.modalPresentationStyle = .fullScreen
            present(detailsVC, animated: true)
        }
    }
}
