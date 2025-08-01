//
//  HotelListViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import UIKit

class HotelListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    var viewModel = HotelViewModel()
    var selectedCity = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        
    }
    
    
    func applyFilterOnHotels(){
        guard let hotels = viewModel.Hotels else {
            print("No Data")
            return
        }
        
        if selectedCity != "" && selectedCity != "All" && selectedCity != "Select City"{
            viewModel.filteredHotels = hotels.data.filter { $0.city == selectedCity }
            
        } else {
            viewModel.filteredHotels = hotels.data
            
        }
        tableView.reloadData()
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "FilterOptionsViewController") as? FilterOptionsViewController else { return }
        
        if let sheet = controller.sheetPresentationController {
            sheet.detents = [
                .custom { context in
                    return context.maximumDetentValue * 0.83
                }
            ]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                sheet.largestUndimmedDetentIdentifier = .medium
                controller.preferredContentSize = CGSize(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height * 0.6
                )
            }
        }
        
        controller.modalPresentationStyle = .pageSheet
        present(controller, animated: true)
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
           
                self.applyFilterOnHotels()

    }
}
