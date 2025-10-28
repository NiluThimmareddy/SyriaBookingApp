//
//  WhereToNextListTVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 17/10/25.
//

import UIKit

class WhereToNextListTVC: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hotelImgView: UIImageView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var totalHotelsAvailableLabel: UILabel!
    @IBOutlet weak var totalHotelCollectionView: UICollectionView!
    
    var city: WhereToNextList?
    var hotels: [Hotel] = []
    var selectedLanguage: Languages = .english
    var onHotelSelected: ((Hotel) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backView.applyCardStyle()
    }
    
    func configure(with city: WhereToNextList, hotels: [Hotel], language: Languages) {
        self.city = city
        self.hotels = hotels
        self.selectedLanguage = language
        
        updateUI()
        totalHotelCollectionView.reloadData()
    }
    
    private func updateUI() {
        guard let city = city else { return }
        
        if let imageUrlString = city.image as? String,
           let url = URL(string: imageUrlString) {
            loadImageFromURL(url)
        } else if !city.image.isEmpty {
            hotelImgView.image = UIImage(named: city.image)
        } else {
            hotelImgView.image = UIImage(named: "city_placeholder")
        }
        
        let cityName = selectedLanguage == .english ? city.City : city.Cityar
        hotelNameLabel.text = cityName
        
        let hotelsCount = hotels.count
        if selectedLanguage == .english {
            totalHotelsAvailableLabel.text = "\(hotelsCount) hotels available"
        } else {
            totalHotelsAvailableLabel.text = "\(hotelsCount) فندق متاح"
        }
    }
    
    private func loadImageFromURL(_ url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  error == nil,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.hotelImgView.image = UIImage(named: "city_placeholder")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.hotelImgView.image = image
            }
        }.resume()
    }
}

// MARK: - Collection View Methods
extension WhereToNextListTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hotels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WhereToNextListCVC", for: indexPath) as! WhereToNextListCVC
        
        if indexPath.row < hotels.count {
            let hotel = hotels[indexPath.row]
            cell.configure(with: hotel, language: selectedLanguage)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        let widthMultiplier: CGFloat = isIpad ? 0.4 : 0.75
        let width = collectionView.bounds.width * widthMultiplier
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < hotels.count {
            let selectedHotel = hotels[indexPath.row]
            onHotelSelected?(selectedHotel)
        }
    }
    
}

// MARK: - Setup Methods
extension WhereToNextListTVC {
    func setUpUI() {
        totalHotelCollectionView.register(UINib(nibName: "WhereToNextListCVC", bundle: nil), forCellWithReuseIdentifier: "WhereToNextListCVC")
        totalHotelCollectionView.delegate = self
        totalHotelCollectionView.dataSource = self
        hotelImgView.applyFullLightBlackGradientOverlay()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hotelImgView.image = nil
        hotelNameLabel.text = nil
        totalHotelsAvailableLabel.text = nil
        hotels.removeAll()
        onHotelSelected = nil
    }
}

