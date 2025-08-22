//
//  ViewBookingConfirmationVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 11/08/25.
//

/*
import UIKit

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
    
    var selectedHotel: Hotel?
    var selectedRoom: RoomElement?
    var selectedRate: Rate?
    
    var bookingReference: String = UUID().uuidString.prefix(8).uppercased()
    var bookingDate: String?
    var checkInDate: String?
    var checkOutDate: String?
    var totalNights: Int?
    var status: String = "Confirmed"
    var guestName: String?
    var guestEmail: String?
    var guestPhone: String?
    var numberOfGuests: String?
    var roomType: String?
    var totalPrice: String?
    
    let quantity = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    @IBAction func printButtonAction(_ sender: Any) {
        let pdfData = createPDF()
        let activityVC = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.assignToContact, .addToReadingList]
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func goToHomeButtonAction(_ sender: Any) {

    }
    
}

extension ViewBookingConfirmationVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomRateTVC") as! RoomRateTVC
        if let rate = selectedRate {
            let price = rate.price
            let description = rate.notes ?? "No description available"
            let quantity = rate.selectedQuantity
            cell.rateLabel.text = "\(price)"
            cell.descriptionLabel.text = description
            cell.qtyLabel.text = "\(quantity)"
            cell.amountLabel.text = String(format: "$%.2f", Double(price * quantity))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ViewBookingConfirmationVC {
    func setUpUI() {
        roomRateDetailsTableview.register(UINib(nibName: "RoomRateTVC", bundle: nil), forCellReuseIdentifier: "RoomRateTVC")
        
        let calculatedTotal: String
        if let rate = selectedRate {
            let totalAmount = Double(rate.price * rate.selectedQuantity)
            calculatedTotal = String(format: "%.2f", totalAmount)
            totalPrice = calculatedTotal
        } else {
            calculatedTotal = "0.00"
            totalPrice = "0.00"
        }
        
        let bookingLabelConfigs: [(UILabel, String, String)] = [
            (bookingReferenceLabel, "Booking Reference: \(bookingReference)", "Booking Reference:"),
            (bookingDateLabel, "Booking Date: \(bookingDate ?? "")", "Booking Date:"),
            (checkInLabel, "Check-In: \(checkInDate ?? "")", "Check-In:"),
            (checkOutLabel, "Check-Out: \(checkOutDate ?? "")", "Check-Out:"),
            (totalNightsLabel, "Total Nights: \(totalNights ?? 0)", "Total Nights:"),
            (statusLabel, "Status: \(status)", "Status:"),
            (guestLabel, "Guest: \(guestName ?? "")", "Guest:"),
            (guestEmailLabel, "Email: \(guestEmail ?? "")", "Email:"),
            (guestPhoneNoLabel, "Phone: \(guestPhone ?? "")", "Phone:"),
            (numberOfGuestsLabel, "No. of Guests: \(numberOfGuests ?? "")", "No. of Guests:"),
            (hotelNameLabel, "Hotel Name: \(selectedHotel?.name ?? "No Hotel name")", "Hotel Name:"),
            (hotelAddressLabel, "Address: \(selectedHotel?.addressLine1 ?? "No Address")", "Address:"),
            (hotelPhoneNumberLabel, "Phone: \(selectedHotel?.primaryPhone ?? "No Phone Number")", "Phone:"),
            (hotelEmailLabel, "Email: \(selectedHotel?.email ?? "No Email")", "Email:"),
            (hotelCheckInTimeLabel, "Check-In Time: \(selectedHotel?.checkInTime ?? "No CheckIn")", "Check-In Time:"),
            (hotelCheckOutTimeLabel, "Check-Out Time: \(selectedHotel?.checkOutTime ?? "No CheckOut")", "Check-Out Time:"),
            (roomTypeLabel, "Room Type: \(selectedRoom?.room.roomType ?? "Not Room type")", "Room Type:"),
            (acceptedCurrenciesLabel, "Accepted Currencies: \(selectedHotel?.acceptedCurrencies ?? "No Currencies")", "Accepted Currencies:"),
            (languagesSpokenLabel, "Languages Spoken: \(selectedHotel?.languagesSpoken.rawValue ?? "Not specified")", "Languages Spoken:"),
            (totalPriceLabel, "Total Price: \(calculatedTotal)", "Total Price:"),
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
        let pageHeight: CGFloat = UIScreen.main.bounds.height
        
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
                    height: scrollView.bounds.height
                )
                
                scrollView.layoutIfNeeded()
                scrollView.layer.render(in: context.cgContext)
                
                context.cgContext.restoreGState()
                
                currentOffset += pageHeight
            }
        }

        scrollView.bounds = originalBounds
        return data
    }

}

*/

