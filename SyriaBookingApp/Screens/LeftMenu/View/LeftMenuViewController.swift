//
//  LeftMenuViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 31/07/25.
//

import UIKit

class LeftMenuViewController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var LeftMenuUITableView : UITableView!
    @IBOutlet weak var logoImgView: UIImageView!
    
    let menuItems = [
        ("Hotels", "bed.double.fill"),
        ("Careers", "briefcase.fill"),
        ("How it works", "questionmark.circle.fill"),
        ("Your Booking", "calendar.badge.checkmark"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        
        [backView,topView].forEach { shadow in
            shadow?.applyCardStyle()
            shadow?.layer.cornerRadius = 20
            shadow?.layer.maskedCorners = [.layerMaxXMinYCorner]
        }
        LeftMenuUITableView.register(UINib(nibName: "LeftMenuTVC", bundle: nil), forCellReuseIdentifier: "LeftMenuTVC")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.backButtonTitle = ""
    }
    
    @IBAction func DismissButtonAction(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
        self.navigationController?.navigationBar.isHidden = false
    }

}

extension LeftMenuViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuTVC") as! LeftMenuTVC
        let item = menuItems[indexPath.row]
        cell.titleLabel.text = item.0
        let image = UIImage(systemName: item.1)?.withRenderingMode(.alwaysTemplate)
        cell.imgView.image = image
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        
        guard let indexPath = indexPath else { return }
       
        switch indexPath.row {
        case 0 :
            let controller = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HotelListViewController") as! HotelListViewController
            self.navigationController?.pushViewController(controller, animated: true)
        case 1 :
            let controller = storyboard?.instantiateViewController(withIdentifier: "CareersVC") as! CareersVC
            self.navigationController?.pushViewController(controller, animated: true)
        case 2:
            let controller = storyboard?.instantiateViewController(withIdentifier: "HowItsWorkVC") as! HowItsWorkVC
            self.navigationController?.pushViewController(controller, animated: true)
        case 3:
            let controller = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MyBookingsViewController") as! MyBookingsViewController
            self.navigationController?.pushViewController(controller, animated: true)
        default :
            break
        }
    }
}
