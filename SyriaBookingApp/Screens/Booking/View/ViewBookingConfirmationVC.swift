//
//  ViewBookingConfirmationVC.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 11/08/25.
//

import UIKit

struct BookingDetail {
    let Details: String
}

class ViewBookingConfirmationVC: BaseViewController {
    
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
    @IBOutlet weak var hotelBookingConfirmationTitleLabel: UILabel!
    @IBOutlet weak var hotelAndStayTitleLabel: UILabel!
    @IBOutlet weak var roomDetailsTitleLabel: UILabel!
    @IBOutlet weak var rateTitleLabel: UILabel!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var qtyTitleLabel: UILabel!
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var paymentSummaryTitleLabel: UILabel!
    @IBOutlet weak var reservationNotesTitleLabel: UILabel!
    @IBOutlet weak var earlyCheckInTextLabel: UILabel!
    @IBOutlet weak var presentAValidIdTextLabel: UILabel!
    @IBOutlet weak var taxesFeesTextLabel: UILabel!
    @IBOutlet weak var needHelpTitleLabel: UILabel!
    @IBOutlet weak var thanksMessageTextLabel: UILabel!
    @IBOutlet weak var guestInformationTitleLabel: UILabel!
    @IBOutlet weak var totalDiscountLabel: UILabel!
    @IBOutlet weak var netTotalLabel: UILabel!
    
    var bookingId: String = ""
    var hotelID: String = ""
    var roomType: String = ""
    var bookingHistoryData: BookingHistoryDataModel?
    var hotelViewModel = HotelViewModel()
    var selectedHotel: Hotel?
    var bookingDetails: [BookingDetail] = []
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
                self.setUpLanguage()
            }
        }
    }
    
    @IBAction func printButtonAction(_ sender: Any) {
        let pdfData = createPDF()
        let activityVC = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.assignToContact, .addToReadingList]
        
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = printButton
            popoverController.sourceRect = printButton.bounds
            popoverController.permittedArrowDirections = .any
        }
        
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func goToHomeButtonAction(_ sender: Any) {
        navigateToHomeTab()
    }
}