import UIKit

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
    
    var selectedHotel: Hotel?
    var selectedRoom: RoomElement?
    var selectedRate: Rate?
    
    var bookingReference: String = UUID().uuidString.prefix(8).uppercased()
    var bookingDate: String?
    var checkInDate: String?
    var checkOutDate: String?
    var totalNights: Int?
    var status: String = "Confirmed"
    var guestName: String?
    var guestEmail: String?
    var guestPhone: String?
    var numberOfGuests: String?
    var roomType: String?
    var totalPrice: String?
    
    let quantity = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    @IBAction func printButtonAction(_ sender: Any) {
        let pdfData = createPDF()
        let activityVC = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.assignToContact, .addToReadingList]
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func goToHomeButtonAction(_ sender: Any) {

    }
    
}

extension ViewBookingConfirmationVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomRateTVC") as! RoomRateTVC
        if let rate = selectedRate {
            let price = rate.price
            let description = rate.notes ?? "No description available"
            let quantity = rate.selectedQuantity
            cell.rateLabel.text = "\(price)"
            cell.descriptionLabel.text = description
            cell.qtyLabel.text = "\(quantity)"
            cell.amountLabel.text = String(format: "$%.2f", Double(price * quantity))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ViewBookingConfirmationVC {
    func setUpUI() {
        roomRateDetailsTableview.register(UINib(nibName: "RoomRateTVC", bundle: nil), forCellReuseIdentifier: "RoomRateTVC")
        
        let calculatedTotal: String
        if let rate = selectedRate {
            let totalAmount = Double(rate.price * rate.selectedQuantity)
            calculatedTotal = String(format: "%.2f", totalAmount)
            totalPrice = calculatedTotal
        } else {
            calculatedTotal = "0.00"
            totalPrice = "0.00"
        }
        
        let bookingLabelConfigs: [(UILabel, String, String)] = [
            (bookingReferenceLabel, "Booking Reference: \(bookingReference)", "Booking Reference:"),
            (bookingDateLabel, "Booking Date: \(bookingDate ?? "")", "Booking Date:"),
            (checkInLabel, "Check-In: \(checkInDate ?? "")", "Check-In:"),
            (checkOutLabel, "Check-Out: \(checkOutDate ?? "")", "Check-Out:"),
            (totalNightsLabel, "Total Nights: \(totalNights ?? 0)", "Total Nights:"),
            (statusLabel, "Status: \(status)", "Status:"),
            (guestLabel, "Guest: \(guestName ?? "")", "Guest:"),
            (guestEmailLabel, "Email: \(guestEmail ?? "")", "Email:"),
            (guestPhoneNoLabel, "Phone: \(guestPhone ?? "")", "Phone:"),
            (numberOfGuestsLabel, "No. of Guests: \(numberOfGuests ?? "")", "No. of Guests:"),
            (hotelNameLabel, "Hotel Name: \(selectedHotel?.name ?? "No Hotel name")", "Hotel Name:"),
            (hotelAddressLabel, "Address: \(selectedHotel?.addressLine1 ?? "No Address")", "Address:"),
            (hotelPhoneNumberLabel, "Phone: \(selectedHotel?.primaryPhone ?? "No Phone Number")", "Phone:"),
            (hotelEmailLabel, "Email: \(selectedHotel?.email ?? "No Email")", "Email:"),
            (hotelCheckInTimeLabel, "Check-In Time: \(selectedHotel?.checkInTime ?? "No CheckIn")", "Check-In Time:"),
            (hotelCheckOutTimeLabel, "Check-Out Time: \(selectedHotel?.checkOutTime ?? "No CheckOut")", "Check-Out Time:"),
            (roomTypeLabel, "Room Type: \(selectedRoom?.room.roomType ?? "Not Room type")", "Room Type:"),
            (acceptedCurrenciesLabel, "Accepted Currencies: \(selectedHotel?.acceptedCurrencies ?? "No Currencies")", "Accepted Currencies:"),
            (languagesSpokenLabel, "Languages Spoken: \(selectedHotel?.languagesSpoken.rawValue ?? "Not specified")", "Languages Spoken:"),
            (totalPriceLabel, "Total Price: \(calculatedTotal)", "Total Price:"),
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


}

