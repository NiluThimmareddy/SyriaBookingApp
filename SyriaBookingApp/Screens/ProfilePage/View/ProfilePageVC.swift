//
//  ProfilePageVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 26/06/25.
//

import UIKit

class ProfilePageVC: BaseViewController {
    
    @IBOutlet weak var manageAccountsCVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var topProfileView: UIView!
    @IBOutlet weak var manageAccountTitleLbl: UILabel!
    @IBOutlet weak var profileTVHeightCons: NSLayoutConstraint! //default height 90 ( 40 for header and 50 for cell)
    @IBOutlet weak var scrollViewScroll: UIScrollView!
    @IBOutlet weak var scrollViewContentView: UIView!
    @IBOutlet weak var scrollViewContentViewHeightCons: NSLayoutConstraint! //default height 571
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var signOutBackView: UIView!
    @IBOutlet weak var manageAccountsCV: UICollectionView!
    @IBOutlet weak var completeProfileLabel: UILabel!
    @IBOutlet weak var completeProfileImage: UIImageView!
    @IBOutlet weak var completeProfileImageBackView: UIView!
    @IBOutlet weak var completeProfileBackView: UIView!
    @IBOutlet weak var profileTV: UITableView!
    
    // English data
    let englishProfileSections: [ProfileSection] = [
        ProfileSection(
            sectionTitle: "Preferences",
            options: [
                ProfileOption(listData: "Email Preferences", imageName: "envelope.fill")
            ]
        ),
    ]
    
    let englishManageAccountsData = [
        ProfileOption(listData: "Personal details", imageName: "person"),
        ProfileOption(listData: "My Bookings", imageName: "calendar"),
        ProfileOption(listData: "Other Guests", imageName: "person.2"),
        ProfileOption(listData: "My reviews", imageName: "bubble.left.and.bubble.right")
    ]
    
    // Arabic data
    let arabicProfileSections: [ProfileSection] = [
        ProfileSection(
            sectionTitle: "التفضيلات",
            options: [
                ProfileOption(listData: "تفضيلات البريد الإلكتروني", imageName: "envelope.fill")
            ]
        ),

    ]
    
    let arabicManageAccountsData = [
        ProfileOption(listData: "البيانات الشخصية", imageName: "person"),
        ProfileOption(listData: "حجوزاتي", imageName: "calendar"),
        ProfileOption(listData: "ضيوف آخرون", imageName: "person.2"),
        ProfileOption(listData: "تقييماتي", imageName: "bubble.left.and.bubble.right")
    ]
    
    // Computed properties that return data based on current language
    var profileSections: [ProfileSection] {
        return AppSettings.shared.selectedLanguage == .arabic ? arabicProfileSections : englishProfileSections
    }
    
    var manageAccountsData: [ProfileOption] {
        return AppSettings.shared.selectedLanguage == .arabic ? arabicManageAccountsData : englishManageAccountsData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        
        profileTV.register(UINib(nibName: "ProfileTVC", bundle: nil), forCellReuseIdentifier: "ProfileTVC")
        profileTV.showsVerticalScrollIndicator = false
        profileTV.showsHorizontalScrollIndicator = false
        manageAccountsCV.register(UINib(nibName: "ManageAccountsCVC", bundle: nil), forCellWithReuseIdentifier: "ManageAccountsCVC")
        completeProfileImageBackView.layer.cornerRadius = completeProfileImageBackView.frame.size.height / 2
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        completeProfileBackView.backViewBlackShadow()
        completeProfileBackView.layer.cornerRadius = 10
        signOutBackView.backViewBlackShadow()
        signOutBackView.layer.cornerRadius = 10
        fontStyle()
        mixedText()
        
        // Set initial texts
        updateTexts()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        
        // Update manage account title
        manageAccountTitleLbl.text = lang == .arabic ? "إدارة الحساب" : "Manage Account"
        
        // Update sign out button
        signOutButton.setTitle(lang == .arabic ? "تسجيل الخروج" : "Sign Out", for: .normal)
        
        // Reload table and collection views with new data
        profileTV.reloadData()
        manageAccountsCV.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateProfileTableViewHeight()
        roundCornersOfTopProfileView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        self.navigationItem.backButtonTitle = ""
        setupAppNavigationBar()
        guard let username = UserSessionManager.getUser() else { return }
        
        let lang = AppSettings.shared.selectedLanguage
        if lang == .arabic {
            userName.text = "مرحباً، \(username.name)"
        } else {
            userName.text = "Hi, \(username.name)"
        }
        userEmail.text = "\(username.email)"
    }
    
