//
//  FilterOptionsViewController.swift
//  HotelBooking
//
//  Created by ToqSoft on 17/06/25.
//

protocol ApplyFilterDelegate {
    func applyFilter(filterdHotels : [Hotel])
}

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
    
    var hotelType : [String]?
    var starRating : [String]?
    var reviewScore : [String]?
   // var FilterHotelCompletion : [Hotel] -> () = { _ in }
    var delegate : ApplyFilterDelegate?
    
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
        applyFilter { result in
            if let delegate = self.delegate {
                delegate.applyFilter(filterdHotels: result)
            }
            
            self.dismiss(animated: true)
        }
    
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
                if title == "All"{
                    for button in hotelTypesButton {
                        button.isSelected = true
                        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
                    }
                }
                selectedOptionsList.append(title)
            } else {
                selectedOptionsList.removeAll { $0 == title }
            }
        }
        
       
        self.hotelType = selectedOptionsList
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
        
      
            if sender.isSelected {
                selectedOptionsList.append("\(sender.tag)")
            } else {
                selectedOptionsList.removeAll { $0 == title }
            }
        
         
        starRating = selectedOptionsList
        
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
        
       
            if sender.isSelected {
                selectedOptionsList.append("\(sender.tag)")
            } else {
                selectedOptionsList.removeAll { $0 == title }
            }
        
        
        reviewScore = selectedOptionsList
        print("Selected options: \(selectedOptionsList)")
    }
    
   

    func applyFilter(completion: @escaping ([Hotel]) -> Void) {
        let filteredHotels = HotelDataMaganer.shared.allHotels.filter { hotel in
            let type = hotel.type.rawValue.lowercased()
            let star = String(hotel.starRating)
            let review = String(hotel.reviewCount)

            
            let typeMatch = hotelType?.isEmpty == false ? hotelType!.contains(type) : true
            let starMatch = starRating?.isEmpty == false ? starRating!.contains(star) : true
            let reviewMatch = reviewScore?.isEmpty == false ? reviewScore!.contains(review) : true

            return typeMatch && starMatch && reviewMatch
        }

        print("Filtered \(filteredHotels.count) hotels out of \(HotelDataMaganer.shared.allHotels.count)")
        completion(filteredHotels)
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
