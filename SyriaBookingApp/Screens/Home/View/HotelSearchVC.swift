//
//  HotelSearchVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 18/09/25.
//

import UIKit

class HotelSearchVC : UIViewController {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var selectCityView: UIView!
    @IBOutlet weak var selectCheckInView: UIView!
    @IBOutlet weak var selectCheckOutView: UIView!
    @IBOutlet weak var selectCityButton: UIButton!
    @IBOutlet weak var selectCheckinButton: UIButton!
    @IBOutlet weak var tmrwDateButton: UIButton!
    @IBOutlet weak var dayAfterTmrwButton: UIButton!
    @IBOutlet weak var selectCheckOutButton: UIButton!
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    
    var viewModel = HotelViewModel()
    var datePickerContainerView: UIView!
    var datePicker: UIDatePicker!
    var activeButton: UIButton?
    var currentDatePickerMode: DatePickerMode = .checkIn
    var selectedCheckInDate: Date?
    var selectedCheckOutDate: Date?
    var isDatePickerShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppNavigationBar()
        toggleSearchView()
        setupDatePickerUI()
    }

    @IBAction func selectCityButtonAction(_ sender: Any) {
    }
    
    @IBAction func selectCheckInButtonAction(_ sender: Any) {
        currentDatePickerMode = .checkIn
        updateDatePickerLimits()
        toggleDatePicker(for: selectCheckinButton)
    }
    
    @IBAction func tomorrowDateButtonAction(_ sender: UIButton) {
        selectCheckinButton.setTitle(sender.titleLabel?.text, for: .normal)
        let formater = DateFormatter()
        formater.dateStyle = .medium
        
        let date = formater.date(from: sender.titleLabel?.text ?? "")
        
        guard let date = date else { return }
        selectedCheckInDate = date
        currentDatePickerMode = .checkOut
        setNextDateInCkechout(checkInDate: date)
        updateDatePickerLimits()
    }
    
    @IBAction func dayAfterTomorrowButtonAction(__ sender: UIButton) {
        selectCheckinButton.setTitle(sender.titleLabel?.text, for: .normal)
        let formater = DateFormatter()
        formater.dateStyle = .medium
        
        let date = formater.date(from: sender.titleLabel?.text ?? "")
        selectedCheckInDate = date
        guard let date = date else { return }
        setNextDateInCkechout(checkInDate: date)
        currentDatePickerMode = .checkOut
        updateDatePickerLimits()
    }
    
    @IBAction func selectCheckOutButtonAction(_ sender: Any) {
        currentDatePickerMode = .checkOut
        updateDatePickerLimits()
        toggleDatePicker(for: selectCheckOutButton)
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        if let selectedCity = self.selectCityButton.titleLabel?.text,  selectedCity != "Select City"{
            let storyboard = storyboard?.instantiateViewController(withIdentifier: "HotelListViewController") as! HotelListViewController
            storyboard.viewModel = self.viewModel
            
//            storyboard.delegate = self
            storyboard.comingFrom = .search
            storyboard.selectedCity = selectedCity
            storyboard.navigationItem.title = "Hotel List"
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.navigationBar.tintColor = .white
            self.navigationController?.pushViewController(storyboard, animated: true)
        } else{
            
            showAlert(title: "SyriaBooking", message: "Please select city")
        }
    }
    
    func setNextDateInCkechout(checkInDate:Date){
        if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: checkInDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy" // You can change format as needed
            formatter.dateStyle = .medium
            let tomorrowDate = formatter.string(from: tomorrow)
            
            
            selectedCheckOutDate = tomorrow
            
            selectCheckOutButton.setTitle(tomorrowDate, for: .normal)
            
        }
    }
    
    func updateDatePickerLimits() {
        let now = Date()
        switch currentDatePickerMode {
        case .checkIn:
            
            datePicker.minimumDate = now
            datePicker.date = now
            
        case .checkOut:
            guard let checkIn = selectedCheckInDate else {
                
                datePicker.minimumDate = now
                datePicker.date = now
                return
            }
            datePicker.minimumDate = checkIn
            datePicker.date = checkIn
        }
    }
    
    func toggleDatePicker(for button: UIButton) {
        activeButton = button
        
        if button.superview != nil {
            let buttonFrame = button.convert(button.bounds, to: view)
            let topAnchor = datePickerContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: buttonFrame.maxY + 8)
            NSLayoutConstraint.deactivate(datePickerContainerView.constraints)
            NSLayoutConstraint.activate([
                datePicker.leadingAnchor.constraint(equalTo: datePickerContainerView.leadingAnchor),
                datePicker.trailingAnchor.constraint(equalTo: datePickerContainerView.trailingAnchor),
                datePicker.topAnchor.constraint(equalTo: datePickerContainerView.topAnchor),
                datePicker.bottomAnchor.constraint(equalTo: datePickerContainerView.bottomAnchor),
                datePickerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                topAnchor,
                datePickerContainerView.widthAnchor.constraint(equalToConstant: 320),
                datePickerContainerView.heightAnchor.constraint(equalToConstant: 360)
            ])
        }
        datePickerContainerView.isHidden.toggle()
    }
    
    func toggleSearchView() {
        if searchView.isHidden {
            if UIDevice.current.userInterfaceIdiom == .pad {
                searchViewHeightConstraint.constant = 280
            } else {
                searchViewHeightConstraint.constant = 210
            }
            
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           options: .curveEaseInOut) {
                self.view.layoutIfNeeded()
            }
            searchView.isHidden = false
        } else {
            searchViewHeightConstraint.constant = 0
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                self.view.layoutIfNeeded()
            }) { _ in
                self.searchView.isHidden = true
            }
        }
    }
    
    func setupDatePickerUI() {
        datePickerContainerView = UIView()
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        updateDatePickerLimits()
        datePickerContainerView.backgroundColor = .systemBackground
        datePickerContainerView.layer.cornerRadius = 8
        datePickerContainerView.layer.borderWidth = 1
        datePickerContainerView.layer.borderColor = UIColor.lightGray.cgColor
        datePickerContainerView.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePickerContainerView.addSubview(datePicker)
        view.addSubview(datePickerContainerView)
        
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: datePickerContainerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerContainerView.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: datePickerContainerView.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: datePickerContainerView.bottomAnchor),
            
            datePickerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePickerContainerView.widthAnchor.constraint(equalToConstant: 320),
            datePickerContainerView.heightAnchor.constraint(equalToConstant: 360)
        ])
        
        datePickerContainerView.isHidden = true
    }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        switch currentDatePickerMode {
        case .checkIn:
            selectedCheckInDate = sender.date
            setNextDateInCkechout(checkInDate:sender.date)
        case .checkOut :
            selectedCheckOutDate = sender.date
            break
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let selectedDate = formatter.string(from: sender.date)
        activeButton?.setTitle(selectedDate, for: .normal)
        
        datePickerContainerView.isHidden = true
    }
    
    func setUpTomorrowDate(){
        let today = Date()
        
        if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy" // You can change format as needed
            formatter.dateStyle = .medium
            let tomorrowDate = formatter.string(from: tomorrow)
            tmrwDateButton.setTitle(tomorrowDate, for: .normal)
        }
        
        if let dayAfterTomorrow = Calendar.current.date(byAdding: .day, value: 2, to: today) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy" // You can change format as needed
            formatter.dateStyle = .medium
            let dayAfterTomorrowDate = formatter.string(from: dayAfterTomorrow)
            dayAfterTmrwButton.setTitle(dayAfterTomorrowDate, for: .normal)
        }
    }
}
