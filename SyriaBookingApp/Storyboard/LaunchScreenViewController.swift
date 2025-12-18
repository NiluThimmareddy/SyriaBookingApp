////
////  LaunchScreenViewController.swift
////  SyriaBookingApp
////
////  Created by ToqSoft on 12/10/25.
////

import UIKit

class LaunchScreenViewController: UIViewController {
    
    let userViewModel = BookingViewModel()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigateTo()
    }
    
    private func navigateTo() {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        
        if isFirstLaunch {
            // Mark that the app has launched before
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.synchronize()
            
            // Show Splash Screen
            let storyboard = UIStoryboard(name: "SplashScreen", bundle: nil)
            if let splashVC = storyboard.instantiateViewController(withIdentifier: "SplashScreensVC") as? SplashScreensVC {
                splashVC.modalPresentationStyle = .fullScreen
                self.present(splashVC, animated: true, completion: nil)
            }
        } else {
            // Directly go to Home tab
            let user = UserSessionManager.getUser()
            userViewModel.onSuccess = { respose in
                if ((respose.mobile.contains("-Block"))){
                    UserSessionManager.clearUser()
                }
            }
            userViewModel.FetchUserData(id: user?.id)
            
            navigateToHomeTab()
        }
    }
}
