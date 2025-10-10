//
//  PersonalDetailsViewController.swift
//  HotelBooking
//
//  Created by praveenkumar on 10/07/25.
//

import UIKit

class PersonalDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var contactDetailsTitle: UILabel!
    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var contactTableBackView: UIView!
    @IBOutlet weak var infoTableBackView: UIView!
    @IBOutlet weak var basicInfoTitle: UILabel!
    @IBOutlet weak var weLlRememberLbl: UILabel!
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var backBackView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var imageBackView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
   
    let topNameLbl: UILabel = {
       let label = UILabel()
       label.textColor = .white
       label.text = "Personal Details"
       label.font = UIFont.poppinsBold(16)
       label.textAlignment = .center
       return label
   }()
    var infoDataTitle = ["Name"]
    var contactDataTitle = ["Email Address", "Phone Number", "Address"]
    
    var personalData : BookingModel?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fontText()
        imageBackView.layer.cornerRadius = imageBackView.frame.size.height / 2
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        navigationItem.titleView = topNameLbl
        backBackView.layer.cornerRadius = backBackView.frame.size.height / 2
        contactTableView.register(UINib(nibName: "InfoAndContactTVC", bundle: nil), forCellReuseIdentifier: "InfoAndContactTVC")
        infoTableView.register(UINib(nibName: "InfoAndContactTVC", bundle: nil), forCellReuseIdentifier: "InfoAndContactTVC")
        infoTableBackView.layer.cornerRadius = 10
        contactTableBackView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = UserSessionManager.getUser() {
            personalData = user
            infoTableView.reloadData()
            contactTableView.reloadData()
        }
        
       
    }
    
    func updatePersonalData() {
        if let user = UserSessionManager.getUser() {
            self.personalData = user
            self.infoTableView.reloadData()
            self.contactTableView.reloadData()
        }
    }
    
    func fontText(){
        weLlRememberLbl.font = UIFont.poppinsMedium(12)
        basicInfoTitle.font = UIFont.poppinsBold(16)
        contactDetailsTitle.font = UIFont.poppinsBold(16)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        roundTopCornerOnly()
    }
    
    private func roundTopCornerOnly() {
        bottomView.layer.cornerRadius = 40
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      
    }

    func fetchUSerData(){
       
    }
    

    @IBAction func choosePhotoButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let editedImage = info[.editedImage] as? UIImage {
            profileImage.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImage.image = originalImage
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}

