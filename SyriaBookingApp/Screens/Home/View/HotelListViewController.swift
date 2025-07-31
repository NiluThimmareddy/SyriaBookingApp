//
//  HotelListViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import UIKit

class HotelListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = HotelViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
}

extension HotelListViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.filteredHotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotelListTVC") as! HotelListTVC
        let data = viewModel.filteredHotels[indexPath.row]
        cell.configuration(with: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

}

extension HotelListViewController {
    func setUpUI() {
        
        tableView.register(UINib(nibName: "HotelListTVC", bundle: nil), forCellReuseIdentifier: "HotelListTVC")
        
        viewModel.onDataLoaded = { [weak self]  in
            DispatchQueue.main.async {
                self?.hideLoader()
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.hideLoader()
            }
        }
        viewModel.fetchHotels()
    }
}
