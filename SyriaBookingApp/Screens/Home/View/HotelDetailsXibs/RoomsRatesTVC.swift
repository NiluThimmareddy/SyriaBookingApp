//
//  RoomsRatesTVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 06/08/25.
//
/*
import UIKit
import SkeletonView

class RoomsRatesTVC : UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var checkMarkButton: UIButton!
    @IBOutlet weak var roomPriceLabel: UILabel!
    @IBOutlet weak var selectRoomsButton: UIButton!
    @IBOutlet weak var roomsTitleLabel: UILabel!
    
    var selectedQty = 1
    var onQuantityChanged: ((Int) -> Void)?
    var onRoomSelected : ((RoomElement) -> Void)?
    var selecteRoomRates = [Rate]()
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        let lang = AppSettings.shared.selectedLanguage
        roomsTitleLabel.text = lang == .arabic ? "الغرف" : "Rooms"
    }
    
    func configure(with selectedRoom: RoomElement, ratesForLocal: Bool, onQuantityChanged: @escaping (Int) -> Void) {
        
        var rooms = selectedRoom.rates[selectRoomsButton.tag]
        let notes = rooms.notes ?? ""
        
        // Format price with two decimal points
        let formattedPrice: String
        let discountText: String
    
        if ratesForLocal {
            if let localPrice = rooms.localPrice {
                formattedPrice = String(format: "%.2f", localPrice)
            } else {
                formattedPrice = "0.00"
            }

            if let localDiscount = rooms.localDiscount, localDiscount > 0 {
                discountText = "\(localDiscount)"
            } else {
                discountText = ""
            }

            // Create attributed string
            let attributedText = NSMutableAttributedString(string: "\(formattedPrice) SYP ", attributes: [
                .foregroundColor: UIColor.label
            ])
            if !discountText.isEmpty {
                let discountAttr = NSAttributedString(string: "(\(discountText)% Discount) ", attributes: [
                    .foregroundColor: UIColor.systemGreen
                ])
                attributedText.append(discountAttr)
            }
            let notesAttr = NSAttributedString(string: notes, attributes: [
                .foregroundColor: UIColor.secondaryLabel
            ])
            attributedText.append(notesAttr)
            roomPriceLabel.attributedText = attributedText

        } else {
           
                formattedPrice = String(format: "%.2f", rooms.price)
            
            if let discount = rooms.discount, discount > 0 {
                discountText = "\(discount)"
            } else {
                discountText = ""
            }

            // Create attributed string
            let attributedText = NSMutableAttributedString(string: "\(formattedPrice)$ ", attributes: [
                .foregroundColor: UIColor.label
            ])
            if !discountText.isEmpty {
                let discountAttr = NSAttributedString(string: "(\(discountText)% Discount) ", attributes: [
                    .foregroundColor: UIColor.systemGreen
                ])
                attributedText.append(discountAttr)
            }
            let notesAttr = NSAttributedString(string: notes, attributes: [
                .foregroundColor: UIColor.secondaryLabel
            ])
            attributedText.append(notesAttr)
            roomPriceLabel.attributedText = attributedText
        }

        // Rest of your code
        self.onQuantityChanged = onQuantityChanged
        let imageName = rooms.isSelected ? "checkmark.square.fill" : "square"

        if rooms.isSelected {
//            rooms.selectedQuantity = selectedQty
            selecteRoomRates.append(rooms)
        }

        let configuration = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        checkMarkButton.setImage(image, for: .normal)
        checkMarkButton.tintColor = .black

        configureQtyDropdown(for: selectRoomsButton, options: ["1", "2", "3", "4", "5"])
        selectRoomsButton.setTitle("\(rooms.selectedQuantity)", for: .normal)
    }
    
    func configureQtyDropdown(for button:UIButton, options:[String]){
        let actions = options.map { option in
            UIAction(title: option, handler: { [weak button] _ in
                if let qty = Int(option) {
                    self.selectedQty = qty
                    
                    self.onQuantityChanged?(qty)
                    
                }
                button?.setTitle(option, for: .normal)
            })
        }
        
        let menu = UIMenu(title: "select quantity", options: .displayInline, children: actions)
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
    }
}
*/

import UIKit
import SkeletonView

