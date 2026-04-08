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
       
    ]
    
    let topNameLbl: UILabel = {
       let label = UILabel()
       label.textColor = .white
       label.font = UIFont.poppinsBold(16)
       label.textAlignment = .center
       return label
   }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add language change notification observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTexts),
            name: .languageChanged,
            object: nil
        )
        
        plusButton.layer.cornerRadius = plusButton.frame.size.height /  2
        otherGuestListTV.register(UINib(nibName: "OtherGuestListTVC", bundle: nil), forCellReuseIdentifier: "OtherGuestListTVC")
        
        // Set navigation title based on language
        updateTexts()
    }
    
    @objc func updateTexts() {
        let lang = AppSettings.shared.selectedLanguage
        
        if lang == .arabic {
            topNameLbl.text = "ضيوف آخرون"
        } else {
            topNameLbl.text = "Other Guest"
        }
        
        navigationItem.titleView = topNameLbl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure title is updated when view appears
        updateTexts()
    }

    @IBAction func plusButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "AddNewTravellerVC") as? AddNewTravellerVC  else { return}
        vc.selectedOption = .add
        vc.delegate = self
        present(vc, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension OtherGuestVC: UITableViewDelegate, UITableViewDataSource, OtherGuestListTVCDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherGuests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OtherGuestListTVC")as! OtherGuestListTVC
        let data = otherGuests[indexPath.row]
        
        let lang = AppSettings.shared.selectedLanguage
        if lang == .arabic {
            cell.nameLbl.text = "\(data.firstName) \(data.lastName)"
            cell.nameLbl.textAlignment = .right
        } else {
            cell.nameLbl.text = "\(data.firstName) \(data.lastName)"
            cell.nameLbl.textAlignment = .left
        }
        
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
        guard let vc = storyboard.instantiateViewController(identifier: "AddNewTravellerVC")as? AddNewTravellerVC  else { return }
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
        let lang = AppSettings.shared.selectedLanguage
        
        let title = lang == .arabic ? "حذف الضيف" : "Delete Guest"
        let message = lang == .arabic ?
            "هل أنت متأكد أنك تريد حذف \(guest.firstName) \(guest.lastName)؟" :
            "Are you sure you want to delete \(guest.firstName) \(guest.lastName)?"
        let cancelTitle = lang == .arabic ? "إلغاء" : "Cancel"
        let deleteTitle = lang == .arabic ? "حذف" : "Delete"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: deleteTitle, style: .destructive, handler: { _ in
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
