//
//  CalenderVC.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 02/02/26.
//
import UIKit
import FSCalendar
 
protocol CalenderVCDelegate: AnyObject {
    func didSelectDateRange(checkIn: Date?, checkOut: Date?)
}
 
class CalenderVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    @IBOutlet weak var numberOfDaysLabel: UILabel!
    @IBOutlet weak var selectdatesButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    let days = ["Exact dates", "± 1 day", "± 2 days", "± 3 days", "± 7 days"]
    
    var calendar: FSCalendar!
    var startDate: Date?
    var endDate: Date?
    var selectedRooms: Int?
    weak var delegate: CalenderVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfDaysLabel.text = ""
        daysCollectionView.register(UINib(nibName: "SelectDaysCVC", bundle: nil), forCellWithReuseIdentifier: "SelectDaysCVC")
        if let layout = daysCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
        
        setupCalendar()
        
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
    func setupCalendar() {
        calendar = FSCalendar(frame: insideView.bounds)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.delegate = self
        calendar.dataSource = self
        calendar.allowsMultipleSelection = true
        
        calendar.scrollDirection = .vertical
        calendar.scope = .month
        
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 20)
        calendar.appearance.weekdayTextColor = .darkGray
        calendar.appearance.todayColor = .tintColor
        calendar.appearance.selectionColor = UIColor(hex: "#F09814")
 
        insideView.addSubview(calendar)
 
        NSLayoutConstraint.activate([
            calendar.leadingAnchor.constraint(equalTo: insideView.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: insideView.trailingAnchor),
            calendar.topAnchor.constraint(equalTo: insideView.topAnchor),
            calendar.bottomAnchor.constraint(equalTo: insideView.bottomAnchor)
        ])
    }
 
//    @IBAction func selectDatesButtonAction(_ sender: Any) {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEE dd MMM"
// 
//        if let start = startDate, let end = endDate {
//            let startText = formatter.string(from: start)
//            let endText = formatter.string(from: end)
//            
//            let calendar = Calendar.current
//            let numberOfNights = calendar.dateComponents([.day], from: start, to: end).day ?? 0
//            
//            let dateRangeText: String
//            if numberOfNights == 0 {
//                // Same date selected for both check-in and checkout
//                dateRangeText = "\(startText) - \(endText) • 1 night"
//            } else if numberOfNights == 1 {
//                dateRangeText = "\(startText) - \(endText) • \(numberOfNights) night"
//            } else {
//                dateRangeText = "\(startText) - \(endText) • \(numberOfNights) nights"
//            }
//            
//            delegate?.didSelectDateRange(dateRangeText)
//        } else if let start = startDate {
//            let startText = formatter.string(from: start)
//            delegate?.didSelectDateRange("\(startText) - \(startText) • 1 night")
//        } else {
//            let defaultDateRange = Date.todayAndTomorrowFormattedRange()
//            delegate?.didSelectDateRange(defaultDateRange)
//        }
// 
//        dismiss(animated: true)
//    }
    
    
    @IBAction func selectDatesButtonAction(_ sender: Any) {

        if let start = startDate, let end = endDate {
            delegate?.didSelectDateRange(checkIn: start, checkOut: end)
        } else if let start = startDate {
            delegate?.didSelectDateRange(checkIn: start, checkOut: start)
        } else {
            let today = Calendar.current.startOfDay(for: Date())
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
            delegate?.didSelectDateRange(checkIn: today, checkOut: tomorrow)
        }

        dismiss(animated: true)
    }

    
    func clearAllSelections() {
        calendar.selectedDates.forEach { calendar.deselect($0) }
        startDate = nil
        endDate = nil
        calendar.reloadData()
        numberOfDaysLabel.text = ""
    }
}
 
