//
//  CommentManager.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 04/08/26.
//

import UIKit
final class CommentManager {
    
    static let shared = CommentManager()
    private(set) var hasStarted = false
    let viewmodel = CommentViewModel()
    
    private init() {}
    
    func start() {        
        guard !hasStarted else { return }
        hasStarted = true
        checkAPI()
    }
    
    private func checkAPI() {
        guard !WebViewManager.shared.isShowing else {
            return
        }
        
        viewmodel.fetchComment { result in
            switch result {
            case .success(let responses):
                // Find the object whose active = "yes"
                guard let comment = responses.first(where: {
                    $0.active.lowercased() == "yes"
                }) else {
                    return
                }
                
                // If HTML is empty, don't show WebView
                guard !comment.html.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    return
                }
                
                switch comment.id {
                case 0:
                    // Don't show WebView
                    return
                    
                case 2:
                    // Show without close button
                    WebViewManager.shared.show(
                        html: comment.html,
                        dismissHandler: false
                    )
                    
                case 3:
                    // Show with close button
                    WebViewManager.shared.show(
                        html: comment.html,
                        dismissHandler: true
                    )
                    
                default:
                    break
                }
                
            case .failure(_):
               print("Error...")
            }
        }
    }
}

