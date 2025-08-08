//
//  FilterOptionsViewController.swift
//  HotelBooking
//
//  Created by ToqSoft on 17/06/25.
//


protocol ApplyFilterDelegate {
    func applyFilter(filterdHotels: [Hotel])
}

import UIKit

class FilterOptionsViewController: UIViewController {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var filterPriceView: UIView!
    @IBOutlet weak var priceRangeSlider: RangeSeekSlider!
    @IBOutlet var hotelTypesButton: [UIButton]!
    @IBOutlet var starRatingsButton: [UIButton]!
    @IBOutlet var reviewScoreButton: [UIButton]!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var seeResultButton: UIButton!
    
    var hotelType: [String]?
    var starRating: [String]?
    var reviewScore: [String]?
    
    var delegate: ApplyFilterDelegate?
    
    var selectedHotelTypes: [String] = []
    var selectedStarRatings: [String] = []
    var selectedReviewScores: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clearButtonAction(_ sender: Any) {
        selectedHotelTypes.removeAll()
        selectedStarRatings.removeAll()
        selectedReviewScores.removeAll()
        setUpUI()
    }
    
    @IBAction func seeResultButtonAction(_ sender: Any) {
        applyFilter { result, message in
            if result.isEmpty, let message = message {
                let alert = UIAlertController(title: "No Results", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            } else {
                self.delegate?.applyFilter(filterdHotels: result)
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func hotelTypeButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateButtonUI(sender)

        if let title = sender.titleLabel?.text {
            let lowerTitle = title.lowercased()
            
            if lowerTitle == "all" {
                if sender.isSelected {
                    selectedHotelTypes = hotelTypesButton.compactMap { $0.titleLabel?.text?.lowercased() }
                    hotelTypesButton.forEach {
                        $0.isSelected = true
                        $0.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
                    }
                } else {
                    selectedHotelTypes.removeAll()
                    hotelTypesButton.forEach {
                        $0.isSelected = false
                        $0.setImage(UIImage(systemName: "square"), for: .normal)
                    }
                }
            } else {
                if sender.isSelected {
                    selectedHotelTypes.append(lowerTitle)
                } else {
                    selectedHotelTypes.removeAll { $0 == lowerTitle }
                }

                if selectedHotelTypes.contains("all") {
                    selectedHotelTypes.removeAll { $0 == "all" }
                    if let allButton = hotelTypesButton.first(where: { $0.titleLabel?.text?.lowercased() == "all" }) {
                        allButton.isSelected = false
                        allButton.setImage(UIImage(systemName: "square"), for: .normal)
                    }
                }
            }
        }

        hotelType = selectedHotelTypes
        print("Selected Hotel Types: \(selectedHotelTypes)")
    }

    
    @IBAction func starRatingsButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateButtonUI(sender)
        
        let value = "\(sender.tag)"
        if sender.isSelected {
            selectedStarRatings.append(value)
        } else {
            selectedStarRatings.removeAll { $0 == value }
        }
        
        starRating = selectedStarRatings
        print("Selected Star Ratings: \(selectedStarRatings)")
    }
    
    @IBAction func reviewScoreButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateButtonUI(sender)
        
        let value = "\(sender.tag)"
        if sender.isSelected {
            selectedReviewScores.append(value)
        } else {
            selectedReviewScores.removeAll { $0 == value }
        }
        
        reviewScore = selectedReviewScores
        print("Selected Review Scores: \(selectedReviewScores)")
    }
    
    func parsePrice(_ priceString: String?) -> Float {
        guard let str = priceString else { return 0.0 }
        let cleaned = str.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
        return Float(cleaned) ?? 0.0
    }

    
    func applyFilter(completion: @escaping ([Hotel], String?) -> Void) {
        let minPrice = Float(priceRangeSlider.selectedMinValue)
        let maxPrice = Float(priceRangeSlider.selectedMaxValue)

        let filteredHotels = HotelDataMaganer.shared.allHotels.filter { hotel in
            let type = hotel.type.rawValue.lowercased()
            let star = String(hotel.starRating)
            let averageRating = Float(hotel.averageRating) ?? 0.0
            let price = parsePrice(hotel.minRoomPrice)

            let typeMatch = selectedHotelTypes.isEmpty ? true : selectedHotelTypes.contains(type)
            let starMatch = selectedStarRatings.isEmpty ? true : selectedStarRatings.contains(star)

            
            let reviewMatch: Bool
            if selectedReviewScores.isEmpty {
                reviewMatch = true
            } else {
                reviewMatch = selectedReviewScores.contains { scoreStr in
                    guard let score = Int(scoreStr) else { return false }
                    let lowerBound = Float(score)
                    let upperBound = lowerBound + 1.0
                    return averageRating >= lowerBound && averageRating < upperBound
                    
                    
                }
            }

            let priceMatch = (price >= minPrice && price <= maxPrice)
            return typeMatch && starMatch && reviewMatch && priceMatch
        }

        var message: String? = nil

        if filteredHotels.isEmpty {
            if !selectedHotelTypes.isEmpty {
                message = "No \(selectedHotelTypes.map { $0.capitalized }.joined(separator: ", ")) found."
            } else if !selectedStarRatings.isEmpty {
                message = "No hotels with star rating(s) \(selectedStarRatings.joined(separator: ", ")) found."
            } else if !selectedReviewScores.isEmpty {
                message = "No hotels with review scores \(selectedReviewScores.joined(separator: ", ")) found."
            } else {
                message = "No hotels found for the selected criteria."
            }
        }

        completion(filteredHotels, message)
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
    
    func updateButtonUI(_ sender: UIButton) {
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
                    imageView.transform = .identity
                },
                completion: nil
            )
        }
    }
}

