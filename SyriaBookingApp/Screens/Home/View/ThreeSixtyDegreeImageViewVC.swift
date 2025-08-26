//
//  ThreeSixtyDegreeImageViewVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 26/08/25.
//

/*
import UIKit

class ThreeSixtyDegreeImageViewVC : UIViewController {

    var imageURLString: String?

    private let imageView = UIImageView()
    private var panStartX: CGFloat = 0
    private var imageStartOffset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupImageView()
        loadImage()
        addPanGesture()
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = view.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(imageView)
    }

    private func loadImage() {
        guard let urlString = imageURLString, let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self.imageView.image = image

                let multiplier: CGFloat = 2.5
                let newWidth = self.view.bounds.width * multiplier
                self.imageView.frame = CGRect(x: 0, y: 0, width: newWidth, height: self.view.bounds.height)
            }
        }.resume()
    }

    private func addPanGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(pan)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        if gesture.state == .began {
            panStartX = translation.x
            imageStartOffset = imageView.frame.origin.x
        } else if gesture.state == .changed {
            let deltaX = translation.x - panStartX
            var newX = imageStartOffset + deltaX

            // Clamp so it doesn’t scroll infinitely
            let maxOffset = CGFloat(0)
            let minOffset = view.bounds.width - imageView.frame.width
            newX = max(min(newX, maxOffset), minOffset)

            imageView.frame.origin.x = newX
        }
    }
}
*/


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
