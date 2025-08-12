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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with rooms: Rate) {
        let notes = rooms.notes ?? "No notes"
        roomPriceLabel.text = "$\(rooms.price): \(notes)"
        let imageName = rooms.isSelected ?? false ? "checkmark.square.fill" : "square"
        let configuration = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        checkMarkButton.setImage(image, for: .normal)
        checkMarkButton.tintColor = UIColor.black
        configureQtyDropdown(for: selectRoomsButton, options: ["1","2","3","4","5"])
    }
    
    func configureQtyDropdown(for button:UIButton, options:[String]){
        let actions = options.map { option in
            UIAction(title: option, handler: { [weak button] _ in
                button?.setTitle(option, for: .normal)
            })
        }
        
        let menu = UIMenu(title: "select quantity", options: .displayInline, children: actions)
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
    }
}
