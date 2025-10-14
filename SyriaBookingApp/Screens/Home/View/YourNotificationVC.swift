
import UIKit

protocol YourNotificationVCDelegate: AnyObject {
    func yourNotificationDidRequestTabSwitch(to index: Int)
}

class YourNotificationVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var yourNotificationTV: UITableView!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var backViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noNotificationsLabel: UILabel!
    @IBOutlet weak var myBookingsTitleLabel: UILabel!
    
    let viewModel = NotificationViewModel()
    weak var delegate: YourNotificationVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, !backView.frame.contains(touch.location(in: view)) {
            dismiss(animated: true)
            UIViewController.notificationVCReference = nil
        }
    }
    
    @IBAction func viewAllButtonAction(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.yourNotificationDidRequestTabSwitch(to: 1)
        }
    }
}

extension YourNotificationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(3, viewModel.filteredHistoryArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourNotificationTVC", for: indexPath) as! YourNotificationTVC
        cell.configure(with: viewModel.filteredHistoryArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let bookingdetails = viewModel.filteredHistoryArray[indexPath.row]
        guard let viewBookingConfirmationVC = UIStoryboard(name: "Booking", bundle: nil).instantiateViewController(withIdentifier: "ViewBookingConfirmationVC") as? ViewBookingConfirmationVC else {
            return
        }
        viewBookingConfirmationVC.isFromMyBookings = true
        viewBookingConfirmationVC.bookingId = bookingdetails.id
        viewBookingConfirmationVC.hotelID = bookingdetails.hotelId
        viewBookingConfirmationVC.roomType = bookingdetails.roomType
        viewBookingConfirmationVC.modalPresentationStyle = .fullScreen
        present(viewBookingConfirmationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension YourNotificationVC {
    func setUpUI() {
        yourNotificationTV.delegate = self
        noNotificationsLabel.isHidden = true
        showLoader()
        
        yourNotificationTV.register(UINib(nibName: "YourNotificationTVC", bundle: nil), forCellReuseIdentifier: "YourNotificationTVC")
        yourNotificationTV.estimatedRowHeight = 60
        yourNotificationTV.rowHeight = UITableView.automaticDimension
        
        
        UserDefaults.standard.set(true, forKey: "hasViewedNotifications")
        
        viewModel.onSuccess = { [weak self] response in
            DispatchQueue.main.async {
                self?.hideLoader()
               
                self?.viewModel.filteredHistoryArray = response

                let rowCount = self?.viewModel.filteredHistoryArray.count ?? 0
                
                if rowCount == 0 {
                    self?.noNotificationsLabel.isHidden = false
                    self?.yourNotificationTV.isHidden = true
                    if AppSettings.shared.selectedLanguage == .arabic {
                        self?.noNotificationsLabel.text = "لا توجد حجوزات قادمة"
                    } else {
                        self?.noNotificationsLabel.text = "No Upcoming bookings found"
                    }
                    self?.backViewHeightConstraint.constant = 100
                } else {
                    self?.noNotificationsLabel.isHidden = true
                    self?.yourNotificationTV.isHidden = false
                    self?.yourNotificationTV.reloadData()
                    self?.updateTableViewHeight()
                }
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.hideLoader()
                self?.showAlert(error)
            }
        }
        
        if let user = UserSessionManager.getUser() {
            viewModel.fetchNotificationUser(userId: user.id)
            
        }
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    private func updateTableViewHeight() {
        var totalHeight: CGFloat = 0
        let rowCount = min(3, viewModel.filteredHistoryArray.count)
        
        // Use the first 'rowCount' items from the reversed array
        let reversedArray = Array(viewModel.filteredHistoryArray.reversed())
        
        for row in 0..<rowCount {
            let indexPath = IndexPath(row: row, section: 0)
            if let cell = yourNotificationTV.dequeueReusableCell(withIdentifier: "YourNotificationTVC") as? YourNotificationTVC {
                cell.configure(with: reversedArray[row])
                cell.layoutIfNeeded()
                totalHeight += cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            } else {
                totalHeight += 60
            }
        }
        totalHeight += 51 // Extra padding for the backView
        backViewHeightConstraint.constant = totalHeight
        view.layoutIfNeeded()
    }

}

extension YourNotificationVC {

    func setupLanguage() {
        if AppSettings.shared.selectedLanguage == .arabic {
            viewAllButton.setTitle("عرض الكل", for: .normal)
            viewAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            myBookingsTitleLabel.text = "حجوزاتي"
        } else {
            viewAllButton.setTitle("View All", for: .normal)
            viewAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            myBookingsTitleLabel.text = "My Bookings"
        }
    }
}
