//
//  ThreeSixtyDegreeImageViewVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 26/08/25.
//

import UIKit
import CTPanoramaView

class ThreeSixtyDegreeImageViewVC: UIViewController {
    private var panoramaView: CTPanoramaView!
    var imageURLString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupPanoramaView()
        loadPanoramaImage()
    }

    private func setupPanoramaView() {
        panoramaView = CTPanoramaView(frame: view.bounds)
        panoramaView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        panoramaView.controlMethod = .touch
        view.addSubview(panoramaView)
    }

    private func loadPanoramaImage() {
        if let urlString = imageURLString, let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let self = self, let data = data, error == nil,
                      let image = UIImage(data: data) else {
                    print("Failed to load image")
                    return
                }
                DispatchQueue.main.async {
                    self.panoramaView.image = image
                }
            }.resume()
        } else {
            if let localImage = UIImage(named: "yourLocal360Image.jpg") {
                panoramaView.image = localImage
            }
        }
    }
}
