//
//  HomeViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import UIKit

class HomeViewController: UIViewController {
    
     let viewModel = HotelViewModel()
var fourHotelsList = [Hotel]()
    override func viewDidLoad() {
        super.viewDidLoad()
     setupUI()
        showLoader()
        viewModel.fetchHotels()
    }
    
    deinit {
        print("HomeViewController deinit...")
    }
    
    
    private func setupUI() {
        viewModel.onDataLoaded = { [weak self]  in
            print("Hotels loaded: ", self?.viewModel.Hotels ?? [])
            DispatchQueue.main.async{
                self?.hideLoader()
                self?.fourHotelsList = Array(HotelDataMaganer.shared.allHotels.prefix(4))
                print(" First Four Hotels : \(self?.fourHotelsList.count)")
//                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] error in
            print("Error fetching hotels: \(error.localizedDescription)")
            DispatchQueue.main.async{
                self?.hideLoader()
            }
        }
    }
    
    @IBAction func viewAllButtonTapped(_ sender: Any) {
        print("Button Tapped")
        
        // navigatoto hotellist
        let controller = storyboard?.instantiateViewController(withIdentifier: "HotelListViewController") as! HotelListViewController
        controller.viewModel = self.viewModel
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

