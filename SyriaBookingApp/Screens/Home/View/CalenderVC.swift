//
//  CalenderVC.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 02/02/26.
//

import UIKit
import FSCalendar

protocol CalenderVCDelegate: AnyObject {
    func didSelectDateRange(_ dateRangeText: String)
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
        
        bottomView.applyCardStyle()
        
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
        calendar.appearance.selectionColor = .clear

        insideView.addSubview(calendar)

        NSLayoutConstraint.activate([
            calendar.leadingAnchor.constraint(equalTo: insideView.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: insideView.trailingAnchor),
            calendar.topAnchor.constraint(equalTo: insideView.topAnchor),
            calendar.bottomAnchor.constraint(equalTo: insideView.bottomAnchor)
        ])
    }

    @IBAction func selectDatesButtonAction(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE dd MMM"

        if let start = startDate, let end = endDate {
            let startText = formatter.string(from: start)
            let endText = formatter.string(from: end)
            
            let calendar = Calendar.current
            let numberOfNights = calendar.dateComponents([.day], from: start, to: end).day ?? 0
            
            let dateRangeText: String
            if numberOfNights == 1 {
                dateRangeText = "\(startText) - \(endText) • \(numberOfNights) night"
            } else {
                dateRangeText = "\(startText) - \(endText) • \(numberOfNights) nights"
            }
            
            delegate?.didSelectDateRange(dateRangeText)
        } else if let start = startDate {
            let startText = formatter.string(from: start)
            delegate?.didSelectDateRange(startText)
        } else {
            let defaultDateRange = Date.todayAndTomorrowFormattedRange()
            delegate?.didSelectDateRange(defaultDateRange)
        }

        dismiss(animated: true)
    }

}

extension CalenderVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if startDate == nil {
            startDate = date
        } else if let start = startDate, endDate == nil {
            if date < start {
                endDate = start
                startDate = date
            } else {
                endDate = date
            }
            
            if let start = startDate, let end = endDate {
                calendar.selectedDates.forEach { calendar.deselect($0) }
                var current = start
                while current <= end {
                    calendar.select(current)
                    guard let next = Calendar.current.date(byAdding: .day, value: 1, to: current) else { break }
                    current = next
                }
            }
        } else {
            calendar.selectedDates.forEach { calendar.deselect($0) }
            startDate = date
            endDate = nil
            calendar.select(date)
        }

        calendar.reloadData()

        if let start = startDate, let end = endDate {
            let nights = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM"
            numberOfDaysLabel.text = "\(formatter.string(from: start)) - \(formatter.string(from: end)) (\(nights) nights)"
        } else {
            numberOfDaysLabel.text = ""
        }
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        if let start = startDate, let end = endDate {
            if Calendar.current.isDate(date, inSameDayAs: start) || Calendar.current.isDate(date, inSameDayAs: end) {
                return UIColor(hex: "#F09814")
            } else if date > start && date < end {
                return UIColor.systemGray4
            }
        } else if let start = startDate, Calendar.current.isDate(date, inSameDayAs: start) {
            return UIColor(hex: "#F09814")
        }
        return nil
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        if let start = startDate, let end = endDate {
            if Calendar.current.isDate(date, inSameDayAs: start) || Calendar.current.isDate(date, inSameDayAs: end) {
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

