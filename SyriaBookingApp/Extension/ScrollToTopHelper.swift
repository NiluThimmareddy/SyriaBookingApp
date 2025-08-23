//
//  ScrollToTopHelper.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 24/08/25.
//

import Foundation
import UIKit

protocol ScrollToTopCapable: AnyObject {
    
    var scrolleView: UIScrollView { get }
    var scrollToTopButton: UIButton { get }
}

class ScrollToTopHelper: NSObject, UIScrollViewDelegate {
    weak var parent: (UIViewController & ScrollToTopCapable)?

    init(parent: UIViewController & ScrollToTopCapable) {
        self.parent = parent
        super.init()
        setupButton()
      //parent.tableView.delegate = self
    }

    private func setupButton() {
        guard let vc = parent else { return }
        let btn = vc.scrollToTopButton
        btn.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .default)
        btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        btn.alpha = 0
        btn.isHidden = true
        btn.tintColor = .white
        
        btn.backgroundColor = UIColor(named: "blackColor") ?? .label
        btn.cornerRadius =  25
        
        btn.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        vc.view.addSubview(btn)
        
        NSLayoutConstraint.activate([
            btn.widthAnchor.constraint(equalToConstant: 50),
            btn.heightAnchor.constraint(equalTo: btn.widthAnchor),
            btn.trailingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            btn.bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
        
        
    }
    
    @objc private func didTapButton() {
        guard let table = parent?.scrolleView else {
            print("⚠️ tableView is nil")
            return
        }
        table.scrollToTop()
        hideButton()
        
    }


    private func showButton() {
        guard let btn = parent?.scrollToTopButton, btn.isHidden else { return }
        btn.isHidden = false
        UIView.animate(withDuration: 0.3) { btn.alpha = 1 }
    }
    private func hideButton() {
        guard let btn = parent?.scrollToTopButton, !btn.isHidden else { return }
        UIView.animate(withDuration: 0.3, animations: { btn.alpha = 0 }) { _ in btn.isHidden = true }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let vc = parent else { return }
        let shouldShow = scrollView.contentOffset.y > vc.view.bounds.height / 2
        shouldShow ? showButton() : hideButton()
    }
}


extension UIScrollView {
    
    /**
     Scrolls to the top. If the scroll view happens to be a table view, we try scrolling to the (0, 0)
     index path, and otherwise we just set the content offset directly.
     */
    public func scrollToTop() {
        if let tableView = self as? UITableView,
           tableView.numberOfSections > 0 && tableView.numberOfRows(inSection: 0) > 0 {
            tableView.scrollToRow(at: .init(row: 0, section: 0), at: .top, animated: true)
        } else {
            self.setContentOffset(CGPoint(x: 0.0, y: -self.contentInset.top), animated: true)
        }
    }
}

