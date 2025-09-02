//
//  Language.swift
//  SyriaBookingApp
//
//  Created by Yarramsetti Yedukondalu on 28/08/25.
//

import Foundation
enum Languages: String {
    case english = "en"
    case arabic = "ar"
}

class AppSettings {
    static let shared = AppSettings()
    
    private let languageKey = "selectedLanguage"
    
    var selectedLanguage: Languages {
        get {
            if let saved = UserDefaults.standard.string(forKey: languageKey),
               let lang = Languages(rawValue: saved) {
                return lang
            }
            return .english // default language
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: languageKey)
            NotificationCenter.default.post(name: .languageChanged, object: nil)
        }
    }
    
    
    
}

//extension Notification.Name {
//    static let languageChanged = Notification.Name("languageChanged")
//}
