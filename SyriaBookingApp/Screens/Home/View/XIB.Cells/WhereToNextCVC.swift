

import UIKit

class WhereToNextCVC : UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var popularPlaceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hotelImageView.clipsToBounds = true
    }
    
    func configure(with hotel: WhereToNextList) {
        popularPlaceLabel.text = "\(hotel.City)"
        hotelImageView.loadImage(from: hotel.image)
    }
    
}
