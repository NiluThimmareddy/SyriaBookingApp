//
//  HotelListViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import UIKit

class HotelListViewController: UIViewController {

    let viewModel = HotelViewModel()

   @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.fetchHotels()
    }
   
   private func setupUI() {
       viewModel.onDataLoaded = { [weak self]  in
           print("Hotels loaded: ", self?.viewModel.Hotels ?? [])
           DispatchQueue.main.async{
               self?.tableView.reloadData()
           }
       }
       
       viewModel.onError = { error in
           print("Error fetching hotels: \(error.localizedDescription)")
       }
   }
  
}

extension HotelListViewController : UITableViewDataSource ,UITableViewDelegate{
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return   viewModel.Hotels?.data.count ?? 0
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
       let data = viewModel.Hotels?.data[indexPath.row]
       cell.textLabel?.text = data?.name ?? "No Data"
       cell.imageView?.image = UIImage(named: data?.coverImageURL ?? "HotelPlaceholder")
       return cell
   }
   
   
   func numberOfSections(in tableView: UITableView) -> Int {
       return viewModel.Hotels?.data.count ?? 0
       
   }
}
