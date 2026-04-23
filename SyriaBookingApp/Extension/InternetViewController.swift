//
//  InternetViewController.swift
//  TipTap
//
//  Created by ToqSoft on 14/11/25.


import UIKit
import Network

class InternetViewController: UIViewController {
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var oppsNameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var internetButton: UIButton!
    
    var message = ""
    var internetCheckTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        startInternetCheck()
        
    }
    
    func startInternetCheck() {
        internetCheckTimer?.invalidate()
        internetCheckTimer = Timer.scheduledTimer(timeInterval: 2.0,
                                                  target: self,
                                                  selector: #selector(checkInternet),
                                                  userInfo: nil,
                                                  repeats: true)
        internetCheckTimer?.tolerance = 2.0
    }
    
    @objc func checkInternet() {
        // Your internet check logic
        if Reachability.isConnectedToNetwork() {
            internetCheckTimer?.invalidate()
            self.dismiss(animated: true)
        }
        print("Checking internet from InternetViewController...")
    }
    
    func setUI(){
        internetButton.layer.cornerRadius = 5
        internetButton.clipsToBounds = true
        if let gifURL = Bundle.main.url(forResource: "mIDj6YQwCw", withExtension: "GIF"),
           let gifData = try? Data(contentsOf: gifURL),
           let animatedImage = UIImage.animatedImageess(with: gifData) {
            image.image = animatedImage
        }
    }
    
    @IBAction func tryAgainButton(_ sender: Any) {
        if isInternetAvailable() {
            self.dismiss(animated: true)
        } else {
            showNoInternetAlert()
        }
    }
    
    func isInternetAvailable() -> Bool {
        let monitor = NWPathMonitor()
        var hasInternet = false
        let semaphore = DispatchSemaphore(value: 0)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                hasInternet = true
            }
            semaphore.signal()
        }
        monitor.start(queue: DispatchQueue.global(qos: .userInteractive))
        _ = semaphore.wait(timeout: .now() + 5)
        return hasInternet
    }
    func showNoInternetAlert() {
        let alert = UIAlertController(
            title: "No Internet Connection",
            message: "Please check your internet connection and try again.",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
extension UIImage {
    class func animatedImageess(with gifData: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
            }
        }
        
        let animatedImage = UIImage.animatedImage(with: images, duration: Double(count) * 0.3) // Adjust duration as needed
        return animatedImage
    }
}
