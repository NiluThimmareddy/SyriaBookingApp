//
//  HotelDataMaganer.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 28/07/25.
//

import Foundation

class HotelDataMaganer {
    static let shared = HotelDataMaganer()
    var recentlyViewedHotelIds: [String: Date] = [:]
    
    private init() {
        // Load from UserDefaults
        if let savedDict = UserDefaults.standard.dictionary(forKey: "RecentlyViewedHotelIDs") as? [String: TimeInterval] {
            recentlyViewedHotelIds = savedDict.mapValues { Date(timeIntervalSince1970: $0) }
        }
    }
    
    var allHotels: [Hotel] = []
    
    func addRecentlyViewedHotel(id: String) {
        // Update the timestamp for this hotel
        recentlyViewedHotelIds[id] = Date()
        saveRecentlyViewedHotels()
        
        // Post notification to update UI immediately
        NotificationCenter.default.post(name: .recentlyViewedUpdated, object: nil)
    }
    
    func saveRecentlyViewedHotels() {
        // Convert Date to TimeInterval for UserDefaults storage
        let dictToSave = recentlyViewedHotelIds.mapValues { $0.timeIntervalSince1970 }
        UserDefaults.standard.set(dictToSave, forKey: "RecentlyViewedHotelIDs")
    }
    
    func clearAllRecentlyViewedHotels() {
        recentlyViewedHotelIds.removeAll()
        saveRecentlyViewedHotels()
        NotificationCenter.default.post(name: .recentlyViewedUpdated, object: nil)
    }
    
    func clearTodaysRecentlyViewedHotels() {
        let today = Date()
        recentlyViewedHotelIds = recentlyViewedHotelIds.filter { entry in
            !Calendar.current.isDate(entry.value, inSameDayAs: today)
        }
        saveRecentlyViewedHotels()
        NotificationCenter.default.post(name: .recentlyViewedUpdated, object: nil)
    }
    
    func clearEarlierRecentlyViewedHotels() {
        let today = Date()
        recentlyViewedHotelIds = recentlyViewedHotelIds.filter { entry in
            Calendar.current.isDate(entry.value, inSameDayAs: today)
        }
        saveRecentlyViewedHotels()
        NotificationCenter.default.post(name: .recentlyViewedUpdated, object: nil)
    }
    
    func getRecentlyViewedHotelIds() -> [String: Date] {
        return recentlyViewedHotelIds
    }
    
    func getRecentlyViewedHotelDate(hotelId: String) -> Date? {
        return recentlyViewedHotelIds[hotelId]
    }
    
    func getAllRecentlyViewedHotels() -> [Hotel] {
        let sortedIds = recentlyViewedHotelIds.sorted { $0.value > $1.value }.map { $0.key }
        let viewedHotels = allHotels.filter { sortedIds.contains($0.id) }
        let sortedHotels = viewedHotels.sorted {
            guard let date1 = recentlyViewedHotelIds[$0.id],
                  let date2 = recentlyViewedHotelIds[$1.id] else { return false }
            return date1 > date2
        }
        
        return sortedHotels
    }
}
