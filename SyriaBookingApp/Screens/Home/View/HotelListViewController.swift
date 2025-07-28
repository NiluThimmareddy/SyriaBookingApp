//
//  HotelListViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import UIKit

class HotelListViewController: UIViewController {
    
    var viewModel : HotelViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    deinit {
        print("HotelListViewController deinit...")
    }
    
}

extension HotelListViewController : UITableViewDataSource ,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   viewModel.filteredHotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let data = viewModel.filteredHotels[indexPath.row]
        cell.textLabel?.text = data.name
        cell.imageView?.image = UIImage(named: data.coverImageURL ?? "HotelPlaceholder")
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.Hotels?.data.count ?? 0
        
    }
}

