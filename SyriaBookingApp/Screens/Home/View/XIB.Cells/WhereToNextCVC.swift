

import UIKit

class WhereToNextCVC : UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var popularPlaceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hotelImageView.clipsToBounds = true
        popularPlaceLabel.font = .captionFont
    }
    
    func configure(with item: WhereToNextList) {
        if AppSettings.shared.selectedLanguage == .english{
            popularPlaceLabel.text = item.City
        } else {
            popularPlaceLabel.text = item.Cityar
        }
        hotelImageView.loadImage(from: item.image)
    }
    
}
