//
//  NetworkMonitor.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 06/08/25.
//

import Network
import Foundation

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue.global(qos: .background)
    
    private(set) var isConnected: Bool = false
    var onStatusChange: ((Bool) -> Void)?
    
    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let connected = path.status == .satisfied
            self.isConnected = connected
            self.onStatusChange?(connected)
        }
        monitor.start(queue: queue)
    }

    func isReachable() -> Bool {
        return isConnected
    }
}

