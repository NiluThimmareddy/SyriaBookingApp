//
//  SecurityVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 30/06/25.
//

import UIKit

class SecurityVC: UIViewController {

    @IBOutlet weak var securityTV: UITableView!
    @IBOutlet weak var settingsContentLbl: UILabel!
    
    let securityCall = [
        SecurityData(securityTitle: "Recent Activity", securityContent: "Review your account's login history and activity to ensure everything looks familiar. If you spot anything suspicious, you can take action to secure your account."),
        SecurityData(securityTitle: "App Permissions", securityContent: "Manage the permissions you've granted to our app. You can control access to device features like your camera, location, and storage, and adjust them at any time."),
        SecurityData(securityTitle: "Account Deletion", securityContent: ""),
    ]
    let topNameLbl: UILabel = {
       let label = UILabel()
       label.textColor = .white
       label.text = "Security"
       label.font = UIFont.poppinsBold(16)
       label.textAlignment = .center
       return label
   }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        fontStyle()
        securityTV.register(UINib(nibName: "SecurityTVC", bundle: nil), forCellReuseIdentifier: "SecurityTVC")
        navigationItem.titleView = topNameLbl
    }
    func fontStyle(){
        settingsContentLbl.font = UIFont.poppinsBold(16)
        
    }

    
    
    

}

extension SecurityVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return securityCall.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SecurityTVC")as! SecurityTVC
        let data = securityCall[indexPath.row]
        cell.deleteAccountButton.isHidden = false
        if indexPath.row == securityCall.count - 1 {
            cell.contentLbl.isHidden =  true
            cell.titleLbl.text = data.securityTitle
            cell.arrowImage.isHidden = true
            cell.deleteAccountButton.isHidden = false
        }else{
            cell.contentLbl.isHidden =  false
            cell.arrowImage.isHidden = false
            cell.deleteAccountButton.isHidden = true
            cell.contentLbl.text = data.securityContent
            cell.titleLbl.text = data.securityTitle
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.row == securityCall.count - 1  {
          return 100
        }else{
            return 120
        }
    }
}
