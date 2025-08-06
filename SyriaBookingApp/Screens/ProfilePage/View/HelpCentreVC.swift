//
//  HelpCentreVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 30/06/25.
//

import UIKit

class HelpCentreVC: UIViewController {

    @IBOutlet weak var scrollViewScroll: UIScrollView!
    @IBOutlet weak var scrollViewContentView: UIView!
    @IBOutlet weak var popularFaqTVHeightCons: NSLayoutConstraint!
    @IBOutlet weak var browseByCategoryTVHeightCons: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var browseByCategoryTV: UITableView!
    @IBOutlet weak var browseByCategoryTitle: UILabel!
    @IBOutlet weak var popularFaqTitle: UILabel!
    @IBOutlet weak var popularFaqTV: UITableView!
    @IBOutlet weak var curveView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchBackView: UIView!
    @IBOutlet weak var howCanWeHelpYopuLbl: UILabel!

    var selectedFAQIndex: IndexPath?
    
    let topNameLbl: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "FAQ's"
        label.font = UIFont.poppinsBold(16)
        label.textAlignment = .center
        return label
    }()

    let faqCall = [
        SecurityData(
            securityTitle: "When will I receive my booking confirmation?",
            securityContent: "You'll receive your booking confirmation immediately after completing your reservation. If you don't see it in your inbox, please check your spam folder or contact our support team."
        ),
        SecurityData(
            securityTitle: "What is your cancellation policy?",
            securityContent: "Our cancellation policy varies depending on the service provider and the booking terms. Please check the cancellation section of your confirmation or contact support for details."
        ),
        SecurityData(
            securityTitle: "How do I modify my booking?",
            securityContent: "You can modify your booking by going to 'My Bookings' in your account and selecting the booking you want to change. If you need further help, contact our support team."
        ),
        SecurityData(
            securityTitle: "What payment methods do you accept?",
            securityContent: "We accept credit and debit cards (Visa, MasterCard, American Express), UPI, net banking, and popular digital wallets such as Paytm and Google Pay."
        ),
        SecurityData(
            securityTitle: "What should I do if I haven't received my voucher?",
            securityContent: "If you haven't received your voucher within a few minutes of booking, please check your email's spam/junk folder. If it's not there, contact our customer support immediately for assistance."
        )
    ]

    let categoryData = [
        ProfileOption(listData: "Bookings", imageName: "calendar.badge.checkmark"),
        ProfileOption(listData: "Refunds and Charges", imageName: "creditcard"),
        ProfileOption(listData: "Accounts", imageName: "person.crop.circle"),
        ProfileOption(listData: "Privacy", imageName: "lock.shield"),
        ProfileOption(listData: "Security", imageName: "lock")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        popularFaqTitle.font = .poppinsBold(16)
        browseByCategoryTitle.font = .poppinsBold(16)
        howCanWeHelpYopuLbl.font = .poppinsBold(16)
        popularFaqTV.register(UINib(nibName: "PopularFAQTVC", bundle: nil), forCellReuseIdentifier: "PopularFAQTVC")
        browseByCategoryTV.register(UINib(nibName: "ProfileTVC", bundle: nil), forCellReuseIdentifier: "ProfileTVC")
        navigationItem.titleView = topNameLbl
        popularFaqTV.showsVerticalScrollIndicator = false
        browseByCategoryTV.showsVerticalScrollIndicator = false
        searchBackView.BackViewShadow()
        popularFaqTV.BackViewShadow()
        browseByCategoryTV.BackViewShadow()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        roundTopLeftCornerOnly()
        updateDynamicHeights()
    }

    private func roundTopLeftCornerOnly() {
        curveView.layer.cornerRadius = 40
        curveView.layer.maskedCorners = [.layerMinXMinYCorner]
        curveView.clipsToBounds = true
    }

    func updateDynamicHeights() {
        let defaultScrollHeight: CGFloat = 255
        let popularFAQDefaultRowHeight: CGFloat = 50
        let expandedFAQRowHeight: CGFloat = 236
        let browseCategoryDefaultRowHeight: CGFloat = 50

        let faqCount = popularFaqTV.numberOfRows(inSection: 0)
        let categoryCount = browseByCategoryTV.numberOfRows(inSection: 0)

        var faqTotalHeight: CGFloat = 0
        for row in 0..<faqCount {
            let indexPath = IndexPath(row: row, section: 0)
            faqTotalHeight += (selectedFAQIndex == indexPath) ? expandedFAQRowHeight : popularFAQDefaultRowHeight
        }
        popularFaqTVHeightCons.constant = faqTotalHeight
        browseByCategoryTVHeightCons.constant = CGFloat(categoryCount) * browseCategoryDefaultRowHeight
        scrollViewHeightCons.constant = defaultScrollHeight + faqTotalHeight + browseByCategoryTVHeightCons.constant

        view.layoutIfNeeded()
    }
}

extension HelpCentreVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == popularFaqTV ? faqCall.count : categoryData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == popularFaqTV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopularFAQTVC", for: indexPath) as! PopularFAQTVC
            let data = faqCall[indexPath.row]
            let isExpanded = selectedFAQIndex == indexPath
            cell.questionLbl.text = data.securityTitle
            cell.answerLbl.text = data.securityContent
            cell.bottomView.isHidden = !isExpanded
            cell.bottomViewHeightCons.constant = isExpanded ? 186 : 0

            UIView.animate(withDuration: 0.3) {
                cell.bottomView.alpha = isExpanded ? 1 : 0
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVC", for: indexPath) as! ProfileTVC
            let data = categoryData[indexPath.row]
            cell.profileListLbl.text = data.listData
            cell.profileListImages.image = UIImage(systemName: data.imageName)
            cell.profileListImages.tintColor = .darkGray
            cell.viewLeading.constant = 10
            cell.viewTrailing.constant = 10
            cell.imageLeading.constant = 0
            cell.profileListLbl.font = .poppinsMedium(14)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == popularFaqTV {
            return selectedFAQIndex == indexPath ? 236 : 50
        } else {
            return 50
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView == popularFaqTV else { return }

        let previousSelectedIndex = selectedFAQIndex
        if selectedFAQIndex == indexPath {
            selectedFAQIndex = nil
        } else {
            selectedFAQIndex = indexPath
        }

        tableView.beginUpdates()
        if let previous = previousSelectedIndex {
            tableView.reloadRows(at: [previous], with: .automatic)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()

        updateDynamicHeights()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        }
    }
}
