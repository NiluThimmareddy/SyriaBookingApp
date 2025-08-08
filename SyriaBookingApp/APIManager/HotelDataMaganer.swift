//
//  HotelDataMaganer.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 28/07/25.
//

import Foundation
class HotelDataMaganer {
    static let shared = HotelDataMaganer()
    var RecentlyViewdHotelIds =  [UserDefaults()]
    private init() {}
    
    var allHotels : [Hotel] = []
}
