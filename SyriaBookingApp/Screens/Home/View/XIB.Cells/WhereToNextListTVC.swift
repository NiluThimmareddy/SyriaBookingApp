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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
}

extension WhereToNextListTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WhereToNextListCVC", for: indexPath) as! WhereToNextListCVC
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 0.75
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
}

extension WhereToNextListTVC {
    func setUpUI() {
        totalHotelCollectionView.register(UINib(nibName: "WhereToNextListCVC", bundle: nil), forCellWithReuseIdentifier: "WhereToNextListCVC")
    }
}
