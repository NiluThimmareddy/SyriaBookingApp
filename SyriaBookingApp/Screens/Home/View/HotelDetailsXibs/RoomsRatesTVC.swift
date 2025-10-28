//
//  RoomsRatesTVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 06/08/25.
//

import UIKit

class RoomsRatesTVC : UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var checkMarkButton: UIButton!
    @IBOutlet weak var roomPriceLabel: UILabel!
    @IBOutlet weak var selectRoomsButton: UIButton!
    
    var selectedQty = 1
    var onQuantityChanged: ((Int) -> Void)?
    var onRoomSelected : ((RoomElement) -> Void)?
    var selecteRoomRates = [Rate]()
   
    override func awakeFromNib() {
        super.awakeFromNib()
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

            if let localDiscount = rooms.localDiscount {
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

            if let discount = rooms.discount{
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
        let imageName = rooms.isSelected ?? false ? "checkmark.square.fill" : "square"

        if rooms.isSelected ?? false {
            selecteRoomRates.append(rooms)
            rooms.selectedQuantity = selectedQty
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
                    self.onQuantityChanged?(qty)
                    self.selectedQty = qty
                }
                button?.setTitle(option, for: .normal)
            })
        }
        
        let menu = UIMenu(title: "select quantity", options: .displayInline, children: actions)
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
    }
}