extension ViewBookingConfirmationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomRateTVC") as! RoomRateTVC
        let detail = bookingDetails[indexPath.row]
        cell.rateLabel.text = detail.Details.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
        
        var calculatedTotal = "0.00"
        var totalDiscount = "0.00"
        var netTotal = "0.00"
        
        if let data = self.bookingHistoryData {
            let totalNights = calculateTotalNights(
                checkIn: data.checkIn.toDayMonthYear(),
                checkOut: data.checkOut.toDayMonthYear()
            )
            
            let type = data.bookingType
            
            if type == "International" {
                calculatedTotal = "$ \(String(format: "%.2f", data.totalAmount))"
                totalDiscount = "$ \(String(format: "%.2f", data.totalDiscount))"
                netTotal = "$ \(String(format: "%.2f", data.netTotal))"
            } else {
                calculatedTotal = "SYP \(String(format: "%.2f", data.totalAmount))"
                totalDiscount = "SYP \(String(format: "%.2f", data.totalDiscount))"
                netTotal = "SYP \(String(format: "%.2f", data.netTotal))"
            }
        }
        
        guard let data = bookingHistoryData else {
            print("booking history is empty")
            return
        }
        
        guard let hotelData = self.selectedHotel else {
            print("Hotel Data is empty")
            return
        }
        
        bookingDetails = parseBookingDetails(from: data.bookingDetails)
        roomRateDetailsTableview.reloadData()
        
        tableviewHeightConstraint.constant = CGFloat(50 * bookingDetails.count)
        
        let bookingLabelConfigs: [(UILabel, String, String)] = {
            if AppSettings.shared.selectedLanguage == .english {
                return [
                    (bookingReferenceLabel, "Booking Reference: SBK-\(data.id)", "Booking Reference:"),
                    (bookingDateLabel, "Booking Date: \(data.timestamp.toDayMonthYear())", "Booking Date:"),
                    (checkInLabel, "Check-In: \(data.checkIn.toDayMonthYear())", "Check-In:"),
                    (checkOutLabel, "Check-Out: \(data.checkOut.toDayMonthYear())", "Check-Out:"),
                    (totalNightsLabel, "Total: \(calculateTotalNights(checkIn: data.checkIn.toDayMonthYear(), checkOut: data.checkOut.toDayMonthYear())) Nights", "Total:"),
                    (statusLabel, "Status: \(data.bookingStatus)", "Status:"),
                    (guestLabel, "Guest: \(data.guestName)", "Guest:"),
                    (guestEmailLabel, "Email: \(data.guestEmail)", "Email:"),
                    (guestPhoneNoLabel, "Phone: \(data.guestPhone)", "Phone:"),
                    (numberOfGuestsLabel, "No. of Guests: \(data.numberOfGuests)", "No. of Guests:"),
                    (hotelNameLabel, "Hotel Name: \(hotelData.name)", "Hotel Name:"),
                    (hotelAddressLabel, "Address: \(hotelData.addressLine1 ?? "No Address")", "Address:"),
                    (hotelPhoneNumberLabel, "Phone: \(hotelData.primaryPhone ?? "No Phone Number")", "Phone:"),
                    (hotelEmailLabel, "Email: \(hotelData.email ?? "No Email")", "Email:"),
                    (hotelCheckInTimeLabel, "Check-In Time: \(hotelData.checkInTime ?? "No CheckIn")", "Check-In Time:"),
                    (hotelCheckOutTimeLabel, "Check-Out Time: \(hotelData.checkOutTime ?? "No CheckOut")", "Check-Out Time:"),
                    (roomTypeLabel, "Room Type: \(roomType)", "Room Type:"),
                    (acceptedCurrenciesLabel, "Accepted Currencies: \(hotelData.acceptedCurrencies ?? "No Currencies")", "Accepted Currencies:"),
                    (languagesSpokenLabel, "Languages Spoken: \(hotelData.languagesSpoken.rawValue)", "Languages Spoken:"),
                    (totalPriceLabel, "Total Price: \(calculatedTotal)", "Total Price:"),
                    (totalDiscountLabel, "Total Discount: \(totalDiscount)", "Total Discount:"),
                    (netTotalLabel, "Net Total: \(netTotal)", "Net Total:"),
                    (paymentMethodLabel, "Payment Method: Pay at Hotel", "Payment Method:"),
                    (contactEmailLabel, "For support or changes to your booking, contact support@syriabooking.sy", "support@syriabooking.sy")
                ]
            } else {
                return [
                    (bookingReferenceLabel, "المرجع: SBK-\(data.id)", "المرجع:"),
                    (bookingDateLabel, "تاريخ الحجز: \(data.timestamp.toDayMonthYear())", "تاريخ الحجز:"),
                    (checkInLabel, "تسجيل الوصول: \(data.checkIn.toDayMonthYear())", "تسجيل الوصول:"),
                    (checkOutLabel, "تسجيل المغادرة: \(data.checkOut.toDayMonthYear())", "تسجيل المغادرة:"),
                    (totalNightsLabel, "إجمالي الليالي: (\(calculateTotalNights(checkIn: data.checkIn.toDayMonthYear(), checkOut: data.checkOut.toDayMonthYear())))", "إجمالي الليالي:"),
                    (statusLabel, "الحالة: \(data.bookingStatus)", "الحالة:"),
                    (guestLabel, "الضيف: \(data.guestName)", "الضيف:"),
                    (guestEmailLabel, "البريد الإلكتروني: \(data.guestEmail)", "البريد الإلكتروني:"),
                    (guestPhoneNoLabel, "الهاتف: \(data.guestPhone)", "الهاتف:"),
                    (numberOfGuestsLabel, "عدد الضيوف: \(data.numberOfGuests)", "عدد الضيوف:"),
                    (hotelNameLabel, "اسم الفندق: \(hotelData.name)", "اسم الفندق:"),
                    (hotelAddressLabel, "العنوان: \(hotelData.addressLine1 ?? "لا يوجد عنوان")", "العنوان:"),
                    (hotelPhoneNumberLabel, "الهاتف: \(hotelData.primaryPhone ?? "لا يوجد هاتف")", "الهاتف:"),
                    (hotelEmailLabel, "البريد الإلكتروني: \(hotelData.email ?? "لا يوجد بريد")", "البريد الإلكتروني:"),
                    (hotelCheckInTimeLabel, "وقت تسجيل الوصول: \(hotelData.checkInTime ?? "غير متوفر")", "وقت تسجيل الوصول:"),
                    (hotelCheckOutTimeLabel, "وقت تسجيل المغادرة: \(hotelData.checkOutTime ?? "غير متوفر")", "وقت تسجيل المغادرة:"),
                    (roomTypeLabel, "نوع الغرفة: \(roomType)", "نوع الغرفة:"),
                    (acceptedCurrenciesLabel, "العملات المقبولة: \(hotelData.acceptedCurrencies ?? "لا توجد عملات")", "العملات المقبولة:"),
                    (languagesSpokenLabel, "اللغات المتحدثة: \(hotelData.languagesSpoken.rawValue)", "اللغات المتحدثة:"),
                    (totalPriceLabel, "السعر الإجمالي: \(calculatedTotal)", "السعر الإجمالي:"),
                    (totalDiscountLabel, "إجمالي الخصم: \(totalDiscount)", "إجمالي الخصم:"),
                    (netTotalLabel, "الإجمالي الصافي: \(netTotal)", "الإجمالي الصافي:"),
                    (paymentMethodLabel, "طريقة الدفع: الدفع في الفندق", "طريقة الدفع:"),
                    (contactEmailLabel, "للحصول على الدعم أو إجراء تغييرات على الحجز، تواصل عبر support@syriabooking.sy", "support@syriabooking.sy")
                ]
            }
        }()
        
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
            statusView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
            statusView.layer.borderColor = UIColor.systemBlue.cgColor
            checkMarkImgView.image = UIImage(systemName: "clock")
            checkMarkImgView.tintColor = UIColor.systemBlue
        case "cancelled":
            statusView.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
            statusView.layer.borderColor = UIColor.systemRed.cgColor
            checkMarkImgView.image = UIImage(systemName: "xmark.circle")
            checkMarkImgView.tintColor = UIColor.systemRed
        case "confirmed":
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
        guard let data = bookingHistoryData, let hotel = selectedHotel else {
            return Data()
        }
        
        // A4 page size in points (standard for documents)
        let pageWidth: CGFloat = 595.2  // 210mm
        let pageHeight: CGFloat = 841.8 // 297mm
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let margin: CGFloat = 50
        var currentY: CGFloat = margin
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        return renderer.pdfData { context in
            // Helper function to draw text with different formatting for highlighted parts
            func drawTextWithHighlight(_ text: String, highlightPhrases: [String] = [], x: CGFloat = margin, fontSize: CGFloat = 12, isBold: Bool = false, color: UIColor = .black, alignment: NSTextAlignment = .left) {
                let font = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
                
                // Create paragraph style for alignment
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = alignment
                paragraphStyle.lineBreakMode = .byWordWrapping
                
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: color,
                    .paragraphStyle: paragraphStyle
                ]
                
                // Create attributed string with highlights
                let attributedString = NSMutableAttributedString(string: text, attributes: attributes)
                
                // Apply highlight to specified phrases
                for phrase in highlightPhrases {
                    if let range = text.range(of: phrase) {
                        let nsRange = NSRange(range, in: text)
                        // Use a darker color or different style for highlights
                        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0, green: 0.4, blue: 0.8, alpha: 1.0), range: nsRange)
                        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: fontSize), range: nsRange)
                    }
                }
                
                // Calculate text bounding rect
                let maxWidth = pageWidth - (2 * margin)
                let boundingRect = attributedString.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude),
                                                               options: .usesLineFragmentOrigin,
                                                               context: nil)
                
                // Check if we need new page
                if currentY + boundingRect.height > pageHeight - margin {
                    context.beginPage()
                    currentY = margin
                }
                
                // Draw the attributed text
                attributedString.draw(in: CGRect(x: x, y: currentY, width: maxWidth, height: boundingRect.height))
                
                currentY += boundingRect.height + 10
            }
            
            // Helper function to draw simple text (without highlights)
            func drawText(_ text: String, x: CGFloat = margin, fontSize: CGFloat = 12, isBold: Bool = false, color: UIColor = .black, alignment: NSTextAlignment = .left) {
                let font = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
                
                // Create paragraph style for alignment
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = alignment
                paragraphStyle.lineBreakMode = .byWordWrapping
                
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: color,
                    .paragraphStyle: paragraphStyle
                ]
                
                // Calculate text bounding rect
                let maxWidth = pageWidth - (2 * margin)
                let boundingRect = text.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude),
                                                   options: .usesLineFragmentOrigin,
                                                   attributes: attributes,
                                                   context: nil)
                
                // Check if we need new page
                if currentY + boundingRect.height > pageHeight - margin {
                    context.beginPage()
                    currentY = margin
                }
                
                // Draw the text
                text.draw(in: CGRect(x: x, y: currentY, width: maxWidth, height: boundingRect.height),
                         withAttributes: attributes)
                
                currentY += boundingRect.height + 10
            }
            
            // Helper function to draw a line separator
            func drawLine() {
                if currentY + 20 > pageHeight - margin {
                    context.beginPage()
                    currentY = margin
                }
                
                let path = UIBezierPath()
                path.move(to: CGPoint(x: margin, y: currentY))
                path.addLine(to: CGPoint(x: pageWidth - margin, y: currentY))
                path.lineWidth = 0.5
                UIColor.lightGray.setStroke()
                path.stroke()
                
                currentY += 20
            }
            
            // Helper function to draw a section header
            func drawSectionHeader(_ title: String) {
                drawText(title, fontSize: 18, isBold: true, color: UIColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1.0))
                currentY += 5
            }
            
            // PAGE 1: Header and Status
            context.beginPage()
            currentY = margin
            
            // App Logo/Title
            drawText("SyriaBooking.sy", fontSize: 24, isBold: true, alignment: .center)
            drawText("Hotel Booking Confirmation", fontSize: 20, isBold: true, alignment: .center)
            currentY += 20
            
            // Booking Reference
            drawText("Booking Reference: SBK-\(data.id)", fontSize: 14, isBold: true, alignment: .center)
            drawText("Booking Date: \(data.timestamp.toDayMonthYear())", fontSize: 12, alignment: .center)
            currentY += 20
            
            // Status Section
            let status = data.bookingStatus.lowercased()
            let statusColor: UIColor
            let statusText: String
            let descriptionText: String
            
            switch status {
            case "pending":
                statusColor = .systemBlue
                statusText = "⏳ Awaiting Confirmation"
                descriptionText = "Your booking has been received and is pending confirmation. We'll notify you once it's confirmed."
            case "confirmed":
                statusColor = .systemGreen
                statusText = "✅ Booking Confirmed!"
                descriptionText = "We look forward to hosting you. Safe travels!"
            case "cancelled":
                statusColor = .systemRed
                statusText = "❌ Booking Cancelled"
                descriptionText = "This booking has been cancelled. If you believe this is a mistake, please contact support."
            default:
                statusColor = .darkGray
                statusText = "Booking Status: \(data.bookingStatus)"
                descriptionText = "Contact support for more details."
            }
            
            // Status box
            let statusBoxHeight: CGFloat = 80
            if currentY + statusBoxHeight > pageHeight - margin {
                context.beginPage()
                currentY = margin
            }
            
            let statusBox = CGRect(x: margin, y: currentY, width: pageWidth - (2 * margin), height: statusBoxHeight)
            statusColor.withAlphaComponent(0.1).setFill()
            UIBezierPath(roundedRect: statusBox, cornerRadius: 8).fill()
            statusColor.setStroke()
            UIBezierPath(roundedRect: statusBox, cornerRadius: 8).stroke()
            
            let statusAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 16),
                .foregroundColor: statusColor
            ]
            let statusString = NSAttributedString(string: statusText, attributes: statusAttributes)
            let statusRect = statusString.boundingRect(with: CGSize(width: statusBox.width - 20, height: CGFloat.greatestFiniteMagnitude),
                                                     options: .usesLineFragmentOrigin,
                                                     context: nil)
            statusString.draw(in: CGRect(x: statusBox.midX - statusRect.width/2, y: currentY + 15, width: statusRect.width, height: statusRect.height))
            
            let descAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.darkGray
            ]
            let descString = NSAttributedString(string: descriptionText, attributes: descAttributes)
            let descRect = descString.boundingRect(with: CGSize(width: statusBox.width - 20, height: CGFloat.greatestFiniteMagnitude),
                                                 options: .usesLineFragmentOrigin,
                                                 context: nil)
            descString.draw(in: CGRect(x: statusBox.midX - descRect.width/2, y: currentY + 45, width: descRect.width, height: descRect.height))
            
            currentY += statusBoxHeight + 30
            
            drawLine()
            
            // Guest Information Section
            drawSectionHeader("GUEST INFORMATION")
            drawText("Guest Name: \(data.guestName)")
            drawText("Email: \(data.guestEmail)")
            drawText("Phone: \(data.guestPhone)")
            drawText("Number of Guests: \(data.numberOfGuests)")
            
            drawLine()
            
            // Stay Details Section
            drawSectionHeader("STAY DETAILS")
            drawText("Check-In Date: \(data.checkIn.toDayMonthYear())")
            drawText("Check-Out Date: \(data.checkOut.toDayMonthYear())")
            drawText("Total Nights: \(calculateTotalNights(checkIn: data.checkIn.toDayMonthYear(), checkOut: data.checkOut.toDayMonthYear()))")
            drawText("Room Type: \(roomType)")
            
            // Check if we need a new page
            if currentY > pageHeight - 150 {
                context.beginPage()
                currentY = margin
            }
            
            drawLine()
            
            // Hotel Information Section
            drawSectionHeader("HOTEL INFORMATION")
            drawText("Hotel Name: \(hotel.name)")
            drawText("Address: \(hotel.addressLine1 ?? "N/A")")
            drawText("Phone: \(hotel.primaryPhone ?? "N/A")")
            drawText("Email: \(hotel.email ?? "N/A")")
            drawText("Check-In Time: \(hotel.checkInTime ?? "N/A")")
            drawText("Check-Out Time: \(hotel.checkOutTime ?? "N/A")")
            drawText("Accepted Currencies: \(hotel.acceptedCurrencies ?? "N/A")")
            drawText("Languages Spoken: \(hotel.languagesSpoken.rawValue)")
            
            // Room Details Section
            drawLine()
            drawSectionHeader("ROOM DETAILS")
            if !bookingDetails.isEmpty {
                for detail in bookingDetails {
                    drawText("• \(detail.Details)")
                }
            } else {
                drawText("No room details available")
            }
            
            // Check for new page
            if currentY > pageHeight - 200 {
                context.beginPage()
                currentY = margin
            }
            
            drawLine()
            
            // Payment Summary Section
            drawSectionHeader("PAYMENT SUMMARY")
            
            let totalNights = calculateTotalNights(checkIn: data.checkIn.toDayMonthYear(), checkOut: data.checkOut.toDayMonthYear())
            var calculatedTotal = "0.00"
            var totalDiscount = "0.00"
            var netTotalStr = "0.00"
            
            if data.bookingType == "International" {
                calculatedTotal = "$ \(String(format: "%.2f", data.totalAmount))"
                totalDiscount = "$ \(String(format: "%.2f", data.totalDiscount))"
                netTotalStr = "$ \(String(format: "%.2f", data.netTotal))"
            } else {
                calculatedTotal = "SYP \(String(format: "%.2f", data.totalAmount))"
                totalDiscount = "SYP \(String(format: "%.2f", data.totalDiscount))"
                netTotalStr = "SYP \(String(format: "%.2f", data.netTotal))"
            }
            
            drawText("Total Price: \(calculatedTotal)", fontSize: 14)
            drawText("Total Discount: \(totalDiscount)", fontSize: 14)
            drawText("Net Total: \(netTotalStr)", fontSize: 16, isBold: true, color: UIColor(red: 0, green: 0.5, blue: 0, alpha: 1.0))
            drawText("Payment Method: Pay at Hotel", fontSize: 14)
            
            drawLine()
            
            // Reservation Notes Section
            drawSectionHeader("RESERVATION NOTES")
            drawText("• Early check-in or late checkout may be subject to availability.")
            drawText("• Please present a valid ID or passport at check-in.")
            drawText("• Taxes and fees included in total price.")
            drawText("• Room rates are subject to change without prior notice.")
            drawText("• Cancellation policies apply as per hotel terms.")
            
            drawLine()
            
            // Contact Information Section - WITH HIGHLIGHTS
            drawSectionHeader("NEED HELP?")
            drawText("For support or changes to your booking, please contact:")
            currentY += 5
            
            // Draw email with highlighted address
            drawTextWithHighlight("📧 Email: support@syriabooking.sy",
                                highlightPhrases: ["support@syriabooking.sy"],
                                isBold: true)
            
            // Draw phone with highlighted number
            drawTextWithHighlight("📞 Phone: +963-123-456789",
                                highlightPhrases: ["+963-123-456789"],
                                isBold: true)
            
            currentY += 20
            drawText("Thank you for booking with SyriaBooking.sy!", fontSize: 14, isBold: true, alignment: .center)
            drawText("We wish you a pleasant stay!", fontSize: 12, alignment: .center)
            
            // Footer
            currentY = pageHeight - 40
            let footerText = "Document ID: \(UUID().uuidString.prefix(8)) | Generated on: \(Date().toString(format: "dd MMM yyyy HH:mm"))"
            drawText(footerText, fontSize: 9, color: .lightGray, alignment: .center)
        }
    }
    
    func parseBookingDetails(from input: String) -> [BookingDetail] {
        let lines = input.components(separatedBy: "\r\n")
        
        let detailsArray = lines
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .map { BookingDetail(Details: $0.trimmingCharacters(in: .whitespacesAndNewlines)) }
        
        return detailsArray
    }
    
    func calculateTotalNights(checkIn: String, checkOut: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        guard let checkInDate = formatter.date(from: checkIn),
              let checkOutDate = formatter.date(from: checkOut) else {
            return 1
        }
        
        let components = Calendar.current.dateComponents([.day], from: checkInDate, to: checkOutDate)
        return max(components.day ?? 1, 1)
    }
}