extension CalenderVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    // Implement minimumDateForCalendar delegate method
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date() // Set minimum date to today
    }
    
    // Prevent selection of past dates
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let selectedDate = Calendar.current.startOfDay(for: date)
        return selectedDate >= today
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // Additional validation to ensure date is not in the past
        let today = Calendar.current.startOfDay(for: Date())
        let selectedDate = Calendar.current.startOfDay(for: date)
        
        if selectedDate < today {
            calendar.deselect(date)
            return
        }
        
        // Handle selection logic
        if startDate == nil {
            // First selection - set start date
            startDate = date
            endDate = nil // Clear end date if exists
        } else if let start = startDate, endDate == nil {
            // Second selection - handle end date
            if Calendar.current.isDate(date, inSameDayAs: start) {
                // Same date selected - set as both start and end
                endDate = date
                updateCalendarSelection()
            } else if date < start {
                // If selected date is before start date, swap them
                endDate = start
                startDate = date
                updateCalendarSelection()
            } else {
                // Normal case - selected date is after start date
                endDate = date
                updateCalendarSelection()
            }
        } else if let start = startDate, let end = endDate {
            // We have a complete range, user is selecting a new date
            // Clear old range and start new selection
            clearAllSelections()
            startDate = date
            calendar.select(date)
        }
        
        updateNumberOfDaysLabel()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // Handle deselection - if any date in the range is deselected, clear the entire range
        if startDate != nil || endDate != nil {
            clearAllSelections()
        }
        
        updateNumberOfDaysLabel()
    }
    
    func updateCalendarSelection() {
        guard let start = startDate, let end = endDate else { return }
        
        // Clear all selections
        calendar.selectedDates.forEach { calendar.deselect($0) }
        
        // Select all dates in the range
        var current = start
        while current <= end {
            calendar.select(current)
            guard let next = Calendar.current.date(byAdding: .day, value: 1, to: current) else { break }
            current = next
        }
        
        calendar.reloadData()
    }
    
    func updateNumberOfDaysLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE dd MMM"
        
        if let start = startDate, let end = endDate {
            let nights = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
            
            let startText = formatter.string(from: start)
            let endText = formatter.string(from: end)
            
            if nights == 0 {
                // Same date for check-in and checkout
                numberOfDaysLabel.text = "\(startText) - \(endText) • 1 night"
            } else if nights == 1 {
                numberOfDaysLabel.text = "\(startText) - \(endText) • \(nights) night"
            } else {
                numberOfDaysLabel.text = "\(startText) - \(endText) • \(nights) nights"
            }
        } else if let start = startDate {
            let startText = formatter.string(from: start)
            numberOfDaysLabel.text = "\(startText) - \(startText) • 1 night"
        } else {
            numberOfDaysLabel.text = ""
        }
    }
    
    // Style past dates to appear grayed out
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let today = Calendar.current.startOfDay(for: Date())
        let checkDate = Calendar.current.startOfDay(for: date)
        
        if checkDate < today {
            return .lightGray
        }
        return nil
    }
 
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        if let start = startDate, let end = endDate {
            if Calendar.current.isDate(date, inSameDayAs: start) && Calendar.current.isDate(date, inSameDayAs: end) {
                // Same date selected for both - show full color
                return UIColor(hex: "#F09814")
            } else if Calendar.current.isDate(date, inSameDayAs: start) || Calendar.current.isDate(date, inSameDayAs: end) {
                return UIColor(hex: "#F09814") // Original color for start/end dates
            } else if date > start && date < end {
                return UIColor(hex: "#F09814").withAlphaComponent(0.3) // Light version for in-between dates
            }
        } else if let start = startDate, Calendar.current.isDate(date, inSameDayAs: start) {
            return UIColor(hex: "#F09814")
        }
        return nil
    }
 
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        if let start = startDate, let end = endDate {
            if Calendar.current.isDate(date, inSameDayAs: start) && Calendar.current.isDate(date, inSameDayAs: end) {
                return .white
            } else if Calendar.current.isDate(date, inSameDayAs: start) || Calendar.current.isDate(date, inSameDayAs: end) {
                return .white
            } else if date > start && date < end {
                return .black
            }
        } else if let start = startDate, Calendar.current.isDate(date, inSameDayAs: start) {
            return .white
        }
        return nil
    }
}
 
extension CalenderVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectDaysCVC", for: indexPath) as! SelectDaysCVC
        cell.daysLabel.text = days[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * 0.30
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
}
