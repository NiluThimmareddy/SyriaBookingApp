//
//  WebViewManager.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 04/08/26.
//

import UIKit

final class WebViewManager {

    static let shared = WebViewManager()

    private init() {}

    private(set) var isShowing = false

    func show(html: String,
              dismissHandler: Bool) {

        guard !isShowing else { return }

        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first,
              let root = window.rootViewController else {
            return
        }

        var top = root
       
        while let presented = top.presentedViewController {
            top = presented
        }

        let vc = CommentWebViewController()
        vc.htmlString = html

        vc.showDismissButton = dismissHandler

        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        isShowing = true

        top.present(nav, animated: true)
    }
}
