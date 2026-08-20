//
//  ChatBotView.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 26/05/26.
//

import SwiftUI

enum MessageType { // for checking message type either cardView or simple text
    case Text
    case bookingList
    case invoice
    case featureOptions
    case citySelection
    case HotelFilterCardSelection
    case filterHotels
    
}

enum QuickActionEnum: String, CaseIterable{
    case myBookings = "My Bookings"
    case invoices = "Invoices"
    case cancelBooking = "Cancel Booking"
}

struct ChatbotMessage : Identifiable {
    var id: UUID = UUID()
    var mType: MessageType
    var bookings: [BookingHistoryModel]?
    var text: String?
    var cityName: String?
    var isUser: Bool
    var invoice: BookingHistoryDataModel?
}

struct ChatBotView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isTyping = false
    @State private var messageText = ""
    @State private var bookingHistoryData: BookingHistoryDataModel?
    
    @State private var notificationVM = NotificationViewModel()
    @State private var bookingViewModel = BookingViewModel()
    
    @State private var selectedAction: QuickActionEnum?
    @State private var ChatbotMessages: [ChatbotMessage] = [
        
        ChatbotMessage(
            mType: .featureOptions, isUser: false
            )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            //Header
            headerView
            //Quick Actions
            quickActionsView
//            Divider()
            
            //Message List
            messageListView
                .padding(.top, 12)
            //Input Bar
            inputBarView
        }
        .background(AppColor.messageBackground)
    }
}
//MARK: HEADER

extension ChatBotView{
    var headerView : some View {
        HStack(spacing:12){
            Image(systemName: "message.fill")
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 42, height: 42)
                .background(AppColor.brandGreen)
                .clipShape(Circle())
            
            VStack(alignment:.leading, spacing: 4){
                Text("Booking Assistant")
                    .font(.headline)
                    .foregroundStyle(AppColor.primaryText)
                HStack (spacing : 4){
                    Circle()
                        .fill(AppColor.onlineStatusGreen)
                        .frame(width: 8, height: 8)
                    Text("Online now")
                        .font(.caption)
                        .foregroundStyle(AppColor.onlineStatusGreen)
                }
            }
            Spacer()
            
            Button{
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.headline)
                    .foregroundStyle(AppColor.primaryText)
            }
        }
        .padding()
        .background(AppColor.chatBackground)

    }
}

//MARK: - Quick Actions

