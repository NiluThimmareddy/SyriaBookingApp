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

class ViewBookingConfirmationVC : BaseViewController {
    
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
    
    var bookingId : String = ""
    var hotelID : String = ""
    var roomType : String = ""
    var bookingHistoryData : BookingHistoryDataModel?
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
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func goToHomeButtonAction(_ sender: Any) {
        navigateToHomeTab()
    }
}

extension ViewBookingConfirmationVC : UITableViewDelegate, UITableViewDataSource {
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
        
        var calculatedTotal = "0.00"
        var totalDiscount = "0.00"
        var netTotal = "0.00"
        
        if let data = self.bookingHistoryData {
            // Parse total nights
            let totalNights = calculateTotalNights(
                checkIn: data.checkIn.toDayMonthYear(),
                checkOut: data.checkOut.toDayMonthYear()
            )
            
            let type = data.bookingType
            
            if type == "International" {
                calculatedTotal = "$ \(String(format: "%.2f", data.totalAmount))"
                totalDiscount = "$ \(String(format: "%.2f", data.totalDiscount))"
                netTotal = "$ \(String(format: "%.2f", data.netTotal))"
            }else{
                calculatedTotal = "SYP \(String(format: "%.2f", data.totalAmount))"
                totalDiscount = "SYP \(String(format: "%.2f", data.totalDiscount))"
                netTotal = "SYP \(String(format: "%.2f", data.netTotal))"
            }
        }
        
        guard let data = bookingHistoryData else {
            print("booking history is empty")
            return
        }
        
        guard let  hotelData = self.selectedHotel else {
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
                    (totalDiscountLabel, "Total Discount: \(totalDiscount)","Total Discount:"),
                    (netTotalLabel, "Net Total:\(netTotal)","Net Total:"),
                    (paymentMethodLabel, "Payment Method: Pay at Hotel", "Payment Method:"),
                    (contactEmailLabel, "For support or changes to your booking, contact support@syriabooking.sy","support@syriabooking.sy")
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
                    (netTotalLabel, "الإجمالي الصافي:  \(totalDiscount)","الإجمالي الصافي:"),
                    (paymentMethodLabel, "طريقة الدفع: الدفع في الفندق", "طريقة الدفع:"),
                    (contactEmailLabel, "للحصول على الدعم أو إجراء تغييرات على الحجز، تواصل عبر support@syriabooking.sy","support@syriabooking.sy")
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
    
    func parseBookingDetails(from input: String) -> [BookingDetail] {
        // Split the string using "\r\n"
        let lines = input.components(separatedBy: "\r\n")
        
        // Convert non-empty lines into BookingDetail objects
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
                descriptionStatusLabel.text = "Your booking has been received and is pending confirmation. We’ll notify you once it’s confirmed."
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
