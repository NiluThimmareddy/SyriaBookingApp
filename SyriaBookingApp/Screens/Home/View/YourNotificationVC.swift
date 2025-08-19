//
//  YourNotificationVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 09/07/25.
//

import UIKit

class YourNotificationVC: UIViewController {

    @IBOutlet weak var yourNotificationTV: UITableView!
    
    var notificationData = [
        NotificationData(
            date: "09 Aug 2025",
            viewYourBooking: "View your confirmation for Ocean View Hotel",
            bookingConfirmation: "Booking Confirmed",
            hotelImage: UIImage(named: "HotelPlaceholder") ?? UIImage()
        ),
        NotificationData(
            date: "08 Aug 2025",
            viewYourBooking: "View your cancellation for Sunrise Inn",
            bookingConfirmation: "Booking Cancelled",
            hotelImage: UIImage(named: "HotelPlaceholder") ?? UIImage()
        ),
        NotificationData(
            date: "07 Aug 2025",
            viewYourBooking: "View your confirmation for Hilltop Resort",
            bookingConfirmation: "Booking Confirmed",
            hotelImage: UIImage(named: "HotelPlaceholder") ?? UIImage()
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "hasViewedNotifications")
        yourNotificationTV.register(UINib(nibName: "YourNotificationTVC", bundle: nil), forCellReuseIdentifier: "YourNotificationTVC")
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        yourNotificationTV.rowHeight = UITableView.automaticDimension
        yourNotificationTV.estimatedRowHeight = 120

    }

}

extension YourNotificationVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourNotificationTVC")as! YourNotificationTVC
        let data = notificationData[indexPath.row]
        cell.dateLbl.text = data.date
        cell.bookingConfirmationLbl.text = data.bookingConfirmation
        cell.hotelImage.image = data.hotelImage
        cell.viewYourBookingLbl.text = data.viewYourBooking
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
