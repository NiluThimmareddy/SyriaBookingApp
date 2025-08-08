//
//  ProfilePageVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 26/06/25.
//

import UIKit

class ProfilePageVC: UIViewController {
    
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
    @IBOutlet weak var completeProfileButton: UIButton!
    @IBOutlet weak var completeProfileLabel: UILabel!
    @IBOutlet weak var completeProfileImage: UIImageView!
    @IBOutlet weak var completeProfileImageBackView: UIView!
    @IBOutlet weak var completeProfileBackView: UIView!
    @IBOutlet weak var profileTV: UITableView!
    
    let topNameLbl: UILabel = {
       let label = UILabel()
       label.textColor = .white
       label.text = "Profile"
       label.font = UIFont.poppinsBold(16)
       label.textAlignment = .center
       return label
   }()
    var messageButton: UIBarButtonItem!
    var bellButton: UIBarButtonItem!
    let profileSections: [ProfileSection] = [
        
        ProfileSection(
            sectionTitle: "Preferences",
            options: [
                ProfileOption(listData: "Email Preferences", imageName: "envelope.fill")
            ]
        ),
        ProfileSection(
            sectionTitle: "Help and Privacy",
            options: [
                ProfileOption(listData: "FAQ", imageName: "questionmark.circle"),
                ProfileOption(listData: "About Us", imageName: "info.circle"),
                ProfileOption(listData: "Terms of Use", imageName: "doc.text"),
                ProfileOption(listData: "Privacy and Data Management", imageName: "lock.shield"),
                ProfileOption(listData: "Customer Service", imageName: "person.crop.circle.badge.questionmark")
            ]
        )
    ]

    let manageAccountsData = [
        ProfileOption(listData: "Personal details", imageName: "person"),
        ProfileOption(listData: "Security Settings", imageName: "lock"),
        ProfileOption(listData: "Other travellers", imageName: "person.2"),
        ProfileOption(listData: "My reviews", imageName: "bubble.left.and.bubble.right")
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        navigationProcess()
        userName.text = "Hi,\("Ram")"
        userEmail.text = "\("Usermail@gmail.com")"
        navigationItem.titleView = topNameLbl
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateProfileTableViewHeight()
        roundCornersOfTopProfileView()
    }
    func mixedText() {
        let fullText = "Complete your profile and use this informations for your next booking"
        let boldText = "Complete your profile"

        let attributedString = NSMutableAttributedString(string: fullText)

        // 1. Apply default font to entire text first
        attributedString.addAttribute(.font, value: UIFont.poppinsMedium(12), range: NSRange(location: 0, length: attributedString.length))

        // 2. Apply bold to specific part
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
        
        let signOut = NSAttributedString(
            string: "Sign out",
            attributes: [.font: UIFont.poppinsBold(12), .foregroundColor: UIColor.red]
        )
        signOutButton.setAttributedTitle(signOut, for: .normal)
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
        }else{
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

    func navigationProcess() {
        messageButton = UIBarButtonItem(
            image: UIImage(systemName: "message"),
            style: .plain,
            target: self,
            action: #selector(messageButtonTapped)
        )

        bellButton = UIBarButtonItem(
            image: UIImage(systemName:  "bell"),
            style: .plain,
            target: self,
            action: #selector(bellButtonTapped)
        )

        if let messageBarButton = messageButton, let bellBarButton = bellButton {
            navigationItem.rightBarButtonItems = [messageBarButton, bellBarButton]
        }

        navigationController?.navigationBar.tintColor = .white
    }


    @objc func messageButtonTapped() {
        print("message tapped")
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "CustomerServiceChatVC")as! CustomerServiceChatVC
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(controller, animated: true)
//        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
//        let controller = storyboard.instantiateViewController(identifier: "MessagesVC")as! MessagesVC
//        navigationItem.backButtonTitle = ""
//        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func bellButtonTapped() {
        print("bell tapped")
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "YourNotificationVC")as! YourNotificationVC
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(controller, animated: true)
    }

  

    @IBAction func signOutButton(_ sender: Any) {
        
    }
    @IBAction func completeProfileButton(_ sender: Any) {
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
            
            switch selectedOption.listData {
            case "Email Preferences":
                let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                let controller = storyboard.instantiateViewController(identifier: "EmailPreferencesVC")as! EmailPreferencesVC
                navigationItem.backButtonTitle = ""
                navigationController?.pushViewController(controller, animated: true)

            case "FAQ":
                let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                let controller = storyboard.instantiateViewController(identifier: "HelpCentreVC")as! HelpCentreVC
                navigationItem.backButtonTitle = ""
                navigationController?.pushViewController(controller, animated: true)

            case "Abous Us":
                let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                let controller = storyboard.instantiateViewController(identifier: "PrivacyPolicyVC")as! PrivacyPolicyVC
                navigationItem.backButtonTitle = ""
                controller.contentType = .about
                navigationController?.pushViewController(controller, animated: true)
                
            case "Terms of Use":
                let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                let controller = storyboard.instantiateViewController(identifier: "PrivacyPolicyVC")as! PrivacyPolicyVC
                navigationItem.backButtonTitle = ""
                controller.contentType = .terms
                navigationController?.pushViewController(controller, animated: true)
                
            case "Privacy and data management":
                let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                let controller = storyboard.instantiateViewController(identifier: "PrivacyPolicyVC")as! PrivacyPolicyVC
                navigationItem.backButtonTitle = ""
                controller.contentType = .privacy
                navigationController?.pushViewController(controller, animated: true)

            case "Customer Service":
                let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                let controller = storyboard.instantiateViewController(identifier: "CustomerServiceVC")as! CustomerServiceVC
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
            let controller = storyboard.instantiateViewController(identifier: "PersonalDetailsViewController")as! PersonalDetailsViewController
            navigationItem.backButtonTitle = ""
            navigationController?.pushViewController(controller, animated: true)
        }else if indexPath.row == 1{
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let controller = storyboard.instantiateViewController(identifier: "SecurityVC")as! SecurityVC
            navigationItem.backButtonTitle = ""
            navigationController?.pushViewController(controller, animated: true)
        }else  if indexPath.row == 2{
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "OtherGuestVC")as! OtherGuestVC
            navigationItem.backButtonTitle = ""
            navigationController?.pushViewController(vc, animated: true)
        }else  if indexPath.row == 3{
//            let storyboard = UIStoryboard(name: "UserFeedBack", bundle: nil)
//            let vc = storyboard.instantiateViewController(identifier: "UserFeedBackListVC")as! UserFeedBackListVC
//            navigationItem.backButtonTitle = ""
//            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


