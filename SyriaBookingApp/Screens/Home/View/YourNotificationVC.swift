//
//  YourNotificationVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 09/07/25.
//

/*
import UIKit

class YourNotificationVC: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var yourNotificationTV: UITableView!
    @IBOutlet weak var viewAllButton: UIButton!
    
    let viewModel = HotelViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.filteredBookings = [
            Booking(id: "1", hotelName: "Dar Al Noor", roomType: "Single Room", checkIn: "05 Sep 2025", checkOut: "10 Sep 2025", totalAmount: 300, status: "cancelled"),
            Booking(id: "2", hotelName: "Dar Al Noor", roomType: "Single Room", checkIn: "05 Sep 2025", checkOut: "10 Sep 2025", totalAmount: 350, status: "pending"),
            Booking(id: "3", hotelName: "Louis Inn Hotel", roomType: "Double Room", checkIn: "05 Sep 2025", checkOut: "07 Sep 2025", totalAmount: 280, status: "cancelled"),
            Booking(id: "4", hotelName: "Sea View", roomType: "Single Room", checkIn: "01 Oct 2025", checkOut: "05 Oct 2025", totalAmount: 40, status: "cancelled")
        ]
        UserDefaults.standard.set(true, forKey: "hasViewedNotifications")
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        yourNotificationTV.register(UINib(nibName: "YourNotificationTVC", bundle: nil), forCellReuseIdentifier: "YourNotificationTVC")
        yourNotificationTV.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, !backView.frame.contains(touch.location(in: view)) {
            dismiss(animated: true)
            UIViewController.notificationVCReference = nil
        }
    }
    
    @IBAction func viewAllButtonAction(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Home", bundle: nil)
//        if let myBookingsVC = storyboard.instantiateViewController(withIdentifier: "MyBookingsViewController") as? MyBookingsViewController {
//
//            if let navController = self.navigationController {
//                navController.pushViewController(myBookingsVC, animated: true)
//                if let index = navController.viewControllers.firstIndex(of: self) {
//                    var vcs = navController.viewControllers
//                    vcs.remove(at: index)
//                    navController.viewControllers = vcs
//                }
//            } else {
//                self.present(myBookingsVC, animated: true) {
//                    self.dismiss(animated: false, completion: nil)
//                }
//            }
//        }
        if let presentingVC = self.presentingViewController as? UITabBarController {
            presentingVC.selectedIndex = 1
            self.dismiss(animated: true)
        } else if let nav = self.presentingViewController as? UINavigationController,
                  let tabBarController = nav.tabBarController {
            tabBarController.selectedIndex = 1
            self.dismiss(animated: true)
        } else {
            self.dismiss(animated: true)
            print("Couldn't find tab bar controller from presenting VC")
        }
    }
}

extension YourNotificationVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(3,viewModel.filteredBookings.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourNotificationTVC")as! YourNotificationTVC
        let booking = viewModel.filteredBookings[indexPath.row]
        cell.configure(with: booking)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
*/

import UIKit

protocol YourNotificationVCDelegate: AnyObject {
    func yourNotificationDidRequestTabSwitch(to index: Int)
}

class YourNotificationVC: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var yourNotificationTV: UITableView!
    @IBOutlet weak var viewAllButton: UIButton!
    
    let viewModel = HotelViewModel()
    weak var delegate: YourNotificationVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.filteredBookings = [
            Booking(id: "1", hotelName: "Dar Al Noor", roomType: "Single Room", checkIn: "05 Sep 2025", checkOut: "10 Sep 2025", totalAmount: 300, status: "cancelled"),
            Booking(id: "2", hotelName: "Dar Al Noor", roomType: "Single Room", checkIn: "05 Sep 2025", checkOut: "10 Sep 2025", totalAmount: 350, status: "pending"),
            Booking(id: "3", hotelName: "Louis Inn Hotel", roomType: "Double Room", checkIn: "05 Sep 2025", checkOut: "07 Sep 2025", totalAmount: 280, status: "cancelled"),
            Booking(id: "4", hotelName: "Sea View", roomType: "Single Room", checkIn: "01 Oct 2025", checkOut: "05 Oct 2025", totalAmount: 40, status: "cancelled")
        ]
        UserDefaults.standard.set(true, forKey: "hasViewedNotifications")
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        yourNotificationTV.register(UINib(nibName: "YourNotificationTVC", bundle: nil), forCellReuseIdentifier: "YourNotificationTVC")
        yourNotificationTV.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, !backView.frame.contains(touch.location(in: view)) {
            dismiss(animated: true)
            UIViewController.notificationVCReference = nil
        }
    }
    
    @IBAction func viewAllButtonAction(_ sender: Any) {
        print("ViewAll tapped, calling delegate")
        delegate?.yourNotificationDidRequestTabSwitch(to: 1)
        self.dismiss(animated: true)
    }
}

extension YourNotificationVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(3,viewModel.filteredBookings.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourNotificationTVC")as! YourNotificationTVC
        let booking = viewModel.filteredBookings[indexPath.row]
        cell.configure(with: booking)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

