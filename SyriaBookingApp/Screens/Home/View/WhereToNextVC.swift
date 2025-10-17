//
//  WhereToNextVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 16/10/25.
//

import UIKit

class WhereToNextVC: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var docImgView: UIImageView!
    @IBOutlet weak var loginDescriptionLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var citiesTitleLabel: UILabel!
    @IBOutlet weak var whereToNextTableview: UITableView!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var citiesTopConstaint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
        updateLoginViewVisibility()
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

extension WhereToNextVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WhereToNextListTVC") as! WhereToNextListTVC
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HotelDetailsViewController") as! HotelDetailsViewController
//        let selectedHotel = viewModel.filteredHotels[indexPath.row]
//        vc.selectedHotel = selectedHotel
//        vc.navigationItem.title = "Hotel Details"
//        HotelDataMaganer.shared.addRecentlyViewedHotel(id: selectedHotel.id)
//        delegate?.reladRecentlyViewedData()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension WhereToNextVC {
    func setUpUI() {
        whereToNextTableview.register(UINib(nibName: "WhereToNextListTVC", bundle: nil), forCellReuseIdentifier: "WhereToNextListTVC")
    }
    
    func updateLoginViewVisibility() {
        if UserSessionManager.getUser() != nil {
            topViewHeightConstraint.constant = 0
            citiesTopConstaint.constant = 0
            topView.isHidden = true
        } else {
            topViewHeightConstraint.constant = 100
            citiesTopConstaint.constant = 20
            topView.isHidden = false
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}
