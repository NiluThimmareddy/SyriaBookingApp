//
//  BaseViewController.swift
//  SyriaBookingApp
//  Created by ToqSoft on 04/11/25.

import UIKit

class BaseViewController: UIViewController {
    
    private let networkObserverKey = UUID().uuidString
    private var noInternetVC: NoInternetViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeNetworkChanges()
        initialNetworkCheck()
    }
    
    deinit {
        NetworkMonitor.shared.removeStatusObserver(networkObserverKey)
    }
    
    private func observeNetworkChanges() {
        NetworkMonitor.shared.addStatusObserver(networkObserverKey) { [weak self] isConnected in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if isConnected {
                    // ✅ Internet restored
                    self.dismissNoInternetScreen()
                    self.networkCameBackOnline()
                } else {
                    // 🚫 Internet lost
                    self.showNoInternetScreen()
                }
            }
        }
    }
    
    private func initialNetworkCheck() {
        if !NetworkMonitor.shared.isConnected {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showNoInternetScreen()
            }
        }
    }
    
    func showNoInternetScreen() {
        // Prevent multiple overlays
        guard noInternetVC == nil else { return }
        
        let noInternetVC = NoInternetViewController()
        noInternetVC.modalPresentationStyle = .overFullScreen
        
        noInternetVC.onRetry = { [weak self] in
            guard let self = self else { return }
            print("🔁 Retry tapped")

            if NetworkMonitor.shared.isConnected {
                print("✅ Internet already connected — dismissing")
                self.dismissNoInternetScreen()
                self.networkCameBackOnline()
            } else {
                print("⏳ Waiting for connection after retry...")

                // 🔍 Manual reachability test
                self.checkInternetManually { isReachable in
                    if isReachable {
                        print("✅ Manual check: Internet reachable — dismissing screen")
                        DispatchQueue.main.async {
                            self.dismissNoInternetScreen()
                            self.networkCameBackOnline()
                        }
                    } else {
                        print("❌ Manual check: Still no internet, waiting for NWPathMonitor...")
                        NetworkMonitor.shared.addStatusObserver("RetryObserver") { isConnected in
                            if isConnected {
                                print("✅ Internet restored — dismissing screen")
                                NetworkMonitor.shared.removeStatusObserver("RetryObserver")
                                DispatchQueue.main.async {
                                    self.dismissNoInternetScreen()
                                    self.networkCameBackOnline()
                                }
                            }
                        }
                    }
                }
            }
        }
        
        self.noInternetVC = noInternetVC
        DispatchQueue.main.async {
            self.present(noInternetVC, animated: true)
        }
    }
    
    private func checkInternetManually(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://www.google.com") else {
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
    
    func dismissNoInternetScreen() {
        DispatchQueue.main.async {
            if let vc = self.noInternetVC {
                vc.dismiss(animated: true) {
                    self.noInternetVC = nil
                }
            } else if let presented = self.presentedViewController as? NoInternetViewController {
                presented.dismiss(animated: true)
                self.noInternetVC = nil
            }
        }
    }
    
    /// ✅ Override this in subclasses to refresh data when internet returns
    func networkCameBackOnline() {
        print("🌐 Network back online (BaseViewController default)")
    }
}
