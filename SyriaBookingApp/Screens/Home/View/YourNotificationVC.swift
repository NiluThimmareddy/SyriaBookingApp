//
//  YourNotificationVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 09/07/25.
//

import UIKit

class YourNotificationVC: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var yourNotificationTV: UITableView!
    @IBOutlet weak var viewAllButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "hasViewedNotifications")
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        yourNotificationTV.register(UINib(nibName: "YourNotificationTVC", bundle: nil), forCellReuseIdentifier: "YourNotificationTVC")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, !backView.frame.contains(touch.location(in: view)) {
            dismiss(animated: true)
            UIViewController.notificationVCReference = nil
        }
    }
    
    @IBAction func viewAllButtonAction(_ sender: Any) {
    }
    
}

extension YourNotificationVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourNotificationTVC")as! YourNotificationTVC
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
