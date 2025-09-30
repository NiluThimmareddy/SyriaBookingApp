//
//  ViewBookingConfirmationVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 11/08/25.
//

import UIKit

struct BookingDetail {
    let rate: Double
    let description: String
    let qty: Int
    let amount: Double
}

class ViewBookingConfirmationVC : UIViewController {
    
    @IBOutlet weak var checkMarkImgView: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var bookingReferenceLabel: UILabel!
    @IBOutlet weak var bookingDateLabel: UILabel!
    @IBOutlet weak var checkInLabel: UILabel!
    @IBOutlet weak var checkOutLabel: UILabel!
    @IBOutlet weak var totalNightsLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var guestLabel: UILabel!
    @IBOutlet weak var guestEmailLabel: UILabel!
    @IBOutlet weak var guestPhoneNoLabel: UILabel!
    @IBOutlet weak var numberOfGuestsLabel: UILabel!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var hotelAddressLabel: UILabel!
    @IBOutlet weak var hotelPhoneNumberLabel: UILabel!
    @IBOutlet weak var hotelEmailLabel: UILabel!
    @IBOutlet weak var hotelCheckInTimeLabel: UILabel!
    @IBOutlet weak var hotelCheckOutTimeLabel: UILabel!
    @IBOutlet weak var roomTypeLabel: UILabel!
    @IBOutlet weak var acceptedCurrenciesLabel: UILabel!
    @IBOutlet weak var languagesSpokenLabel: UILabel!
    @IBOutlet weak var roomRateDetailsTableview: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var contactEmailLabel: UILabel!
    @IBOutlet weak var printButton: UIButton!
    @IBOutlet weak var goToHomeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageStatusLabel: UILabel!
    @IBOutlet weak var descriptionStatusLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var tableviewHeightConstraint: NSLayoutConstraint!
    
    var bookingId : String = ""
    var hotelID : String = ""
    var roomType : String = ""
    var bookingHistoryData : BookingHistoryDataModel?
    var hotelViewModel = HotelViewModel()
    var selectedHotel: Hotel?
    var bookingDetails: [BookingDetail] = []
    
    //    var selectedRoom: RoomElement?
    var selectedRate = [Rate]()
    var viewModel = BookingViewModel()
    var isFromMyBookings: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromMyBookings {
            goToHomeButton.setTitle("Close", for: .normal)
        } else {
            goToHomeButton.setTitle("Go To Home", for: .normal)
        }
        showLoader()
        FetchBookingDetails {
            DispatchQueue.main.async {
                self.hideLoader()
                self.setUpUI()
            }
        }
    }
    
    @IBAction func printButtonAction(_ sender: Any) {
        let pdfData = createPDF()
        let activityVC = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.assignToContact, .addToReadingList]
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func goToHomeButtonAction(_ sender: Any) {
        if isFromMyBookings {
            // Just dismiss back to MyBookingsViewController
            self.dismiss(animated: true, completion: nil)
        } else {
            // Default "Go To Home" behavior
            self.view.window?.rootViewController?.dismiss(animated: true) {
                if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
                    tabBarController.selectedIndex = 0
                    if let navController = tabBarController.viewControllers?.first as? UINavigationController {
                        navController.popToRootViewController(animated: false)
                    }
                }
            }
        }
    }
}

