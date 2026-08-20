//
//  CommentWebViewController.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 04/08/26.
//

import UIKit
import WebKit

class CommentWebViewController: UIViewController {

    var htmlString = ""
    var showDismissButton: Bool = false

    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        if showDismissButton {
            setupNavigation()
        }

        webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        webView.loadHTMLString(htmlString, baseURL: nil)
    }

    private func setupNavigation() {
        title = "Comments"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeTapped)
        )
    }

    @objc
    private func closeTapped() {
        if let nav = navigationController,
           nav.viewControllers.count > 1 {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}

