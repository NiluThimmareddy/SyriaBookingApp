//
//  ReachabilityManager.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 04/11/25.

//import Foundation
//import Reachability
//
//class ReachabilityManager {
//    static let shared = ReachabilityManager()
//    private var reachability: Reachability?
//    
//    private init() {
//        setupReachability()
//    }
//    
//    private func setupReachability() {
//        reachability = try? Reachability()
//        
//        reachability?.whenReachable = { _ in
//            NotificationCenter.default.post(name: .reachabilityChanged, object: true)
//        }
//        
//        reachability?.whenUnreachable = { _ in
//            NotificationCenter.default.post(name: .reachabilityChanged, object: false)
//        }
//        
//        do {
//            try reachability?.startNotifier()
//        } catch {
//            print("❌ Unable to start reachability notifier")
//        }
//    }
//    
//    func isConnectedToNetwork() -> Bool {
//        return reachability?.connection != .unavailable
//    }
//}
//
//extension Notification.Name {
//    static let reachabilityChanged = Notification.Name("reachabilityChanged")
//}
