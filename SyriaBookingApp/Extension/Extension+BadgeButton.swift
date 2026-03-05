////
////  Extension+BadgeButton.swift
////  SyriaBookingApp
////
////  Created by ToqSoft on 19/09/25.
////
//
//import UIKit
//
//class BadgeButton: UIButton {
//    private let badgeLabel = UILabel()
//    
//    var badge: Int = 0 {
//        didSet {
//            DispatchQueue.main.async{
//                self.badgeLabel.text = "\(self.badge)"
//                self.badgeLabel.isHidden = self.badge == 0
//            }
//        }
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.clipsToBounds = false
//        self.layer.masksToBounds = false
//        setupBadge()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupBadge()
//    }
//    
//    //    private func setupBadge() {
//    //        badgeLabel.frame = CGRect(x: 20, y: -5, width: 15, height: 15)
//    //        badgeLabel.backgroundColor = .systemRed
//    //        badgeLabel.textColor = .white
//    //        badgeLabel.font = .systemFont(ofSize: 8, weight: .bold)
//    //        badgeLabel.textAlignment = .center
//    //        badgeLabel.layer.cornerRadius = 7.5
//    //        badgeLabel.clipsToBounds = true
//    //        badgeLabel.isHidden = true
//    //        addSubview(badgeLabel)
//    //    }
//    //}
// 
//    private func setupBadge() {
//        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
//        badgeLabel.backgroundColor = .systemRed
//        badgeLabel.textColor = .white
//        badgeLabel.font = .systemFont(ofSize: 9, weight: .bold)
//        badgeLabel.textAlignment = .center
//        badgeLabel.layer.cornerRadius = 8
//        badgeLabel.clipsToBounds = true
//        badgeLabel.isHidden = true
//        
//        addSubview(badgeLabel)
//
//        NSLayoutConstraint.activate([
//            badgeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
//            badgeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 2),
//            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 16),
//            badgeLabel.heightAnchor.constraint(equalToConstant: 16)
//        ])
//    }
//}

import UIKit

final class BadgeButton: UIButton {
    
    // MARK: - UI
    
    private let badgeLabel = UILabel()
    private let badgeBackgroundView = UIView()
    
    // MARK: - Badge Value
    
    var badge: Int = 0 {
        didSet {
            updateBadge()
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
        // Button config
        tintColor = .white
        adjustsImageWhenHighlighted = false
        clipsToBounds = false
        
        // Badge background
        badgeBackgroundView.backgroundColor = .systemRed
        badgeBackgroundView.layer.cornerRadius = 9
        badgeBackgroundView.layer.cornerCurve = .continuous
        badgeBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        badgeBackgroundView.isHidden = true
        
        // Badge label
        badgeLabel.textColor = .white
        badgeLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        badgeLabel.textAlignment = .center
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(badgeBackgroundView)
        badgeBackgroundView.addSubview(badgeLabel)
        
        NSLayoutConstraint.activate([
            
            // Safe inside positioning
            badgeBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            badgeBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            badgeBackgroundView.heightAnchor.constraint(equalToConstant: 18),
            
            badgeBackgroundView.widthAnchor.constraint(greaterThanOrEqualToConstant: 18),
            
            badgeLabel.leadingAnchor.constraint(equalTo: badgeBackgroundView.leadingAnchor, constant: 5),
            badgeLabel.trailingAnchor.constraint(equalTo: badgeBackgroundView.trailingAnchor, constant: -5),
            badgeLabel.topAnchor.constraint(equalTo: badgeBackgroundView.topAnchor),
            badgeLabel.bottomAnchor.constraint(equalTo: badgeBackgroundView.bottomAnchor)
        ])
        
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        
    }
    
    // MARK: - Update Badge
    
    private func updateBadge() {
        DispatchQueue.main.async {
            
            if self.badge <= 0 {
                self.badgeBackgroundView.isHidden = true
                return
            }
            
            self.badgeBackgroundView.isHidden = false
            
            if self.badge > 99 {
                self.badgeLabel.text = "99+"
            } else {
                self.badgeLabel.text = "\(self.badge)"
            }
            
            self.animateBadge()
        }
    }
    
    // MARK: - Animation
    
    private func animateBadge() {
        badgeBackgroundView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: [.curveEaseInOut],
                       animations: {
            self.badgeBackgroundView.transform = .identity
        })
    }
}