extension ViewBookingConfirmationVC {
    func setUpLanguage() {
        if AppSettings.shared.selectedLanguage == .english {
            hotelBookingConfirmationTitleLabel.text = "Hotel Booking Confirmation"
            hotelAndStayTitleLabel.text = "Hotel & Stay Details:"
            roomDetailsTitleLabel.text = "Room Details:"
            rateTitleLabel.text = "Rate"
            descriptionTitleLabel.text = "Description"
            qtyTitleLabel.text = "QTY"
            amountTitleLabel.text = "Amount"
            paymentSummaryTitleLabel.text = "Payment Summary:"
            reservationNotesTitleLabel.text = "Reservation Notes:"
            earlyCheckInTextLabel.text = "- Early check-in or late checkout may be subject to availability."
            presentAValidIdTextLabel.text = "- Please present a valid ID or passport at check-in."
            taxesFeesTextLabel.text = "- Taxes and fees included in total price."
            needHelpTitleLabel.text = "Need Help?"
            thanksMessageTextLabel.text = "Thank you for booking with Syriabooking.sy. We wish you a pleasant stay."
            guestInformationTitleLabel.text = "Guest Information:"
            
            // Status messages
            if bookingHistoryData?.bookingStatus.lowercased() == "pending" {
                messageStatusLabel.text = "Awaiting confirmation"
                descriptionStatusLabel.text = "Your booking has been received and is pending confirmation. We'll notify you once it's confirmed."
            } else if bookingHistoryData?.bookingStatus.lowercased() == "cancelled" {
                messageStatusLabel.text = "Booking cancelled"
                descriptionStatusLabel.text = "This booking has been cancelled. If you believe this is a mistake, please contact support."
            } else if bookingHistoryData?.bookingStatus.lowercased() == "confirmed" {
                messageStatusLabel.text = "Your booking is confirmed!"
                descriptionStatusLabel.text = "We look forward to hosting you. Safe travels!"
            }
            
            printButton.setTitle("Print", for: .normal)
            goToHomeButton.setTitle(isFromMyBookings ? "Close" : "Go To Home", for: .normal)
            
        } else {
            hotelBookingConfirmationTitleLabel.text = "تأكيد حجز الفندق"
            hotelAndStayTitleLabel.text = "تفاصيل الفندق والإقامة:"
            roomDetailsTitleLabel.text = "تفاصيل الغرفة:"
            rateTitleLabel.text = "السعر"
            descriptionTitleLabel.text = "الوصف"
            qtyTitleLabel.text = "الكمية"
            amountTitleLabel.text = "المبلغ"
            paymentSummaryTitleLabel.text = "ملخص الدفع:"
            reservationNotesTitleLabel.text = "ملاحظات الحجز:"
            earlyCheckInTextLabel.text = "- قد يخضع تسجيل الوصول المبكر أو المغادرة المتأخرة للتوافر."
            presentAValidIdTextLabel.text = "- يرجى تقديم بطاقة هوية صالحة أو جواز سفر عند تسجيل الوصول."
            taxesFeesTextLabel.text = "- الضرائب والرسوم مشمولة في السعر الإجمالي."
            needHelpTitleLabel.text = "هل تحتاج إلى مساعدة؟"
            thanksMessageTextLabel.text = "شكرًا لحجزك عبر Syriabooking.sy. نتمنى لك إقامة ممتعة."
            guestInformationTitleLabel.text = "معلومات الضيف:"
            
            // Status messages in Arabic
            if bookingHistoryData?.bookingStatus.lowercased() == "pending" {
                messageStatusLabel.text = "في انتظار التأكيد"
                descriptionStatusLabel.text = "تم استلام الحجز وهو قيد التأكيد. سنخطرك بمجرد تأكيده."
            } else if bookingHistoryData?.bookingStatus.lowercased() == "cancelled" {
                messageStatusLabel.text = "تم إلغاء الحجز"
                descriptionStatusLabel.text = "تم إلغاء هذا الحجز. إذا كنت تعتقد أن هذا خطأ، يرجى التواصل مع الدعم."
            } else if bookingHistoryData?.bookingStatus.lowercased() == "confirmed" {
                messageStatusLabel.text = "تم تأكيد الحجز!"
                descriptionStatusLabel.text = "نتطلع إلى استضافتك. نتمنى لك رحلة سعيدة!"
            }
            
            printButton.setTitle("طباعة", for: .normal)
            goToHomeButton.setTitle(isFromMyBookings ? "إغلاق" : "الذهاب إلى الصفحة الرئيسية", for: .normal)
        }
    }
}

// Date Extension for PDF
extension Date {
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
