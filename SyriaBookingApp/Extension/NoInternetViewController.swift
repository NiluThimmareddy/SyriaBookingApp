//
//  NoInternetViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 04/11/25.


import UIKit
import Lottie

class NoInternetViewController: UIViewController {
    
    var onRetry: (() -> Void)?
    private var animationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        animationView = LottieAnimationView(name: "no_internet_connection")
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.clipsToBounds = false
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.play()
        
        let label = UILabel()
        label.text = "No Internet Connection"
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let retryButton = UIButton(type: .system)
        retryButton.setTitle("Retry", for: .normal)
        retryButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        view.addSubview(label)
        view.addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            animationView.widthAnchor.constraint(equalToConstant: 300),
            animationView.heightAnchor.constraint(equalToConstant: 300),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: animationView.bottomAnchor),
            
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 25)
        ])
    }
    
    @objc private func retryTapped() {
        onRetry?()
    }
}


