//
//  BookingCardView.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 05/06/26.

import SwiftUI

struct BookingCardView: View {

    let booking: BookingHistoryModel
    let imageURL: String?

    var onInvoiceTap: ((BookingHistoryModel) -> Void)?
    var onCancelTap: ((BookingHistoryModel) -> Void)?
    
    @State private var showCancelAlert = false
    var body: some View {

        VStack(spacing: 0) {

            HStack(alignment: .top, spacing: 12) {

                AsyncImage(
                    url: URL(string: imageURL ?? "")
                ) { image in

                    image
                        .resizable()
                        .scaledToFill()

                } placeholder: {

                    ProgressView()
                }
                .frame(width: 90, height: 90)
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )

                VStack(alignment: .leading, spacing: 6) {

                    Text(booking.hotelName)
                        .font(.headline)
                        .lineLimit(2)

                    Text(booking.roomType)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack {
                        Image(systemName: "calendar")
                        Text("Check-In")
                        Spacer()
                        Text(booking.checkInUtc.toDayMonthYear())
                    }
                    .font(.caption)

                    HStack {
                        Image(systemName: "calendar")
                        Text("Check-Out")
                        Spacer()
                        Text(booking.checkOutUtc.toDayMonthYear())
                    }
                    .font(.caption)

                    HStack {

                        Text("\(Double(booking.totalAmount))")
                            .font(.headline)
                            .fontWeight(.bold)

                        Spacer()

                        Text(booking.status)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.green.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }
            }
            .padding()

            Divider()

            HStack {

                Button {
                onInvoiceTap?(booking)
                } label: {

                    Label("Invoice", systemImage: "doc.text")
                        .font(.subheadline)
                }

                Spacer()

                Button {
                    showCancelAlert = true
                } label: {

                    Label("Cancel", systemImage: "xmark.circle")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(AppColor.messageBackground)
        .clipShape(
            RoundedRectangle(cornerRadius: 18)
        )
        .shadow(
            color: .black.opacity(0.08),
            radius: 6,
            x: 0,
            y: 2
        )
        
        .alert("Cancel Booking",
               isPresented: $showCancelAlert){
            Button("No", role: .cancel) {}
            Button("Yes", role: .destructive) {
                onCancelTap?(booking)
            }
        }
        message : {
            Text("Are you sure you want to cancel this booking?")
        }
    }
}


#Preview {
    BookingCardView(booking: BookingHistoryModel(id: "1", type: "Type", status: "Pending", hotelId: "id", roomId: "rid", hotelName: "hname", roomType: "rtype", checkInUtc: "checkin", checkOutUtc: "checkout", totalAmount: 0.0, lastUpdatedUtc: "lastupdate", title: "title", subtitle: "subtitle", deepLink: "deeplink"), imageURL: nil)
}
