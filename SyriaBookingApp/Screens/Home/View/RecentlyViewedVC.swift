//
//  RecentlyViewedVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 16/10/25.
//

import UIKit

class RecentlyViewedVC: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var recentlyViewedTableview: UITableView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var docImgView: UIImageView!
    @IBOutlet weak var loginDescriptionLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableviewTopConstraint: NSLayoutConstraint!
    
    var recentlyViewedHotels: [Hotel] = []
    var viewModel: HotelViewModel?

    var todayHotels: [Hotel] = []
    var earlierHotels: [Hotel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
        updateLoginViewVisibility()
        loadRecentlyViewedHotels()
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "RegisterMobileNumberVC") as? RegisterMobileNumberVC else { return }
        controller.modalPresentationStyle = .overFullScreen
        controller.transitioningDelegate = self
        controller.reloadScreenAfterDismiss = {
            self.goToHomeTab()
        }
        self.present(controller, animated: true)
    }
}

extension RecentlyViewedVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if recentlyViewedHotels.isEmpty {
            return 1
        }
        
        var sections = 0
        if !todayHotels.isEmpty { sections += 1 }
        if !earlierHotels.isEmpty { sections += 1 }
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recentlyViewedHotels.isEmpty {
            return 1
        }
        
        if numberOfSections(in: tableView) == 1 {
            return !todayHotels.isEmpty ? todayHotels.count : earlierHotels.count
        } else {
            if section == 0 {
                return todayHotels.count
            } else {
                return earlierHotels.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if recentlyViewedHotels.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoRecentlyViewedTVC", for: indexPath) as! NoRecentlyViewedTVC
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentlyViewedListTVC", for: indexPath) as! RecentlyViewedListTVC
        
        let hotel: Hotel
        if numberOfSections(in: tableView) == 1 {
            hotel = !todayHotels.isEmpty ? todayHotels[indexPath.row] : earlierHotels[indexPath.row]
        } else {
            hotel = indexPath.section == 0 ? todayHotels[indexPath.row] : earlierHotels[indexPath.row]
        }
        
        cell.configure(with: hotel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if recentlyViewedHotels.isEmpty {
            return 90
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 200
        } else {
            return 130
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if recentlyViewedHotels.isEmpty {
            return 0
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if recentlyViewedHotels.isEmpty {
            return nil
        }
        
        let headerView = UIView()
//        headerView.backgroundColor = .systemBackground
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .label
        
        let lang = AppSettings.shared.selectedLanguage
        
        if numberOfSections(in: tableView) == 1 {
            titleLabel.text = !todayHotels.isEmpty ?
                (lang == .english ? "Today" : "اليوم") :
                (lang == .english ? "Earlier" : "سابق")
        } else {
            titleLabel.text = section == 0 ?
                (lang == .english ? "Today" : "اليوم") :
                (lang == .english ? "Earlier" : "سابق")
        }
        
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !recentlyViewedHotels.isEmpty else { return }
        
        let hotel: Hotel
        if numberOfSections(in: tableView) == 1 {
            hotel = !todayHotels.isEmpty ? todayHotels[indexPath.row] : earlierHotels[indexPath.row]
        } else {
            hotel = indexPath.section == 0 ? todayHotels[indexPath.row] : earlierHotels[indexPath.row]
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "HotelDetailsViewController") as! HotelDetailsViewController
        vc.selectedHotel = hotel
        vc.navigationItem.title = "Hotel Details"
        
        HotelDataMaganer.shared.addRecentlyViewedHotel(id: hotel.id)
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension RecentlyViewedVC {
    func setUpUI() {
        recentlyViewedTableview.register(UINib(nibName: "RecentlyViewedListTVC", bundle: nil), forCellReuseIdentifier: "RecentlyViewedListTVC")
        recentlyViewedTableview.register(UINib(nibName: "NoRecentlyViewedTVC", bundle: nil), forCellReuseIdentifier: "NoRecentlyViewedTVC")
        
        configureDeleteButtonMenu()
        
        let lang = AppSettings.shared.selectedLanguage
        self.navigationItem.title = lang == .english ? "Recently Viewed" : "شوهدت مؤخرا"
        
        if #available(iOS 15.0, *) {
            recentlyViewedTableview.sectionHeaderTopPadding = 15
        }
        
        recentlyViewedTableview.contentInset = .zero
        recentlyViewedTableview.contentInsetAdjustmentBehavior = .never
    }
    
    func loadRecentlyViewedHotels() {
        if let user = UserSessionManager.getUser() {
            viewModel?.fetchRecentlyViewedHotels { [weak self] in
                DispatchQueue.main.async {
                    self?.recentlyViewedHotels = self?.viewModel?.recentlyViewdHotels ?? []
                    self?.categorizeHotelsByDate()
                    self?.recentlyViewedTableview.reloadData()
                    self?.updateDeleteButtonVisibility()
                }
            }
        } else {
            recentlyViewedHotels = HotelDataMaganer.shared.getAllRecentlyViewedHotels()
            categorizeHotelsByDate()
            recentlyViewedTableview.reloadData()
            updateDeleteButtonVisibility()
        }
    }
    
    func categorizeHotelsByDate() {
        todayHotels.removeAll()
        earlierHotels.removeAll()
        
        let today = Date()
        let calendar = Calendar.current
        
        for hotel in recentlyViewedHotels {
            if let viewedDate = HotelDataMaganer.shared.getRecentlyViewedHotelDate(hotelId: hotel.id) {
                if calendar.isDate(viewedDate, inSameDayAs: today) {
                    todayHotels.append(hotel)
                } else {
                    earlierHotels.append(hotel)
                }
            } else {
                earlierHotels.append(hotel)
            }
        }
        
        todayHotels.sort { hotel1, hotel2 in
            let date1 = HotelDataMaganer.shared.getRecentlyViewedHotelDate(hotelId: hotel1.id) ?? Date.distantPast
            let date2 = HotelDataMaganer.shared.getRecentlyViewedHotelDate(hotelId: hotel2.id) ?? Date.distantPast
            return date1 > date2
        }
        
        earlierHotels.sort { hotel1, hotel2 in
            let date1 = HotelDataMaganer.shared.getRecentlyViewedHotelDate(hotelId: hotel1.id) ?? Date.distantPast
            let date2 = HotelDataMaganer.shared.getRecentlyViewedHotelDate(hotelId: hotel2.id) ?? Date.distantPast
            return date1 > date2
        }
    }
    
    func configureDeleteButtonMenu() {
        let lang = AppSettings.shared.selectedLanguage
        
        let selectAllTitle = lang == .english ? "Clear All History" : "مسح كل السجل"
        let todayTitle = lang == .english ? "Clear Today's History" : "مسح سجل اليوم"
        let earlierTitle = lang == .english ? "Clear Earlier History" : "مسح السجل السابق"
        
        let selectAllAction = UIAction(title: selectAllTitle, image: UIImage(systemName: "trash")) { [weak self] _ in
            self?.handleMenuSelection(option: selectAllTitle)
        }
        
        let todayAction = UIAction(title: todayTitle, image: UIImage(systemName: "clock")) { [weak self] _ in
            self?.handleMenuSelection(option: todayTitle)
        }
        
        let earlierAction = UIAction(title: earlierTitle, image: UIImage(systemName: "calendar")) { [weak self] _ in
            self?.handleMenuSelection(option: earlierTitle)
        }
        
        let menuTitle = lang == .english ? "Clear History" : "مسح السجل"
        let menu = UIMenu(title: menuTitle, options: .displayInline, children: [selectAllAction, todayAction, earlierAction])
        
        deleteButton.menu = menu
        deleteButton.showsMenuAsPrimaryAction = true
    }
        
    func handleMenuSelection(option: String) {
        let lang = AppSettings.shared.selectedLanguage
        
        switch option {
        case lang == .english ? "Clear All History" : "مسح كل السجل":
            clearAllHistory()
        case lang == .english ? "Clear Today's History" : "مسح سجل اليوم":
            clearTodaysHistory()
        case lang == .english ? "Clear Earlier History" : "مسح السجل السابق":
            clearEarlierHistory()
        default:
            break
        }
    }
    
    func clearAllHistory() {
        let lang = AppSettings.shared.selectedLanguage
        let title = lang == .english ? "Clear All History" : "مسح كل السجل"
        let message = lang == .english ?
            "Are you sure you want to clear all your recently viewed hotels?" :
            "هل أنت متأكد أنك تريد مسح كل الفنادق التي شاهدتها مؤخرًا؟"
        let cancelTitle = lang == .english ? "Cancel" : "إلغاء"
        let clearTitle = lang == .english ? "Clear All" : "مسح الكل"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: clearTitle, style: .destructive) { [weak self] _ in
            HotelDataMaganer.shared.clearAllRecentlyViewedHotels()
            
            self?.showClearSuccessMessage(for: "all") {
                self?.navigateToHomePage()
            }
        })
        
        present(alert, animated: true)
    }

    func clearTodaysHistory() {
        let lang = AppSettings.shared.selectedLanguage
        let title = lang == .english ? "Clear Today's History" : "مسح سجل اليوم"
        let message = lang == .english ?
            "Are you sure you want to clear today's recently viewed hotels?" :
            "هل أنت متأكد أنك تريد مسح فنادق اليوم التي شاهدتها؟"
        let cancelTitle = lang == .english ? "Cancel" : "إلغاء"
        let clearTitle = lang == .english ? "Clear Today's" : "مسح اليوم"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: clearTitle, style: .destructive) { [weak self] _ in
            HotelDataMaganer.shared.clearTodaysRecentlyViewedHotels()
            self?.loadRecentlyViewedHotels() // Reload to update the sections
        })
        
        present(alert, animated: true)
    }

    func clearEarlierHistory() {
        let lang = AppSettings.shared.selectedLanguage
        let title = lang == .english ? "Clear Earlier History" : "مسح السجل السابق"
        let message = lang == .english ?
            "Are you sure you want to clear earlier recently viewed hotels (excluding today)?" :
            "هل أنت متأكد أنك تريد مسح الفنادق التي شاهدتها سابقًا (ما عدا اليوم)؟"
        let cancelTitle = lang == .english ? "Cancel" : "إلغاء"
        let clearTitle = lang == .english ? "Clear Earlier" : "مسح السابق"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: clearTitle, style: .destructive) { [weak self] _ in
            HotelDataMaganer.shared.clearEarlierRecentlyViewedHotels()
            self?.loadRecentlyViewedHotels() // Reload to update the sections
        })
        
        present(alert, animated: true)
    }

    func showClearSuccessMessage(for type: String, completion: (() -> Void)? = nil) {
        let lang = AppSettings.shared.selectedLanguage
        let message: String
        
        switch type {
        case "all":
            message = lang == .english ?
                "All recently viewed hotels have been cleared" :
                "تم مسح كل الفنادق التي شاهدتها مؤخرًا"
        case "today":
            message = lang == .english ?
                "Today's recently viewed hotels have been cleared" :
                "تم مسح فنادق اليوم التي شاهدتها"
        case "earlier":
            message = lang == .english ?
                "Earlier recently viewed hotels have been cleared" :
                "تم مسح الفنادق التي شاهدتها سابقًا"
        default:
            return
        }
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true) {
                completion?()
            }
        }
    }
    
    func navigateToHomePage() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0
        }
        if self.presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }
    }

    private func updateDeleteButtonVisibility() {
        deleteButton.isHidden = recentlyViewedHotels.isEmpty
    }
    
    func updateLoginViewVisibility() {
        if UserSessionManager.getUser() != nil {
            loginViewHeightConstraint.constant = 0
            tableviewTopConstraint.constant = 0
            loginView.isHidden = true
        } else {
            loginViewHeightConstraint.constant = 100
            tableviewTopConstraint.constant = 20
            loginView.isHidden = false
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}
