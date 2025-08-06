//
//  OtherGuestVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 08/07/25.
//

import UIKit

class OtherGuestVC: UIViewController {

    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var otherGuestListTV: UITableView!

    var otherGuests: [Guest] = [
        Guest(firstName: "John", lastName: "Doe", dob: "08/10/1990", gender: "Male"),
        Guest(firstName: "Jane", lastName: "Smith", dob: "15/06/1985", gender: "Female")
    ]
    let topNameLbl: UILabel = {
       let label = UILabel()
       label.textColor = .white
       label.text = "Other Travellers"
       label.font = UIFont.poppinsBold(16)
       label.textAlignment = .center
       return label
   }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plusButton.layer.cornerRadius = plusButton.frame.size.height /  2
        otherGuestListTV.register(UINib(nibName: "OtherGuestListTVC", bundle: nil), forCellReuseIdentifier: "OtherGuestListTVC")
        navigationItem.titleView = topNameLbl
    }

    @IBAction func plusButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddNewTravellerVC")as! AddNewTravellerVC
        vc.selectedOption = .add
        vc.delegate = self
        present(vc, animated: true)
    }
    
    
    

}

extension OtherGuestVC: UITableViewDelegate, UITableViewDataSource, OtherGuestListTVCDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherGuests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OtherGuestListTVC")as! OtherGuestListTVC
        let data = otherGuests[indexPath.row]
        cell.nameLbl.text = "\(data.firstName) \(data.lastName)"
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func didTapEditButton(in cell: OtherGuestListTVC) {
        guard let indexPath = otherGuestListTV.indexPath(for: cell) else { return }

        let guest = otherGuests[indexPath.row]
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddNewTravellerVC")as! AddNewTravellerVC
        vc.selectedOption = .edit
        vc.otherGuestsEdit = guest
        vc.guestIndex = indexPath.row
        vc.delegate = self
        present(vc, animated: true)
        

    }

}


extension OtherGuestVC: AddNewTravellerDelegate {
    func didTapDeleteButton(in cell: OtherGuestListTVC) {
        guard let indexPath = otherGuestListTV.indexPath(for: cell) else { return }

        let guest = otherGuests[indexPath.row]
        
       
        let alert = UIAlertController(title: "Delete Guest", message: "Are you sure you want to delete \(guest.firstName) \(guest.lastName)?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
           
            self.otherGuests.remove(at: indexPath.row)
            self.otherGuestListTV.deleteRows(at: [indexPath], with: .fade)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    func didEditGuest(_ guest: Guest, at index: Int) {
        otherGuests[index] = guest
        otherGuestListTV.reloadData()
    }

    func didAddGuest(_ guest: Guest) {
        otherGuests.append(guest)
        otherGuestListTV.reloadData()
    }
}
