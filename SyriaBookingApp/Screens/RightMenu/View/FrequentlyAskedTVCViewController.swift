//
//  FrequentlyAskedTVCViewController.swift
//  NewProject
//
//  Created by Yarramsetti Yedukondalu on 06/08/25.
//

import UIKit

class FrequentlyAskedTVCViewController : UIViewController {
    
    @IBOutlet weak var frequentlyAskedTVC: UITableView!
    
    var selectedIndexPath: IndexPath?
    
    var count = ["01","02","03","04","05","06","07","08","09","10"]
    var faqQuestion = ["How do I book a hotel on SyriaBooking.sy?","Do I need to pay in advance?","Is my booking confirmed immediately?","Can I cancel or modify my booking?","Do I need a credit card to book?","How do I know the hotel is legitimate?","What payment methods are accepted at the hotel?","I didn’t receive my booking confirmation. What should I do?","Are there any booking fees?","Is customer support available?"]
    var faqAnswers = ["Simply search for your destination, select your travel dates, browse the available hotels, and click 'Book Now' on your preferred property. No prepayment or credit card is required — your booking will be confirmed instantly.","No. SyriaBooking.sy follows a “Pay on Arrival” model. You will pay directly at the hotel upon check-in, in cash or by card (as accepted by the hotel).","Yes. Once you complete your booking, you will receive a confirmation email or SMS instantly. Your room is reserved and guaranteed by the hotel.","Yes, most hotels offer free cancellation or modifications up to a certain time before check-in. Always check the hotel’s cancellation policy on the booking page or in your confirmation email.","No. Unlike other platforms, we do not require a credit card or payment details at the time of booking.","All hotels listed on SyriaBooking.sy are verified and approved by our local team. We regularly update listings with accurate photos, descriptions, and reviews from real guests.","Most hotels accept cash in Syrian Pounds and US Dollar. Some may also accept credit/debit cards. Check the hotel’s profile for accepted payment options before booking.","Please check your spam/junk folder first. If you still haven’t received it within 5 minutes, contact our customer support at info@syriabooking.sy or call our helpline.","No. SyriaBooking.sy does not charge any booking or service fees. You pay only for your stay, directly to the hotel.","Yes. Our local customer support team is available 7 days a week to assist with bookings, cancellations, or any inquiries. We're here to help you travel worry-free."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
extension FrequentlyAskedTVCViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqQuestion.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FrequentlyAskedTVC", for: indexPath) as! FrequentlyAskedTVC

        let imageName = (selectedIndexPath == indexPath) ? "chevron.up" : "chevron.down"
        cell.imageLabel.image = UIImage(systemName: imageName)
        cell.imageLabel.tintColor = .darkGray
        cell.serialNumLabel.text = count[indexPath.row]
        cell.headLineLabel.text = faqQuestion[indexPath.row]
        cell.descriptionLabel.text = faqAnswers[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (selectedIndexPath == indexPath) ? 200 : 61
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath

        if selectedIndexPath == indexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }

        var indexPathsToReload: [IndexPath] = [indexPath]
        if let previous = previousIndexPath, previous != indexPath {
            indexPathsToReload.append(previous)
        }

        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.reloadRows(at: indexPathsToReload, with: .none)
    }

}

extension FrequentlyAskedTVCViewController {
    func setUpUI() {
        frequentlyAskedTVC.register(UINib(nibName: "FrequentlyAskedTVC", bundle: .main), forCellReuseIdentifier: "FrequentlyAskedTVC")
         frequentlyAskedTVC.dataSource = self
         frequentlyAskedTVC.delegate = self
    }
}