    func mixedText() {
        let lang = AppSettings.shared.selectedLanguage
        let fullText: String
        let boldText: String
        
        if lang == .arabic {
            fullText = "أكمل ملفك الشخصي واستخدم هذه المعلومات لحجزك القادم"
            boldText = "أكمل ملفك الشخصي"
        } else {
            fullText = "Complete your profile and use this informations for your next booking"
            boldText = "Complete your profile"
        }
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Apply default font to entire text first
        attributedString.addAttribute(.font, value: UIFont.poppinsMedium(12), range: NSRange(location: 0, length: attributedString.length))
        
        // Apply bold to specific part
        if let boldRange = fullText.range(of: boldText) {
            let nsRange = NSRange(boldRange, in: fullText)
            attributedString.addAttribute(.font, value: UIFont.poppinsBold(12), range: nsRange)
        }
        
        completeProfileLabel.attributedText = attributedString
    }
    
    func fontStyle(){
        userName.font = UIFont.poppinsBold(16)
        userEmail.font = UIFont.poppinsMedium(12)
        manageAccountTitleLbl.font = UIFont.poppinsBold(14)
    }
    
    func updateProfileTableViewHeight() {
        if UIDevice.current.userInterfaceIdiom == .pad{
            var totalTableHeight: CGFloat = 0
            
            for section in profileSections {
                totalTableHeight += 70
                totalTableHeight += CGFloat(section.options.count) * 50
            }
            
            profileTVHeightCons.constant = totalTableHeight
            
            if totalTableHeight > 90 {
                let extraHeight = totalTableHeight - 90
                scrollViewContentViewHeightCons.constant = 721 + extraHeight
            } else {
                scrollViewContentViewHeightCons.constant = 721
            }
            
            self.view.layoutIfNeeded()
        } else {
            var totalTableHeight: CGFloat = 0
            
            for section in profileSections {
                totalTableHeight += 70
                totalTableHeight += CGFloat(section.options.count) * 50
            }
            
            profileTVHeightCons.constant = totalTableHeight
            
            if totalTableHeight > 90 {
                let extraHeight = totalTableHeight - 90
                scrollViewContentViewHeightCons.constant = 571 + extraHeight
            } else {
                scrollViewContentViewHeightCons.constant = 571
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    private func roundCornersOfTopProfileView() {
        let width = topProfileView.bounds.width
        let height = topProfileView.bounds.height
        
        // Create a custom curved bottom left corner using a path
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))                        // Top-left
        path.addLine(to: CGPoint(x: width, y: 0))                 // Top-right
        path.addLine(to: CGPoint(x: width, y: height))            // Bottom-right
        path.addLine(to: CGPoint(x: 90, y: height))               // Curve start point
        path.addQuadCurve(to: CGPoint(x: 0, y: height - 90),      // Curve end point
                          controlPoint: CGPoint(x: 0, y: height)) // Curve control point
        path.close()
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        topProfileView.layer.mask = shape
    }
    
    
    @IBAction func completeProfileButton(_ sender: Any) {
        print("Button tapped....")
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        guard let controller = storyboard.instantiateViewController(identifier: "PersonalDetailsViewController")as? PersonalDetailsViewController  else { return }
        
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        let lang = AppSettings.shared.selectedLanguage
        let title = lang == .arabic ? "سيريا بوكينغ" : "SyriaBooking"
        let message = lang == .arabic ? "هل أنت متأكد أنك تريد تسجيل الخروج؟" : "Are you sure you want to logout"
        let okTitle = lang == .arabic ? "نعم" : "Ok"
        let cancelTitle = lang == .arabic ? "إلغاء" : "Cancel"
        
        showAlert(title: title, message: message, type: .error, OkButtonTitle: okTitle, cancelButtonTitle: cancelTitle, onOK: {
            UserSessionManager.clearUser()
            
            NotificationCenter.default.post(
                name: .didLogoutSuccessfully,
                object: nil
            )
            
            self.navigateToHomeTab()
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ProfilePageVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVC", for: indexPath) as? ProfileTVC else {
            return UITableViewCell()
        }
        
        let section = indexPath.section
        let row = indexPath.row
        let numberOfRows = tableView.numberOfRows(inSection: section)
        let option = profileSections[section].options[row]
        
        cell.profileListLbl.text = option.listData
        cell.profileListImages.image = UIImage(systemName:  option.imageName)
        
        cell.profileListLbl.textColor = .darkGray
        cell.profileListLbl.textAlignment = .left
        
        cell.profileListBackView.backViewBlackShadow()
        cell.profileListLbl.font = .poppinsMedium(12)
        
        if numberOfRows == 1 {
            cell.profileListBackView.layer.cornerRadius = 10
            cell.profileListBackView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]
        } else if row == 0 {
            cell.profileListBackView.layer.cornerRadius = 10
            cell.profileListBackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if row == numberOfRows - 1 {
            cell.profileListBackView.layer.cornerRadius = 10
            cell.profileListBackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.profileListBackView.layer.cornerRadius = 0
            cell.profileListBackView.layer.maskedCorners = []
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = profileSections[section].sectionTitle
        label.textColor = .black
        label.font = UIFont.poppinsBold(14)
        label.textAlignment = .left
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: headerView.topAnchor),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return profileSections[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = profileSections[indexPath.section].options[indexPath.row]
        
        let lang = AppSettings.shared.selectedLanguage
        
        switch selectedOption.listData {
        case "Email Preferences", "تفضيلات البريد الإلكتروني":
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            guard let controller = storyboard.instantiateViewController(identifier: "EmailPreferencesVC")as? EmailPreferencesVC  else { return }
            navigationItem.backButtonTitle = ""
            navigationController?.pushViewController(controller, animated: true)
            
        default:
            break
        }
    }
}

extension ProfilePageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manageAccountsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ManageAccountsCVC", for: indexPath)as! ManageAccountsCVC
        let data = manageAccountsData[indexPath.row]
        cell.titleImage.image = UIImage(systemName:  data.imageName)
        cell.titleLbl.text = data.listData
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = ( manageAccountsCV.frame.size.height - 10 ) / 2
        let width = ( manageAccountsCV.frame.size.width - 10 ) / 2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let controller = storyboard.instantiateViewController(identifier: "PersonalDetailsViewController") as! PersonalDetailsViewController
            navigationItem.backButtonTitle = ""
            navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.row == 1 {
            guard let controller = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MyBookingsViewController") as? MyBookingsViewController else { return  }
            self.navigationController?.pushViewController(controller, animated: true)
            
        } else if indexPath.row == 2 {
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            guard let vc = storyboard.instantiateViewController(identifier: "OtherGuestVC")as? OtherGuestVC  else { return }
            navigationItem.backButtonTitle = ""
            navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 3 {
            let reviewsArray  =  hasReviews()
            if  !reviewsArray.isEmpty {
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
               guard let viewAllVC = storyboard.instantiateViewController(withIdentifier: "ViewAllRateAndReviewsVC") as? ViewAllRateAndReviewsVC  else { return  }
                viewAllVC.reviewsArray = reviewsArray
                viewAllVC.comingFrom = .profile
                viewAllVC.modalPresentationStyle = .fullScreen
                present(viewAllVC, animated: true)
            } else {
                showNoReviewsAlert()
            }
        }
    }
    
    func hasReviews() -> [Review] {
        var reviewsArray = [Review]()
        if let username = UserSessionManager.getUser() {
               reviewsArray = HotelDataMaganer.shared.allHotels.flatMap { $0.reviews }
                .filter {
                    $0.reviewerName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ==
                    username.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                }
        }
        return reviewsArray
    }

    func showNoReviewsAlert() {
        let lang = AppSettings.shared.selectedLanguage
        let title = lang == .arabic ? "لا توجد تقييمات" : "No Reviews Found"
        let message = lang == .arabic ?
            "يبدو أنك لم تكتب أي تقييمات بعد. التقييمات التي تكتبها ستساعد المسافرين الآخرين على اتخاذ قرارات أفضل." :
            "It looks like you haven't written any reviews yet. Reviews you write will help other travelers make better decisions."
        let okTitle = lang == .arabic ? "حسناً" : "OK"
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}