extension ChatBotView {
    var quickActionsView : some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 10){
                ForEach(QuickActionEnum.allCases, id: \.self){ action in
                    Button {
                        selectedAction = action
                        handleQuickAction(action)
                    } label: {
                        Text(action.rawValue)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(
                                selectedAction == action ? .white : AppColor.brandGreen
                            )
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                Capsule()
                                    .fill(
                                        selectedAction == action ? AppColor.brandGreen : Color.white
                                    )
                                
                            )
                        
                            .overlay(
                                Capsule()
                                    .stroke(
                                        selectedAction == action ? AppColor.brandGreen : Color.gray.opacity(0.25),
                                        lineWidth: 1
                                    )
                            )
                    }
                    
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

//MARK: - Message List
extension ChatBotView {
    var messageListView : some View{
        ScrollViewReader{ proxy in
            ScrollView{
                LazyVStack(spacing: 14){
                    
                    ForEach(ChatbotMessages) { message in
                        switch message.mType {
                        case .Text:
                            HStack {
                                if message.isUser {
                                    Spacer()
                                    Text(message.text ?? "")
                                        .padding()
                                        .background(AppColor.brandGreen)
                                        .foregroundStyle(.white)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 18)
                                        )
                                        .frame(
                                            maxWidth: UIScreen.main.bounds.width * 0.7,
                                            alignment: .trailing
                                        )
                                } else {
                                    Text(message.text ?? "")
                                        .padding()
                                        .background(AppColor.messageBackground)
                                        .foregroundStyle(AppColor.primaryText)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 18)
                                                .stroke(.gray.opacity(0.15), lineWidth: 1)
                                        )
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 18)
                                        )
                                        .shadow(
                                            color: .black.opacity(0.08),
                                            radius: 8,
                                            x: 0,
                                            y: 3
                                        )
                                        .frame(
                                            maxWidth: UIScreen.main.bounds.width * 0.7,
                                            alignment: .leading
                                        )
                                    
                                    Spacer()
                                }
                            }
                            
                        case .bookingList:
                            if let bookings = message.bookings {
                                VStack(spacing: 12) {
                                    ForEach(bookings, id: \.id) { booking in
                                        BookingCardView(
                                            booking: booking,
                                            imageURL: getHotelImage(for: booking),
                                            onInvoiceTap:  ( { selectedBooking in
                                                handleInvoice(booking: selectedBooking)
                                            }
                                                           ),
                                            onCancelTap: { selectedBooking in
                                                
//                                           cancelBooking(selectedBooking)
                                                
                                            }
                                        )
                                    }
                                }
                            }
                        case .invoice:
                            if let bookingHistoryData = bookingHistoryData {
                                InvoiceCardView(invoice: bookingHistoryData)
                            }
                            
                        case .featureOptions :
                            FeatureOptionsCardView(options: [
                                .init(
                                    title: "Hotel Search",
                                    icon: "building.2",
                                    action: .hotelSearch
                                ),
                                .init(
                                    title: "Availibility Check",
                                    icon: "calendar",
                                    action: .checkAvailability
                                ),
                                .init(
                                    title: "Booking Assistant",
                                    icon: "doc.text",
                                    action: .bookingManagement
                                ),
                                .init(
                                    title: "Invoices",
                                    icon: "doc.richtext",
                                    action: .invoices
                                ),
                                .init(
                                    title: "Booking modifications",
                                    icon: "square.and.pencil",
                                    action: .modifyBooking
                                ),
                                .init(
                                    title: "Cancellation Request",
                                    icon: "xmark.circle",
                                    action: .bookingCancellation
                                ),
                                .init(
                                    title: "Support",
                                    icon: "headphones",
                                    action: .support
                                )
                            ]) { feature in
                                handleFeature(feature)
                            }
                       
                        case .citySelection:
                            CitySelectionCardView(
                                cities: [
                                    "Damascus",
                                    "Aleppo",
                                    "Latakia",
                                    "Tartus",
                                    "Other City"
                                ]
                            ) { city in
                                addUserMessage("\(city)")
                                
                                ChatbotMessages.append(
                                    ChatbotMessage(
                                        mType: .HotelFilterCardSelection,
                                        cityName: city,
                                        isUser: false
                                    )
                                )
                            }
                       
                        case .HotelFilterCardSelection:
                            HotelFilterCard(cityName: message.cityName ?? "", onFilterTap: {
                                addUserMessage("Filter Hotels")
                                
                                ChatbotMessages.append(
                                    ChatbotMessage(mType: .filterHotels, isUser: false)
                                )
                            }, onShowAllTap: {
                                
                            }
                            )
                            Spacer()
                            
                        case .filterHotels:
                            HotelFilterView()
                        }
                    }
                    
                    if isTyping{
                        HStack(spacing: 5) {
                            TypingIndicatorView()
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            .onChange(of: ChatbotMessages.count) { _, _ in
                if let lastMessage = ChatbotMessages.last {
                    withAnimation {
                        proxy.scrollTo(
                            lastMessage.id,
                            anchor: .bottom
                        )
                    }
                }
            }
        }
    }

    func openInvoice(for booking: BookingHistoryModel){
        let hotelId = booking.hotelId
    }

    func getHotelImage(for history: BookingHistoryModel) -> String? {
        let hotelDict = Dictionary(uniqueKeysWithValues: HotelDataMaganer.shared.allHotels.map { ($0.id, $0) })
        return hotelDict[history.hotelId]?.coverImageURL
    }
    
    func handleFeature(_ feature: AssistantFeature){
        switch feature {
        case .hotelSearch:
            addUserMessage("Hotel Search")
            ChatbotMessages.append(
                ChatbotMessage(
                    mType: .citySelection,
                    isUser: false
                    )
            )
        case .checkAvailability:
            addUserMessage("Availibility Check")
        case .bookingManagement:
            addUserMessage("Booking Management")
            ChatbotMessages.append(
                ChatbotMessage(
                    mType: .bookingList,
                    isUser: false
                    )
            )
        case .invoices:
            addUserMessage("Invoices")
            handleInvoice(booking: nil)
        case .modifyBooking:
            addUserMessage("modify bookings")
        case .bookingCancellation:
            addUserMessage("cancel booking")
        case .support:
            addUserMessage("Support")
            
        }
    }
}

//MARK: - Input Bar

extension ChatBotView {
    var inputBarView : some View{
        HStack(spacing: 12){
            TextField("Ask about bookings, invoices, hotels...", text: $messageText)
                .padding(.horizontal, 16)
                .frame(
                    height: 50
                )
                .background(AppColor.messageBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(
                            AppColor.brandGreen.opacity(0.15),
                            lineWidth: 1
                    )
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 25.0)
                )
            
            Button {
                sendMessage()
            } label : {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray.opacity(0.4) : AppColor.brandGreen
                    )
                    .clipShape(Circle())
            }
            .disabled(
                messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColor.chatBackground)
        .overlay(
            Divider(),
            alignment: .top
        )
    }
}

