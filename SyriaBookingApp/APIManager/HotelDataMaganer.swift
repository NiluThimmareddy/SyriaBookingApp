//
//  HotelDataMaganer.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 28/07/25.
//

import Foundation
class HotelDataMaganer {
    static let shared = HotelDataMaganer()
    var recentlyViewedHotelIds =  [String]()
    private init() {
        
        if let savedIDs = UserDefaults.standard.array(forKey: "RecentlyViewedHotelIDs") as? [String] {
            recentlyViewedHotelIds = savedIDs
               }
    }
    
    var allHotels : [Hotel] = []
    
    func addRecentlyViewedHotel(id: String) {
            var ids = recentlyViewedHotelIds
            
            // Remove if already present (to re-insert at top)
            ids.removeAll { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ==
                            id.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            
            // Insert at top
            ids.insert(id, at: 0)
            
            // Keep only last 10
            if ids.count > 10 {
                ids = Array(ids.prefix(10))
            }
            
            // Save back
            recentlyViewedHotelIds = ids
            UserDefaults.standard.set(ids, forKey: "RecentlyViewedHotelIDs")
        }
}
