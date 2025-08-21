//
//  ViewAllRateAndReviewsVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 21/08/25.
//

import UIKit

class ViewAllRateAndReviewsVC : UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var rateAndReviewsLabel: UILabel!
    @IBOutlet weak var rateAndReviewsTableView: UITableView!
    
    var selectedHotel : Hotel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ViewAllRateAndReviewsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedHotel?.reviews.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RateAndReviewsTVC") as! RateAndReviewsTVC
        if let reviews = selectedHotel?.reviews, indexPath.row < reviews.count {
            let review = reviews[indexPath.row]
            cell.configure(with: review)
        }
        return cell
    }
}

extension ViewAllRateAndReviewsVC {
    func setUpUI() {
        rateAndReviewsTableView.delegate = self
        rateAndReviewsTableView.dataSource = self
        rateAndReviewsTableView.register(UINib(nibName: "RateAndReviewsTVC", bundle: nil), forCellReuseIdentifier: "RateAndReviewsTVC")
        
        guard let hotel = selectedHotel else { return }
        
        rateAndReviewsLabel.text = "Rate & Reviews \(hotel.averageRating) (\(hotel.reviewCount) reviews)"
        rateAndReviewsTableView.reloadData()
        
        backView.applyCardStyle()
    }
}
