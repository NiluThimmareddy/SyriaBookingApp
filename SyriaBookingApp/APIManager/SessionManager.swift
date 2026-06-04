//
//  SessionManager.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 04/06/26.
//

import Foundation
final class SessionManager{
    static let shared = SessionManager()
    private init() {}
    private var logoutTimer: Timer?
    
    //15 minutes
    private let timeout: TimeInterval = 15 * 60
    
    func startSessionTimer(){
        resetTimer()
    }
    
    func resetTimer(){
        logoutTimer?.invalidate()
        
        logoutTimer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false) { _ in
            DispatchQueue.main.async{
                NotificationCenter.default.post(name: .sessionExpired, object: nil)
            }
        }
    }
   
    func stopTimer(){
        logoutTimer?.invalidate()
        logoutTimer = nil
    }
    
    
}

extension Notification.Name{
    static let sessionExpired = Notification.Name("sessionExpired")
}
