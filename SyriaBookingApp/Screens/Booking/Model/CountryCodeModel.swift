//
//  CountryModel.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 26/08/25.
//

import Foundation

struct CountryModel : Codable{
    let name: String
    let country_code: String
    let arabic_name: String?
    let code: String
    let min_length: Int
    let max_length: Int
    let flag : String
}
