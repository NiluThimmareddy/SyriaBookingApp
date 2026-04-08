//
//  Extension + Date.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 02/02/26.
//

import Foundation

extension Date {
    static func todayAndTomorrowFormattedRange() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E dd MMM"
        
        let today = Date()
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) else {
            return dateFormatter.string(from: today)
        }
        
        let todayString = dateFormatter.string(from: today)
        let tomorrowString = dateFormatter.string(from: tomorrow)
        
        return "\(todayString) - \(tomorrowString)"
    }
}
