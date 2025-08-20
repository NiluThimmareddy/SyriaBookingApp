//
//  Covid19FAQsVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 20/08/25.
//

import UIKit

class Covid19FAQsVC : UIViewController {
    
    @IBOutlet weak var frequentlyAskedTVC: UITableView!
    
    var selectedIndexPath: IndexPath?
    
    var count = ["01","02","03","04","05","06","07"]
    var faqQuestion = ["Can I book hotels after the COVID-19 pandemic?","What safety measures are hotels taking?","Can I cancel or change my booking due to COVID-19?","Do I need to pay in advance?","Are there any travel restrictions in Syria?","Do I need a COVID-19 test or vaccination to stay at a hotel?","Who can I contact if I have a COVID-related concern?"]
    var faqAnswers = [
      "Yes, SyriaBooking.sy remains fully operational. You can search and reserve hotels across Syria, depending on local travel regulations and hotel availability. \nNote: Availability may be affected in certain areas due to local restrictions or limited operations.",

      "Many of our hotel partners are implementing safety and hygiene measures, including:\n✓ Regular cleaning and sanitization\n✓ Social distancing protocols\n✓ Staff health checks\n✓ Hand sanitizers in public areas\n✓ Contactless check-in (where available)\nLook for “Health & Safety Measures” under each hotel listing for more details.",

      "Yes. Most bookings on SyriaBooking.sy are Pay-on-Arrival, so you can cancel without penalty. However:\n✓ Some hotels may have specific cancellation policies\n✓ We advise contacting the hotel directly or reaching out to our customer support team for assistance.",

      "No. All bookings on SyriaBooking.sy follow a “Book Now, Pay on Arrival” policy — no advance payment or credit card is required online.",

      "Travel conditions may vary depending on city or region. We recommend:\n✓ Checking with local authorities before traveling\n✓ Carrying a valid ID or permit, if required\n✓ Following hotel and transportation safety rules\nWe also advise monitoring announcements from Syria’s Ministry of Health and WHO guidelines.",

      "As of now, most hotels do not require proof of vaccination or test, but this can vary by location and property. Always:\n✓ Contact the hotel prior to arrival to confirm current rules\n✓ Be prepared to wear a mask and follow local health guidelines.",

      "You can contact us directly for help with your booking or travel concern:\n• Mail us at info@syriabooking.sy\n• Call our hotline at +963-789-123456"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

extension Covid19FAQsVC : UITableViewDelegate, UITableViewDataSource {

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
        cell.descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        if selectedIndexPath == indexPath {
            cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.15)
            cell.contentView.layer.cornerRadius = 10
        } else {
            cell.contentView.backgroundColor = UIColor.white
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return (selectedIndexPath == indexPath) ? 140 : 61
        } else {
            return (selectedIndexPath == indexPath) ? 220 : 61
        }
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

extension Covid19FAQsVC {
    func setUpUI() {
        frequentlyAskedTVC.register(UINib(nibName: "FrequentlyAskedTVC", bundle: .main), forCellReuseIdentifier: "FrequentlyAskedTVC")
         frequentlyAskedTVC.dataSource = self
         frequentlyAskedTVC.delegate = self
    }
}