extension ChatBotView {
    func sendMessage() {
        let trimmedMessage = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return }
        
        //User Message
        addUserMessage(trimmedMessage)
        
        //Clear  Field
        messageText = ""
        
        // ake Bot Response
        showBotReply(
            "Your request has been received. we will get back to you soon."
        )
    }
}

extension ChatBotView{
    func addUserMessage(_ text:String){
        ChatbotMessages.append(
            ChatbotMessage(mType: .Text, text: text, isUser: true)
        )
    }
    
    func showBotReply(_ text:String){
        Task{
            isTyping = true
            
            try? await Task.sleep(for: .seconds(3))
            isTyping = false
            ChatbotMessages.append(
                ChatbotMessage(
                    mType: .Text,
                    text: text,
                    isUser: false
                )
            )
        }
    }
    
    func fetchMyBookings(userId : String){
        isTyping = true
        
        notificationVM.onSuccess = {  bookings in
            let latestbooking = bookings.filter { data in
                if let date = data.checkInUtc.toDate() {
                    return date >= Calendar.current.startOfDay(for: Date())
                }
                return false
            }
            
            DispatchQueue.main.async {
                self.isTyping = false
                
                if latestbooking.isEmpty{
                    self.ChatbotMessages.append(
                        ChatbotMessage(mType: .Text, text: "You don't have any active bookings", isUser: false)
                    )
                } else{
                    self.ChatbotMessages.append(
                        ChatbotMessage(mType: .Text, text: "You  have  \(latestbooking.count) upcoming booking\(latestbooking.count > 1 ? "s" : "") ", isUser: false)
                    )
                    self.ChatbotMessages.append(
                        ChatbotMessage(mType: .bookingList, bookings: latestbooking, isUser: false)
                    )
                }
            }
        }
        
        notificationVM.onError = {  _ in
            DispatchQueue.main.async {
                self.isTyping = false
                self.ChatbotMessages.append(
                    ChatbotMessage(mType: .Text, text: "Unable to retrive your bookings.", isUser: false)
                )
            }
        }
        
        notificationVM.fetchNotificationUser()
    }
    
    func handleMyBookings(){
        guard let user = UserSessionManager.getUser() else {
            ChatbotMessages.append(
                ChatbotMessage(mType: .Text, text: "To view bookings, please sign in to your account.", isUser: false)
            )
            
            return
        }
        
        fetchMyBookings(userId: user.id)
    }
    
    func handleInvoice(booking:BookingHistoryModel?){
       
        guard let user = UserSessionManager.getUser() else{
            ChatbotMessages.append(
                ChatbotMessage(mType: .Text, text: "To view bookings, please sign in to your account.", isUser: false)
            )
            return
        }
        
        guard let booking = booking else{ return }
        
        fetchInvoices(BookingId: booking.id, userId: user.id)
    }
    
    func fetchInvoices(BookingId: String,userId: String){
        
        bookingViewModel.getBookingHistory(userId: userId, BookingId: BookingId) { response in
            
            DispatchQueue.main.async {
                
                self.bookingHistoryData = response
                
                ChatbotMessages.append(
                    ChatbotMessage(
                        mType: .invoice,
                        isUser: false,
                        invoice: response
                    )
                )
                
                self.bookingViewModel.onError = { error in
                    DispatchQueue.main.async {
                        ChatbotMessages.append(
                            ChatbotMessage(
                                mType: .Text,
                                text: "Unable to retrive your invoice details.",
                                isUser: false)
                        )
                        
                    }
                }
            }
        }
    }

    func cancelBooking(_ booking: BookingHistoryModel) async {
        isTyping = true
        
        do{
          guard let user = UserSessionManager.getUser() else{
            ChatbotMessages.append(
                ChatbotMessage(mType: .Text, text: "To cancel bookings, please sign in to your account.", isUser: false)
            )
            return
              
//              bookingViewModel.postCancelBooking(reason: <#T##String#>, userId: <#T##String#>, bookingId: <#T##String#>, completion: <#T##(BookingHistoryDetailsResponseModel?) -> Void#>)
        }
        } catch {
            let errorMessage = error.localizedDescription
        }
        
        isTyping = false
    }
   
    func handleQuickAction(_ action: QuickActionEnum){
        switch action{
        case .myBookings:
            handleMyBookings()
            
        case .invoices:
            
//             handleInvoice()
            break
            
        case .cancelBooking:
            //handleCancelBooking()
            break
        }
    }
}

#Preview {
    ChatBotView()
}


