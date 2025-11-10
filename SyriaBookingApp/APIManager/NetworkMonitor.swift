//
//  NetworkMonitor.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 06/08/25.
//


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
        // Immediately notify with current state
        DispatchQueue.main.async {
            callback(self.isConnected)
        }
    }
    
    func removeStatusObserver(_ key: String) {
        observers.removeValue(forKey: key)
    }
}

