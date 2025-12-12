//
//  BaseViewController.swift
//  SyriaBookingApp
//  Created by ToqSoft on 04/11/25.

import UIKit

class BaseViewController: UIViewController {
    
    private let networkObserverKey = UUID().uuidString
    var internetCheckTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startInternetCheck()
    }
    
    func startInternetCheck() {
        internetCheckTimer?.invalidate()
        internetCheckTimer = Timer.scheduledTimer(timeInterval: 2.0,
                                                  target: self,
                                                  selector: #selector(checkInternet),
                                                  userInfo: nil,
                                                  repeats: true)
        internetCheckTimer?.tolerance = 2.0
    }
    
    @objc func checkInternet() {
        if !Reachability.isConnectedToNetwork() {
                   internetCheckTimer?.invalidate()
                  showNoInternetConnetionView()
               }
    }
    
    deinit {
        internetCheckTimer?.invalidate()
    }
}
