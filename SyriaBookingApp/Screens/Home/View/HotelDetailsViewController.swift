//
//  HomeDetailsViewController.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

 
 import UIKit

 class HotelDetailsViewController : UIViewController {

     @IBOutlet weak var scrollView: UIScrollView!
     @IBOutlet weak var backView: UIView!
     @IBOutlet weak var hotelImagesCollectionView: UICollectionView!
     @IBOutlet weak var reviewView: UIView!
     @IBOutlet weak var averageRatingsLabel: UILabel!
     @IBOutlet weak var hotelNameLabel: UILabel!
     @IBOutlet weak var overView: UIView!
     @IBOutlet weak var overViewButton: UIButton!
     @IBOutlet weak var descriptionLabel: UILabel!
     @IBOutlet weak var descriptionLabelHeightConstraint: NSLayoutConstraint!
     @IBOutlet weak var facilitiesView: UIView!
     @IBOutlet weak var facilitiesButton: UIButton!
     @IBOutlet weak var verticalStackview: UIStackView!
     @IBOutlet weak var horizontalStackView: UIStackView!
     @IBOutlet weak var facilitiesViewHeightConstraint: NSLayoutConstraint!
     @IBOutlet weak var availabilityRoomsView: UIView!
     @IBOutlet weak var availabilityButton: UIButton!
     @IBOutlet weak var roomsAvailabilityCollectionView: UICollectionView!
     @IBOutlet weak var availabilityRoomsViewHeightConstraint: NSLayoutConstraint!
     @IBOutlet weak var roomsCollectionViewHeightConstraint: NSLayoutConstraint!
     @IBOutlet weak var addReviewView: UIView!
     @IBOutlet weak var addReviewViewButton: UIButton!
     @IBOutlet weak var enterYourNameTF: UITextField!
     @IBOutlet weak var selectratingButton: UIButton!
     @IBOutlet weak var reviewTextView: UITextView!
     @IBOutlet weak var submitReviewButton: UIButton!
     @IBOutlet weak var addReviewViewHeightConstraint: NSLayoutConstraint!
     @IBOutlet weak var rateAndReviewsView: UIView!
     @IBOutlet weak var rateAndReviewsLabel: UILabel!
     @IBOutlet weak var rateAndReviewsDownButton: UIButton!
     @IBOutlet weak var rateAndReviewsTableview: UITableView!
     @IBOutlet weak var rateAndReviewsTableviewHeightConstraint: NSLayoutConstraint!
     
     var selectedHotel: Hotel?
     let imageCache = NSCache<NSString, UIImage>()
     
     var isDescriptionVisible = true
     var isFacilitiesVisible = false
     var isAvailabilityVisible = false
     var isAddReviewVisible = true

     var currentHorizontalStack: UIStackView?
     
     override func viewDidLoad() {
         super.viewDidLoad()

         setUpUI()
     }

     override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         updateRateAndReviewsTableHeight()
     }
     
     @IBAction func overViewButtonAction(_ sender: Any) {
         isDescriptionVisible.toggle()
         
         descriptionLabel.isHidden = !isDescriptionVisible
         descriptionLabelHeightConstraint.constant = isDescriptionVisible ? 300 : 40
         
         UIView.animate(withDuration: 0.3) {
             self.view.layoutIfNeeded()
         }
     }
     
     @IBAction func facilitiesButtonAction(_ sender: Any) {
         isFacilitiesVisible.toggle()

         for subview in verticalStackview.arrangedSubviews {
             if let label = subview as? UILabel {
                 continue
             }
             subview.isHidden = !isFacilitiesVisible
         }
         facilitiesViewHeightConstraint.constant = isFacilitiesVisible ? 300 : 40
         UIView.animate(withDuration: 0.3) {
             self.view.layoutIfNeeded()
         }
     }

     @IBAction func availabilityButtonAction(_ sender: Any) {
         isAvailabilityVisible.toggle()
            
            if isAvailabilityVisible {
                updateAvailabilityRoomsViewHeight()
            } else {
                availabilityRoomsViewHeightConstraint.constant = 40
            }

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
     }
     
     @IBAction func addReviewImgButtonAction(_ sender: Any) {
         isAddReviewVisible.toggle()
         
         addReviewViewHeightConstraint.constant = isAddReviewVisible ? 450 : 40
         
         UIView.animate(withDuration: 0.3) {
             self.view.layoutIfNeeded()
         }
     }
     
     @IBAction func submitReviewButtonAction(_ sender: Any) {
     }
     
     @IBAction func rateAndReviewsDownButtonAction(_ sender: Any) {
     }
     
 }

 extension HotelDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if collectionView == hotelImagesCollectionView {
             guard let hotel = selectedHotel else { return 0 }
             let imageCount = hotel.images.count
             return Int(ceil(Double(imageCount) / 5.0))
         } else {
             return selectedHotel?.rooms.count ?? 0
         }
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         if collectionView == hotelImagesCollectionView {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsPageHotelImagesCVC", for: indexPath) as! DetailsPageHotelImagesCVC

             guard let hotel = selectedHotel else { return cell }
             let images = hotel.images
             let startIndex = indexPath.row * 5
             let endIndex = min(startIndex + 5, images.count)
             let imagesToShow = Array(images[startIndex..<endIndex])

             let imageViews = [
                 cell.hotelImageOne,
                 cell.hotelImageTwo,
                 cell.hotelImageThree,
                 cell.hotelImageFour,
                 cell.hotelImageFive
             ]

             for imageView in imageViews {
                 imageView?.image = nil
                 imageView?.stopShimmering()
             }

             cell.countLabel.isHidden = true
             cell.shadowView.isHidden = imagesToShow.count < 5
             cell.shadowViewButton.isHidden = imagesToShow.count < 5

             for (i, imageView) in imageViews.enumerated() {
                 if i < imagesToShow.count {
                     let imageUrl = imagesToShow[i]
                     if let cachedImage = imageCache.object(forKey: imageUrl as NSString) {
                         imageView?.image = cachedImage
                     } else {
                         imageView?.image = nil
                         imageView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
                         imageView?.startPulseShimmer()
                         loadImage(from: imageUrl, into: imageView!) {
                             imageView?.stopShimmering()
                             imageView?.backgroundColor = .clear
                         }
                     }
                 }
             }

             if imagesToShow.count == 5 {
                 let remaining = images.count - (startIndex + 5)
                 if remaining > 0 {
                     cell.countLabel.isHidden = false
                     cell.countLabel.text = "+\(remaining)"
                 }
             }

             return cell
         } else {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailabilityRoomsCVC", for: indexPath) as! AvailabilityRoomsCVC
             let rooms = (selectedHotel?.rooms[indexPath.row])!
             cell.configure(with: rooms)
             return cell
         }
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         if collectionView == hotelImagesCollectionView {
             let totalWidth = collectionView.bounds.width
             return CGSize(width: totalWidth, height: totalWidth * 0.75)
         } else {
             if let room = selectedHotel?.rooms[indexPath.row] {
                 let height = calculateRoomCellHeight(for: room)
                 return CGSize(width: collectionView.frame.width, height: height)
             } else {
                 return CGSize(width: collectionView.frame.width, height: 400)
             }
         }

     }
     
     func loadImage(from urlString: String, into imageView: UIImageView, completion: @escaping () -> Void) {
         guard let url = URL(string: urlString) else {
             completion()
             return
         }

         URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
             DispatchQueue.main.async {
                 guard let data = data, let image = UIImage(data: data), error == nil else {
                     completion()
                     return
                 }

                 self?.imageCache.setObject(image, forKey: urlString as NSString)
                 imageView.image = image
                 completion()
             }
         }.resume()
     }
 }

 extension HotelDetailsViewController : UITableViewDelegate, UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return selectedHotel?.reviews.count ?? 0
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "RateAndReviewsTVC") as! RateAndReviewsTVC
         if let reviews = selectedHotel?.reviews, indexPath.row < reviews.count {
             let review = reviews[indexPath.row]
             cell.configure(with: review)
         }
         return cell
     }
 }

 extension HotelDetailsViewController {
     func setUpUI() {
         
         rateAndReviewsTableview.register(UINib(nibName: "RateAndReviewsTVC", bundle: nil), forCellReuseIdentifier: "RateAndReviewsTVC")
         hotelImagesCollectionView.register(UINib(nibName: "DetailsPageHotelImagesCVC", bundle: nil), forCellWithReuseIdentifier: "DetailsPageHotelImagesCVC")
         hotelImagesCollectionView.reloadData()
         
         roomsAvailabilityCollectionView.register(UINib(nibName: "AvailabilityRoomsCVC", bundle: nil), forCellWithReuseIdentifier: "AvailabilityRoomsCVC")
         if let layouts = roomsAvailabilityCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
             layouts.estimatedItemSize = .zero
         }
         roomsAvailabilityCollectionView.reloadData()
         DispatchQueue.main.async {
             self.updateAvailabilityRoomsViewHeight()
         }
         
         isAvailabilityVisible = false
         availabilityRoomsViewHeightConstraint.constant = 40
         isAddReviewVisible = true
         addReviewViewHeightConstraint.constant = 450

         guard let hotel = selectedHotel else { return }
         let ratingValue = hotel.starRating
         let intRating = Int(ratingValue)
         let hotelNameAttributed = NSMutableAttributedString(
             string: "\(hotel.name) ",
             attributes: [.foregroundColor: UIColor.label]
         )
         let city = hotel.city
         if !city.isEmpty {
             let cityAttributed = NSAttributedString(
                 string: "| \(city)  ",
                 attributes: [.foregroundColor: UIColor.label]
             )
             hotelNameAttributed.append(cityAttributed)
         }
         if intRating > 0 && intRating <= 5 {
             let stars = String(repeating: "★", count: intRating)
             let starAttributed = NSAttributedString(
                 string: stars + " ",
                 attributes: [.foregroundColor: UIColor.black]
             )
             hotelNameAttributed.append(starAttributed)
         }
         hotelNameLabel.attributedText = hotelNameAttributed
         averageRatingsLabel.text = "\(hotel.averageRating) (\(hotel.reviewCount) reviews)"
         descriptionLabel.text = hotel.description
         rateAndReviewsLabel.text = "Rate & Reviews \(hotel.averageRating) (\(hotel.reviewCount) reviews)"
         
         setupAmenities(hotel.amenities)
         
         rateAndReviewsTableview.rowHeight = UITableView.automaticDimension
         rateAndReviewsTableview.estimatedRowHeight = 100
         rateAndReviewsTableview.reloadData()

     }
     
     func setupAmenities(_ amenitiesString: String?) {
         verticalStackview.arrangedSubviews.forEach {
             verticalStackview.removeArrangedSubview($0)
             $0.removeFromSuperview()
         }
         
         guard let amenitiesString = amenitiesString, !amenitiesString.isEmpty else { return }
         
         let amenitiesArray = amenitiesString.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
         
         var currentRow = createHorizontalStack()
         verticalStackview.addArrangedSubview(currentRow)
         var currentRowWidth: CGFloat = 0
         let maxRowWidth = view.frame.width - 40
         
         for amenity in amenitiesArray {
             let label = createAmenityLabel(title: amenity)
             let labelWidth = label.intrinsicContentSize.width + 20
             
             if currentRowWidth + labelWidth > maxRowWidth {
                 currentRow = createHorizontalStack()
                 verticalStackview.addArrangedSubview(currentRow)
                 currentRowWidth = 0
             }
             
             currentRow.addArrangedSubview(label)
             currentRowWidth += labelWidth + currentRow.spacing
         }
     }
     
     func createHorizontalStack() -> UIStackView {
         let stack = UIStackView()
         stack.axis = .horizontal
         stack.spacing = 8
         stack.alignment = .fill
         stack.distribution = .fillProportionally
         return stack
     }
     
     func createAmenityLabel(title: String) -> UILabel {
         let label = UILabel()
         label.text = title
         label.font = UIFont.systemFont(ofSize: 14)
         label.textColor = .black
         label.textAlignment = .center
         label.layer.cornerRadius = 8
         label.layer.borderWidth = 1
         label.layer.borderColor = UIColor.lightGray.cgColor
         label.clipsToBounds = true
         label.backgroundColor = UIColor.systemGray6
         label.setContentHuggingPriority(.required, for: .horizontal)
         label.setContentCompressionResistancePriority(.required, for: .horizontal)
         label.translatesAutoresizingMaskIntoConstraints = false
         label.heightAnchor.constraint(equalToConstant: 40).isActive = true
         return label
     }
     
     func updateAvailabilityRoomsViewHeight() {
         guard let rooms = selectedHotel?.rooms, !rooms.isEmpty else {
             availabilityRoomsViewHeightConstraint.constant = 0
             roomsCollectionViewHeightConstraint.constant = 0
             return
         }

         var totalHeight: CGFloat = 0

         for room in rooms {
             let cellHeight = calculateRoomCellHeight(for: room)
             totalHeight += cellHeight
         }

         availabilityRoomsViewHeightConstraint.constant = totalHeight
         roomsCollectionViewHeightConstraint.constant = totalHeight

         UIView.animate(withDuration: 0.3) {
             self.view.layoutIfNeeded()
         }
     }

     func calculateRoomCellHeight(for room: RoomElement) -> CGFloat {
         let baseHeight: CGFloat = 300
         let rateRowHeight: CGFloat = 40
         let rateCount = room.rates.count
         let tableHeight = CGFloat(rateCount) * rateRowHeight
         let spacing: CGFloat = 10
         return baseHeight + tableHeight + spacing
     }
     
     func updateRateAndReviewsTableHeight() {
         rateAndReviewsTableview.layoutIfNeeded()
         rateAndReviewsTableviewHeightConstraint.constant = rateAndReviewsTableview.contentSize.height

         UIView.animate(withDuration: 0.3) {
             self.view.layoutIfNeeded()
         }
     }
 }



