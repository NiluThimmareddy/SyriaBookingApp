//
//  HotelExtension.swift
//  SyriaBookingApp
//
//  Created by Yarramsetti Yedukondalu on 01/09/25.
//

import Foundation
extension Hotel {
    func localizedCity() -> String {
        if AppSettings.shared.selectedLanguage == .english {
            return city
        } else {
            return cityAR
        }
    }
    
    func localizedName() -> String {
        if AppSettings.shared.selectedLanguage == .english {
            return name
        } else {
            return nameAR ?? name
        }
    }
    
    func localizedDescription() -> String {
        if AppSettings.shared.selectedLanguage == .english {
            return description ?? ""
        } else {
            return descriptionAR ?? description ?? ""
        }
    }
    
    func localizedShortDescription() -> String {
        if AppSettings.shared.selectedLanguage == .english {
            return shortDescription ?? ""
        } else {
            return shortDescriptionAR ?? shortDescription ?? ""
        }
    }
    
}
extension String {
    static func localizedReviews(count: Int) -> String {
        if AppSettings.shared.selectedLanguage == .english {
            return "\(count) reviews"
        } else {
            return "\(count) مراجعات"
        }
    }
}