extension PersonalDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == infoTableView{
            return infoDataTitle.count
        }else{
            return contactDataTitle.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoAndContactTVC") as! InfoAndContactTVC
        let data = personalData

        if tableView == infoTableView {
            let dataTitle = infoDataTitle[indexPath.row]
            cell.titleLbl.text = dataTitle

            switch indexPath.row {
            case 0:
                cell.contentLbl.text = data?.name ?? ""
            case 1:
                cell.contentLbl.text = data?.gender ?? ""
            case 2:
                cell.contentLbl.text = data?.dob ?? ""
            default:
                cell.contentLbl.text = data?.mobile ?? ""
            }

        } else {
            let dataTitle = contactDataTitle[indexPath.row]
            cell.titleLbl.text = dataTitle

            switch indexPath.row {
            case 0:
                cell.contentLbl.text = data?.email
            case 1:
                cell.contentLbl.text = data?.mobile
            case 2:
                cell.contentLbl.text = " \(data?.address ?? ""), \(data?.country ?? "")"
            default:
                cell.contentLbl.text = ""
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == infoTableView {
            if indexPath.row == 0{
                
                let stortyBoard = UIStoryboard(name: "Profile", bundle: nil)
                let controller = stortyBoard.instantiateViewController(identifier: "PersonalDetailsEditVC")as! PersonalDetailsEditVC
                let data = personalData
                controller.personalData = data
                controller.updatePersonalData = { [weak self] in
                    self?.updatePersonalData()
                }
                controller.selectedOption = .name
                controller.delegate = self
                let transition = CATransition()
                transition.duration = 0.3
                transition.type = .push
                transition.subtype = .fromRight
                transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                
                view.window?.layer.add(transition, forKey: kCATransition)
                present(controller, animated: false)
                
            }else if indexPath.row == 1{
                let stortyBoard = UIStoryboard(name: "Profile", bundle: nil)
                let controller = stortyBoard.instantiateViewController(identifier: "PersonalDetailsEditVC")as! PersonalDetailsEditVC
                let data = personalData
                controller.personalData = data
                controller.selectedOption = .gender
                controller.delegate = self
                controller.updatePersonalData = { [weak self] in
                    self?.updatePersonalData()
                }
                present(controller, animated: false)
            }else if indexPath.row == 2{
                let stortyBoard = UIStoryboard(name: "Profile", bundle: nil)
                let controller = stortyBoard.instantiateViewController(identifier: "PersonalDetailsEditVC")as! PersonalDetailsEditVC
                let data = personalData
                controller.personalData = data
                controller.selectedOption = .dob
                controller.delegate = self
                controller.updatePersonalData = { [weak self] in
                    self?.updatePersonalData()
                }
                present(controller, animated: false)
            }
        }else if tableView == contactTableView{
            if indexPath.row == 0{
                
                let stortyBoard = UIStoryboard(name: "Profile", bundle: nil)
                let controller = stortyBoard.instantiateViewController(identifier: "PersonalDetailsEditVC")as! PersonalDetailsEditVC
                let data = personalData
                controller.personalData = data
                controller.selectedOption = .email
                controller.delegate = self
                controller.updatePersonalData = { [weak self] in
                    self?.updatePersonalData()
                }
                let transition = CATransition()
                transition.duration = 0.3
                transition.type = .push
                transition.subtype = .fromRight
                transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                
                view.window?.layer.add(transition, forKey: kCATransition)
                present(controller, animated: false)
                
            }else if indexPath.row == 1{
                
                let stortyBoard = UIStoryboard(name: "Profile", bundle: nil)
                let controller = stortyBoard.instantiateViewController(identifier: "PersonalDetailsEditVC")as! PersonalDetailsEditVC
                let data = personalData
                controller.personalData = data
                controller.selectedOption = .number
                controller.delegate = self
                let transition = CATransition()
                transition.duration = 0.3
                transition.type = .push
                transition.subtype = .fromRight
                transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                
                view.window?.layer.add(transition, forKey: kCATransition)
                present(controller, animated: false)
                
            }else if indexPath.row == 2{
                
                let stortyBoard = UIStoryboard(name: "Profile", bundle: nil)
                let controller = stortyBoard.instantiateViewController(identifier: "PersonalDetailsEditVC")as! PersonalDetailsEditVC
                let data = personalData
                controller.selectedOption = .address
                controller.personalData = data
                controller.delegate = self
                let transition = CATransition()
                transition.duration = 0.3
                transition.type = .push
                transition.subtype = .fromRight
                transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                
                view.window?.layer.add(transition, forKey: kCATransition)
                present(controller, animated: false)
                
            }
        }
    }
}

extension PersonalDetailsViewController: PersonalDetailsEditVCDelegate {
    func didUpdateName(firstName: String, lastName: String) {
//        personalData?.name = "\(firstName) \(lastName)" 
        infoTableView.reloadData()
    }

//    func didUpdateGender(_ gender: String) {
//        personalData?.gender = gender
//        infoTableView.reloadData()
//    }
//
//    func didUpdateDOB(_ dob: String) {
//        personalData?.dob = dob
//        infoTableView.reloadData()
//    }

    func didUpdateEmail(_ email: String) {
        personalData?.email = email
        contactTableView.reloadData()
    }

    func didUpdatePhoneNumber(_ phoneNumber: String, countryCode: String) {
        personalData?.mobile = "\(countryCode) \(phoneNumber)"
        contactTableView.reloadData()
    }

    func didUpdateAddress(street: String, city: String, postCode: String, country: String) {
        personalData?.country = country
        personalData?.address = street
        contactTableView.reloadData()
    }
}
