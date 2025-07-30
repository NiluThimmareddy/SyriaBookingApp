

import UIKit

class WhereToNextCVC : UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var popularPlaceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hotelImageView.clipsToBounds = true
    }
    
    func configure(with hotel: Hotel) {
        popularPlaceLabel.text = "\(hotel.city)"

        if let firstImageURL = hotel.images.first, !firstImageURL.isEmpty {
            hotelImageView.loadImage(from: firstImageURL)
        } else {
            hotelImageView.loadImage(from: hotel.coverImageURL)
        }
    }
    
}
