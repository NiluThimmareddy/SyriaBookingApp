//
//  NetworkMonitor.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 06/08/25.
//

import Network
import Foundation


import Network

class NetworkMonitor {
   static let shared = NetworkMonitor()
   
   private let monitor = NWPathMonitor()
   private let queue = DispatchQueue(label: "NetworkMonitorQueue")
   private var observers: [String: (Bool) -> Void] = [:]
   
   var isConnected: Bool = true
   
   private init() {
       monitor.pathUpdateHandler = { [weak self] path in
           guard let self = self else { return }
           let connected = path.status == .satisfied
           self.isConnected = connected
           
           // Notify all observers on main thread
           DispatchQueue.main.async {
               for callback in self.observers.values {
                   callback(connected)
               }
           }
       }
       monitor.start(queue: queue)
   }
   
   func addStatusObserver(_ key: String, callback: @escaping (Bool) -> Void) {
       observers[key] = callback
       callback(isConnected)
   }
   
   func removeStatusObserver(_ key: String) {
       observers.removeValue(forKey: key)
   }
}
