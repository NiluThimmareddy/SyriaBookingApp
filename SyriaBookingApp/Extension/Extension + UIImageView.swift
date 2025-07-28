//
//  Extension + UIImageView.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 28/07/25.
//

import Foundation

import UIKit

extension UIImageView {
    func loadImage(from urlString: String?, placeholder: UIImage? = UIImage(named: "HotelPlaceholder")) {
        self.image = placeholder
        
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil,
                  let image = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
}
