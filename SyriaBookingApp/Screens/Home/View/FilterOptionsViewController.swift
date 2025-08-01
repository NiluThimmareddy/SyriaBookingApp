//
//  FilterOptionsViewController.swift
//  HotelBooking
//
//  Created by ToqSoft on 17/06/25.
//


import UIKit

class FilterOptionsViewController : UIViewController {
 
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var filterPriceView: UIView!
    @IBOutlet weak var priceRangeSlider: RangeSeekSlider!
    @IBOutlet var hotelTypesButton: [UIButton]!
    @IBOutlet var starRatingsButton: [UIButton]!
    @IBOutlet var reviewScoreButton: [UIButton]!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var seeResultButton: UIButton!
    
    
    var selectedOptionsList : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clearButtonAction(_ sender: Any) {
        setUpUI()
    }
    
    @IBAction func seeResultButtonAction(_ sender: Any) {
    }
    
    @IBAction func hotelTypeButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        let imageName = sender.isSelected ? "checkmark.square.fill" : "square"
        sender.setImage(UIImage(systemName: imageName)?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.label), for: .normal)
        
        sender.setTitleColor(.black, for: .normal)
        
        if let imageView = sender.imageView {
            
            imageView.tintColor = .systemGreen
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 0.6,
                options: .curveEaseOut,
                animations: {
                    imageView.transform = CGAffineTransform.identity
                },
                completion: nil
            )
        }
        
        if let title = sender.titleLabel?.text {
            if sender.isSelected {
                selectedOptionsList.append(title)
            } else {
                selectedOptionsList.removeAll { $0 == title }
            }
        }
        
        print("Selected options: \(selectedOptionsList)")
    }
    
    @IBAction func starRatingsButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        let imageName = sender.isSelected ? "checkmark.square.fill" : "square"
        sender.setImage(UIImage(systemName: imageName)?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.label), for: .normal)
        
        sender.setTitleColor(.black, for: .normal)
        
        if let imageView = sender.imageView {
            
            imageView.tintColor = .systemGreen
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 0.6,
                options: .curveEaseOut,
                animations: {
                    imageView.transform = CGAffineTransform.identity
                },
                completion: nil
            )
        }
        
        if let title = sender.titleLabel?.text {
            if sender.isSelected {
                selectedOptionsList.append(title)
            } else {
                selectedOptionsList.removeAll { $0 == title }
            }
        }
        
        print("Selected options: \(selectedOptionsList)")
    }
    
    @IBAction func reviewScoreButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        let imageName = sender.isSelected ? "checkmark.square.fill" : "square"
        sender.setImage(UIImage(systemName: imageName)?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.label), for: .normal)
        
        sender.setTitleColor(.black, for: .normal)
        
        if let imageView = sender.imageView {
            
            imageView.tintColor = .systemGreen
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 0.6,
                options: .curveEaseOut,
                animations: {
                    imageView.transform = CGAffineTransform.identity
                },
                completion: nil
            )
        }
        
        if let title = sender.titleLabel?.text {
            if sender.isSelected {
                selectedOptionsList.append(title)
            } else {
                selectedOptionsList.removeAll { $0 == title }
            }
        }
        print("Selected options: \(selectedOptionsList)")
    }
    
}

extension FilterOptionsViewController {
    func setUpUI() {
        
        bottomView.addTopShadow()
        
        for button in hotelTypesButton {
            button.isSelected = false
            button.setImage(UIImage(systemName: "square"), for: .normal)
        }
        
        for button in starRatingsButton {
            button.isSelected = false
            button.setImage(UIImage(systemName: "square"), for: .normal)
        }
        
        for button in reviewScoreButton {
            button.isSelected = false
            button.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
}
