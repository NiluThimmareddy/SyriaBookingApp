//
//  MyBookingsViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 01/08/25.
//

import UIKit

class MyBookingsViewController: UIViewController {

    @IBOutlet weak var HistoryTableView: UITableView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    let viewModel = HotelViewModel()
    var selectedSegmentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        showNavigationBar()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        gradientView.applyTopRightLightGreenGradient()
//    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        HistoryTableView.reloadData()
    }
    
}

extension MyBookingsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(5, viewModel.filteredHotels.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingTableViewCell", for: indexPath) as! MyBookingTableViewCell
        let hotel = viewModel.filteredHotels[indexPath.row]
        cell.configure(with: hotel)
        
        switch selectedSegmentIndex {
        case 1:
            cell.statusButton.setTitle("Checked-Out", for: .normal)
            cell.statusButton.setTitleColor(.systemOrange, for: .normal)
            cell.statusButton.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.1)
        case 2:
            cell.statusButton.setTitle("Cancelled", for: .normal)
            cell.statusButton.setTitleColor(.systemRed, for: .normal)
            cell.statusButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        default:
            cell.statusButton.setTitle("Confirmed", for: .normal)
            cell.statusButton.setTitleColor(.systemGreen, for: .normal)
            cell.statusButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 250 : 206
    }
}

extension MyBookingsViewController {
    func setupUI(){
        HistoryTableView.register(UINib(nibName: "MyBookingTableViewCell", bundle: nil), forCellReuseIdentifier: "MyBookingTableViewCell")
        
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black
        ]
        
        segmentControl.setTitleTextAttributes(normalAttributes, for: .normal)
        segmentControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        segmentControl.layer.backgroundColor = UIColor.white.cgColor
        segmentControl.selectedSegmentTintColor = UIColor.black
        segmentControl.addBottomShadow()
        
        viewModel.filteredHotels = HotelDataMaganer.shared.allHotels
        DispatchQueue.main.async {
            self.HistoryTableView.reloadData()
        }
    }
}
