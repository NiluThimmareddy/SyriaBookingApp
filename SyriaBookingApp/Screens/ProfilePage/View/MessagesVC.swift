//
//  MessagesVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 10/07/25.
//

import UIKit

class MessagesVC: UIViewController {

    @IBOutlet weak var scrolViewScroll: UIScrollView!
    @IBOutlet weak var scrollViewContentView: UIView!
    @IBOutlet weak var scrollViewContentViewHeightConstraint: NSLayoutConstraint! // default height 382
    @IBOutlet weak var messageTVHeightConstraint: NSLayoutConstraint! // default height 140
    @IBOutlet weak var messagesTV: UITableView!
    @IBOutlet weak var yourHostOrTheStaffText: UILabel!
    @IBOutlet weak var messageThePropertyText: UILabel!
    @IBOutlet weak var dontMissImportantMessagesText: UILabel!
    @IBOutlet weak var messageThePropertyTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var turnOnNotificationBackView: UIView!
    @IBOutlet weak var xMarkButton: UIButton!
    @IBOutlet weak var turnOnNotificationButton: UIButton!
    
    var xMarkIsTapped: Bool = false
    var lastCalculatedScrollContentHeight: CGFloat = 382.0
    let topNameLbl: UILabel = {
       let label = UILabel()
       label.textColor = .white
       label.text = "Messages"
       label.font = UIFont.poppinsBold(16)
       label.textAlignment = .center
       return label
   }()
    var messages: [MessageData] = [
        MessageData(hotelName: "The Grand Hyatt", hotelImage: "1", date: "2025-07-10", expiresIn: "Hurry! Expiry Tomorrow", status: "Confirmed"),
        MessageData(hotelName: "Marriott Suites", hotelImage: "2", date: "2025-07-09", expiresIn: "Last day today", status: "Pending"),
        MessageData(hotelName: "Taj Palace", hotelImage: "3", date: "2025-07-08", expiresIn: "Expired Yesterday", status: "Cancelled"),
        MessageData(hotelName: "Hilton Garden", hotelImage: "4", date: "2025-07-15", expiresIn: "Expires in 5 days", status: "Confirmed"),
        MessageData(hotelName: "Leela Ambience", hotelImage: "5", date: "2025-07-13", expiresIn: "Expires in 3 days", status: "Pending")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTV.register(UINib(nibName: "MessagesTVC", bundle: nil), forCellReuseIdentifier: "MessagesTVC")
        turnOnNotificationBackView.layer.cornerRadius = 10
        turnOnNotificationBackView.layer.borderWidth = 1
        turnOnNotificationBackView.layer.borderColor = UIColor.lightGray.cgColor
        navigationItem.titleView = topNameLbl
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableViewAndScrollHeight()
    }
    
    func updateTableViewAndScrollHeight() {
        let numberOfMessages = messages.count
        let singleRowHeight: CGFloat = 130.0
        let baseScrollHeight: CGFloat = 382.0
        let baseTableHeight: CGFloat = 130.0

        let tableHeight = CGFloat(numberOfMessages) * singleRowHeight
        messageTVHeightConstraint.constant = tableHeight

        let extraHeight = tableHeight - baseTableHeight
        let totalScrollHeight = baseScrollHeight + extraHeight

        scrollViewContentViewHeightConstraint.constant = totalScrollHeight

        lastCalculatedScrollContentHeight = totalScrollHeight
        
        if xMarkIsTapped == true{
            scrollViewContentViewHeightConstraint.constant = lastCalculatedScrollContentHeight - 100
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }


    @IBAction func xMarkButton(_ sender: Any) {
        messageThePropertyTopConstraint.constant = 20
        turnOnNotificationBackView.isHidden = true
        scrollViewContentViewHeightConstraint.constant = lastCalculatedScrollContentHeight - 100
        xMarkIsTapped = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func turnOnNotificationButton(_ sender: Any) {
        
    }
    
    
    
}

extension MessagesVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesTVC")as! MessagesTVC
        let data = messages[indexPath.row]
        cell.bookedDate.text = data.date
        cell.expiresInDays.text = data.expiresIn
        cell.statusLbl.text = data.status
        cell.hotelName.text = data.hotelName
        cell.hotelImage.image = UIImage(named: data.hotelImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
