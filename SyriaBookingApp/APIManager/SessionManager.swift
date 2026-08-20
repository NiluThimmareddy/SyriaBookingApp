//
//  SessionManager.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 17/07/26.
//
import Foundation

@MainActor
final class SessionManager: ObservableObject {
    static let shared = SessionManager()
    @Published private(set) var isAuthenticated = false
    @Published var sessionExpiredMessage: String?
    
    func markAuthenticated() {
        isAuthenticated = true
        sessionExpiredMessage = nil
    }
    func forceLogout() {
        isAuthenticated = false
        sessionExpiredMessage =
        "Your session has expired. Please log in again."
    }
}