extension ViewBookingConfirmationVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomRateTVC") as! RoomRateTVC
        let detail = bookingDetails[indexPath.row]
        
        cell.rateLabel.text = "$\(detail.rate)"
        cell.descriptionLabel.text = detail.description
        cell.descriptionLabel.numberOfLines = 0
        cell.qtyLabel.text = "\(detail.qty)"
        cell.amountLabel.text = "$\(detail.amount)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension ViewBookingConfirmationVC {
    func FetchBookingDetails(completion:@escaping ()->Void) {
        guard let user = UserSessionManager.getUser() else {
            DispatchQueue.main.async {
                self.hideLoader()
            }
            return
        }
        
        viewModel.onError = { error in
            DispatchQueue.main.async {
                self.hideLoader()
                self.showAlert(error)
            }
        }
        
        viewModel.getBookingHistory(userId: user.id, BookingId: bookingId) { response in
            self.bookingHistoryData = response
            
            self.hotelViewModel.onError = { error in
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.showAlert(error.localizedDescription)
                }
            }
            // Now fetch hotel details using booking response hotelId
            self.hotelViewModel.fetchSingleHotels(id: response.hotelId) { hotel in
                self.selectedHotel = hotel
                
                DispatchQueue.main.async {
                    self.hideLoader()
                    completion()
                }
            }
        }
    }
    
    
    func setUpUI() {
        backView.applyCardStyle()
        print("setupUI called")
        
        roomRateDetailsTableview.register(UINib(nibName: "RoomRateTVC", bundle: nil), forCellReuseIdentifier: "RoomRateTVC")
        
        let calculatedTotal: String
        let totalAmount : Double = self.bookingHistoryData?.totalAmount ?? 0.0
        calculatedTotal = String(format: "%.2f", totalAmount)
        
        guard let data = bookingHistoryData else {
            print("booking history is empty")
            return
        }
        
        guard let  hotelData = self.selectedHotel else {
            print("Hotel Data is empty")
            return
        }
        
        bookingDetails = parseBookingDetails(data.bookingDetails)
        roomRateDetailsTableview.reloadData()
        
        tableviewHeightConstraint.constant = CGFloat(44 * bookingDetails.count)
        
        let bookingLabelConfigs: [(UILabel, String, String)] = [
            (bookingReferenceLabel, "Booking Reference: SBK-\(data.id)", "Booking Reference:"),
            (bookingDateLabel, "Booking Date: \(data.timestamp.toDayMonthYear())", "Booking Date:"),
            (checkInLabel, "Check-In: \(data.checkIn.toDayMonthYear())", "Check-In:"),
            (checkOutLabel, "Check-Out: \(data.checkOut.toDayMonthYear())", "Check-Out:"),
            (totalNightsLabel, "Total Nights: (\(calculateTotalNights(checkIn: data.checkIn.toDayMonthYear(), checkOut: data.checkOut.toDayMonthYear())))", "Total Nights:"),
            (statusLabel, "Status: \(data.bookingStatus)", "Status:"),
            (guestLabel, "Guest: \(data.guestName)", "Guest:"),
            (guestEmailLabel, "Email: \(data.guestEmail)", "Email:"),
            (guestPhoneNoLabel, "Phone: \(data.guestPhone)", "Phone:"),
            (numberOfGuestsLabel, "No. of Guests: \(data.numberOfGuests)", "No. of Guests:"),
            (hotelNameLabel, "Hotel Name: \( hotelData.name)", "Hotel Name:"),
            (hotelAddressLabel, "Address: \( hotelData.addressLine1  ?? "No Address")", "Address:"),
            (hotelPhoneNumberLabel, "Phone: \( hotelData.primaryPhone ?? "No Phone Number")", "Phone:"),
            (hotelEmailLabel, "Email: \(  hotelData.email ?? "No Email")", "Email:"),
            (hotelCheckInTimeLabel, "Check-In Time: \(hotelData.checkInTime ?? "No CheckIn")", "Check-In Time:"),
            (hotelCheckOutTimeLabel, "Check-Out Time: \(hotelData.checkOutTime ?? "No CheckOut")", "Check-Out Time:"),
            (roomTypeLabel, "Room Type: \(roomType)", "Room Type:"),
            (acceptedCurrenciesLabel, "Accepted Currencies: \(hotelData.acceptedCurrencies ?? "No Currencies")", "Accepted Currencies:"),
            (languagesSpokenLabel, "Languages Spoken: \(hotelData.languagesSpoken.rawValue)", "Languages Spoken:"),
            (totalPriceLabel, "Total Price: $\(calculatedTotal)", "Total Price:"),
            (paymentMethodLabel, "Payment Method: Pay at Hotel", "Payment Method:"),
            (contactEmailLabel, "For support or changes to your booking, contact support@syriabooking.sy","support@syriabooking.sy")
        ]
        
        bookingLabelConfigs.forEach { label, fullText, highlightText in
            label.setHighlightedText(
                fullText: fullText,
                highlightText: highlightText,
                normalFont: .systemFont(ofSize: 13),
                highlightFont: .boldSystemFont(ofSize: 14),
                normalColor: .darkGray,
                highlightColor: .label
            )
        }
        
        switch data.bookingStatus.lowercased() {
        case "pending":
            messageStatusLabel.text = "Awaiting confirmation"
            descriptionStatusLabel.text = "Your booking has been received and is pending confirmation. We’ll notify you once it’s confirmed."
            statusView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
            statusView.layer.borderColor = UIColor.systemBlue.cgColor
            checkMarkImgView.image = UIImage(systemName: "clock")
            checkMarkImgView.tintColor = UIColor.systemBlue
        case "cancelled":
            messageStatusLabel.text = "Booking cancelled"
            descriptionStatusLabel.text = "This booking has been cancelled. If you believe this is a mistake, please contact support."
            statusView.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
            statusView.layer.borderColor = UIColor.systemRed.cgColor
            checkMarkImgView.image = UIImage(systemName: "xmark.circle")
            checkMarkImgView.tintColor = UIColor.systemRed
        case "confirmed":
            messageStatusLabel.text = "Your booking is confirmed!"
            messageStatusLabel.text = "Your booking is confirmed!"
            descriptionStatusLabel.text = "We look forward to hosting you. Safe travels!"
            statusView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
            statusView.layer.borderColor = UIColor.systemGreen.cgColor
            checkMarkImgView.image = UIImage(systemName: "checkmark.seal.fill")
            checkMarkImgView.tintColor = UIColor.systemGreen
        default:
            messageStatusLabel.text = "Booking Status: \(data.bookingStatus)"
            descriptionStatusLabel.text = "Contact support for more details."
            statusView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
            statusView.layer.borderColor = UIColor.darkGray.cgColor
            checkMarkImgView.image = UIImage(systemName: "questionmark.circle")
            checkMarkImgView.tintColor = UIColor.darkGray
        }
    }
    
    func savePDFToDocuments() {
        let pdfData = createPDF()
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let pdfURL = documentsURL.appendingPathComponent("BookingConfirmation.pdf")
        
        do {
            try pdfData.write(to: pdfURL)
            print("PDF saved to: \(pdfURL)")
        } catch {
            print("Could not save PDF file: \(error)")
        }
    }
    
    func createPDF() -> Data {
        let originalBounds = scrollView.bounds
        
        let pageWidth = scrollView.bounds.width
        let pageHeight = UIScreen.main.bounds.height
        let pdfPageBounds = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pdfPageBounds)
        
        let data = renderer.pdfData { context in
            let totalHeight = scrollView.contentSize.height
            var currentOffset: CGFloat = 0
            
            while currentOffset < totalHeight {
                context.beginPage()
                
                context.cgContext.saveGState()
                context.cgContext.translateBy(x: 0, y: -currentOffset)
                
                scrollView.bounds = CGRect(
                    x: 0,
                    y: currentOffset,
                    width: scrollView.bounds.width,
                    height: pageHeight
                )
                
                scrollView.layoutIfNeeded()
                scrollView.drawHierarchy(in: scrollView.bounds, afterScreenUpdates: true)
                
                context.cgContext.restoreGState()
                currentOffset += pageHeight
            }
        }
        
        scrollView.bounds = originalBounds
        return data
    }
    
    func parseBookingDetails(_ details: String) -> [BookingDetail] {
        var result: [BookingDetail] = []
        
        let regexPattern = #"\$\s*([\d.]+)\s*:\s*((?:(?!Qty\s*\d+\s*-\s*Total).)*)Qty\s*(\d+)\s*-\s*Total\s*\$\s*([\d.]+)"#
        
        guard let regex = try? NSRegularExpression(
            pattern: regexPattern,
            options: [.anchorsMatchLines, .dotMatchesLineSeparators]
        ) else {
            return result
        }
        
        let nsDetails = details as NSString
        let matches = regex.matches(in: details, range: NSRange(location: 0, length: nsDetails.length))
        
        for match in matches {
            if match.numberOfRanges == 5 {
                let rateString = nsDetails.substring(with: match.range(at: 1))
                let description = nsDetails.substring(with: match.range(at: 2)).trimmingCharacters(in: .whitespacesAndNewlines)
                let qtyString = nsDetails.substring(with: match.range(at: 3))
                let amountString = nsDetails.substring(with: match.range(at: 4))
                
                if let rate = Double(rateString),
                   let qty = Int(qtyString),
                   let amount = Double(amountString) {
                    result.append(BookingDetail(rate: rate, description: description, qty: qty, amount: amount))
                }
            }
        }
        
        return result
    }
    
}
