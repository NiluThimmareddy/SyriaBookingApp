//
//  HotelImagesGalleryVC.swift
//  SyriaBookingApp
//  Created by toqsoft on 25/08/25.

import UIKit

class HotelImagesGalleryVC: UIViewController {
    
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var hotelImagesCollectionView: UICollectionView!
    @IBOutlet weak var hotelThumbnailCollectionView: UICollectionView!
    @IBOutlet weak var dismissButton: UIButton!
    
    
    var selectedHotel: Hotel?
    var roomImages: [String] = []
    var initialIndex: Int = 0
    var galleryType: GalleryType = .hotel 
    
    enum GalleryType {
        case hotel
        case room
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let indexPath = IndexPath(item: initialIndex, section: 0)
        hotelImagesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        
        hotelThumbnailCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension HotelImagesGalleryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch galleryType {
        case .hotel:
            return selectedHotel?.images.count ?? 0
        case .room:
            return roomImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageUrlString: String?
        
        switch galleryType {
        case .hotel:
            imageUrlString = selectedHotel?.images[indexPath.row]
        case .room:
            imageUrlString = roomImages[indexPath.row]
        }
        
        guard let imageUrlString = imageUrlString,
              let url = URL(string: imageUrlString) else {
            return UICollectionViewCell()
        }
        
        if collectionView == hotelImagesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelImagesGalleryCVC", for: indexPath) as! HotelImagesGalleryCVC
            downloadImage(from: url) { image in
                DispatchQueue.main.async {
                    cell.hotelImageView.image = image
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelThumbnailImagesCVC", for: indexPath) as! HotelThumbnailImagesCVC
            downloadImage(from: url) { image in
                DispatchQueue.main.async {
                    cell.thumbnailImgView.image = image
                }
            }
            return cell
        }
    }
    
    // Rest of the collection view methods remain the same...
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == hotelImagesCollectionView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            let thumbnailSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 100 : 60
            return CGSize(width: thumbnailSize, height: thumbnailSize)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == hotelThumbnailCollectionView {
            hotelImagesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            hotelThumbnailCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        syncThumbnailSelectionWithMainGallery()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        syncThumbnailSelectionWithMainGallery()
    }
    
    func syncThumbnailSelectionWithMainGallery() {
        let center = CGPoint(
            x: hotelImagesCollectionView.contentOffset.x + (hotelImagesCollectionView.frame.size.width / 2),
            y: hotelImagesCollectionView.frame.size.height / 2
        )
        
        if let indexPath = hotelImagesCollectionView.indexPathForItem(at: center) {
            hotelThumbnailCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            hotelThumbnailCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
}

extension HotelImagesGalleryVC {
    func setUpUI() {
        // Set title based on gallery type
        switch galleryType {
        case .hotel:
            if let hotelName = selectedHotel?.name {
                self.title = hotelName
            }
        case .room:
            self.title = "Room Images"
        }
        
        hotelImagesCollectionView.register(UINib(nibName: "HotelImagesGalleryCVC", bundle: nil), forCellWithReuseIdentifier: "HotelImagesGalleryCVC")
        hotelThumbnailCollectionView.register(UINib(nibName: "HotelThumbnailImagesCVC", bundle: nil), forCellWithReuseIdentifier: "HotelThumbnailImagesCVC")
        
        hotelImagesCollectionView.isPagingEnabled = true
        hotelImagesCollectionView.showsHorizontalScrollIndicator = false
        hotelThumbnailCollectionView.showsHorizontalScrollIndicator = false
        
        hotelThumbnailCollectionView.allowsMultipleSelection = false
        
        if let layout = hotelImagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.estimatedItemSize = .zero
        }
        
        if let layout = hotelThumbnailCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 8
            layout.estimatedItemSize = .zero
        }
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
}

