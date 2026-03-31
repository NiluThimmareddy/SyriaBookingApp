//
//  ViewAllRateAndReviewsVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 21/08/25.
//

import UIKit

class ViewAllRateAndReviewsVC : BaseViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var rateAndReviewsLabel: UILabel!
    @IBOutlet weak var rateAndReviewsTableView: UITableView!
    
    var selectedHotel : Hotel?
    
    var reviewsArray : [Review]?
    var comingFrom : ComingFromToLogin?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func FetchuserReview(){
        guard reviewsArray != nil else {
            rateAndReviewsLabel.text = ""
            reviewsArray = []
            return
        }
        rateAndReviewsTableView.reloadData()
    }
}

extension ViewAllRateAndReviewsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comingFrom == .profile{
            return  reviewsArray?.count ?? 0
        }else{
            return selectedHotel?.reviews.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if comingFrom == .profile {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RateAndReviewsTVC") as! RateAndReviewsTVC
            if let reviews = reviewsArray?[indexPath.row] {
                
                cell.configure(with: reviews)
            }
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RateAndReviewsTVC") as! RateAndReviewsTVC
            if let reviews = selectedHotel?.reviews, indexPath.row < reviews.count {
                let review = reviews[indexPath.row]
                cell.configure(with: review)
            }
            return cell
        }
        
    }
}

extension ViewAllRateAndReviewsVC {
    func setUpUI() {
        rateAndReviewsTableView.delegate = self
        rateAndReviewsTableView.dataSource = self
        rateAndReviewsTableView.register(UINib(nibName: "RateAndReviewsTVC", bundle: nil), forCellReuseIdentifier: "RateAndReviewsTVC")
        
        if comingFrom == .profile {
            FetchuserReview()
            rateAndReviewsLabel.text = "Reviews"
        }else {
            guard let hotel = selectedHotel else { return }
            
            if AppSettings.shared.selectedLanguage == .arabic {
                rateAndReviewsLabel.text = "التقييمات والمراجعات \(hotel.averageRating) (\(hotel.reviewCount) مراجعات)"
            } else {
                rateAndReviewsLabel.text = "Rate & Reviews \(hotel.averageRating) (\(hotel.reviewCount) reviews)"
            }
        }
        rateAndReviewsTableView.reloadData()
        
        backView.applyCardStyle()
        
        
    }
    
}