class RoomsRatesTVC : UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var checkMarkButton: UIButton!
    @IBOutlet weak var roomPriceLabel: UILabel!
    @IBOutlet weak var selectRoomsButton: UIButton!
    @IBOutlet weak var roomsTitleLabel: UILabel!
    
    var selectedQty = 1
    var onQuantityChanged: ((Int) -> Void)?
    var onRoomSelected : ((RoomElement) -> Void)?
    var selecteRoomRates = [Rate]()
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        let lang = AppSettings.shared.selectedLanguage
        roomsTitleLabel.text = lang == .arabic ? "الغرف" : "Rooms"
    }
    
    func configure(with selectedRoom: RoomElement, ratesForLocal: Bool, onQuantityChanged: @escaping (Int) -> Void) {
        
        var rooms = selectedRoom.rates[selectRoomsButton.tag]
        let notes = rooms.notes ?? ""
        
        // Check if price is zero
        let isPriceZero: Bool
        if ratesForLocal {
            isPriceZero = (rooms.localPrice ?? 0) == 0
        } else {
            isPriceZero = rooms.price == 0
        }
        
        // Format price with two decimal points
        let formattedPrice: String
        let discountText: String
    
        if ratesForLocal {
            if let localPrice = rooms.localPrice {
                formattedPrice = String(format: "%.2f", localPrice)
            } else {
                formattedPrice = "0.00"
            }

            if let localDiscount = rooms.localDiscount, localDiscount > 0 {
                discountText = "\(localDiscount)"
            } else {
                discountText = ""
            }

            // Create attributed string
            let attributedText = NSMutableAttributedString(string: "\(formattedPrice) SYP ", attributes: [
                .foregroundColor: UIColor.label
            ])
            if !discountText.isEmpty {
                let discountAttr = NSAttributedString(string: "(\(discountText)% Discount) ", attributes: [
                    .foregroundColor: UIColor.systemGreen
                ])
                attributedText.append(discountAttr)
            }
            let notesAttr = NSAttributedString(string: notes, attributes: [
                .foregroundColor: UIColor.secondaryLabel
            ])
            attributedText.append(notesAttr)
            roomPriceLabel.attributedText = attributedText

        } else {
            formattedPrice = String(format: "%.2f", rooms.price)
            
            if let discount = rooms.discount, discount > 0 {
                discountText = "\(discount)"
            } else {
                discountText = ""
            }

            // Create attributed string
            let attributedText = NSMutableAttributedString(string: "\(formattedPrice)$ ", attributes: [
                .foregroundColor: UIColor.label
            ])
            if !discountText.isEmpty {
                let discountAttr = NSAttributedString(string: "(\(discountText)% Discount) ", attributes: [
                    .foregroundColor: UIColor.systemGreen
                ])
                attributedText.append(discountAttr)
            }
            let notesAttr = NSAttributedString(string: notes, attributes: [
                .foregroundColor: UIColor.secondaryLabel
            ])
            attributedText.append(notesAttr)
            roomPriceLabel.attributedText = attributedText
        }

        self.onQuantityChanged = onQuantityChanged
        
        // Set checkbox state with alpha based on price
        let imageName = rooms.isSelected ? "checkmark.square.fill" : "square"
        let configuration = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        checkMarkButton.setImage(image, for: .normal)
        checkMarkButton.tintColor = .black
        
        // Apply alpha and disable interaction for zero prices
        let alphaValue: CGFloat = isPriceZero ? 0.3 : 1.0
        checkMarkButton.alpha = alphaValue
        checkMarkButton.isUserInteractionEnabled = !isPriceZero
        
        // Configure quantity dropdown
        configureQtyDropdown(for: selectRoomsButton, options: ["1", "2", "3", "4", "5"])
        selectRoomsButton.setTitle("\(rooms.selectedQuantity)", for: .normal)
        
        // Apply alpha and disable interaction for zero prices
        selectRoomsButton.alpha = alphaValue
        selectRoomsButton.isUserInteractionEnabled = !isPriceZero && UserSessionManager.getUser() != nil
        
        if rooms.isSelected {
            selecteRoomRates.append(rooms)
        }
    }
    
    func configureQtyDropdown(for button:UIButton, options:[String]){
        let actions = options.map { option in
            UIAction(title: option, handler: { [weak button] _ in
                if let qty = Int(option) {
                    self.selectedQty = qty
                    self.onQuantityChanged?(qty)
                }
                button?.setTitle(option, for: .normal)
            })
        }
        
        let menu = UIMenu(title: "select quantity", options: .displayInline, children: actions)
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
    }
}
