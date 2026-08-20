//
//  InvoiceCardView.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 08/06/26.
//

import SwiftUI

struct InvoiceCardView: View {
    
    let invoice: BookingHistoryDataModel
    var selectedHotel: Hotel?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack{
                Image(systemName: "doc.text.fill")
                    .foregroundColor(.blue)
                
                Text("Invoice")
                    .font(.headline)
                
                Spacer()
                
                Text("#\(invoice.id)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(invoice.hotelId)
                    .font(.headline)
                
                Text(selectedHotel?.name ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Label(invoice.checkIn, systemImage: "calendar")
                    Spacer()
                    Label(invoice.checkOut, systemImage: "calendar")
                }
                .font(.caption)
                
                Divider()
                
                row(title: "Room", value: invoice.roomId)
                row(title: "Amount", value: "$\(invoice.totalAmount)")
                row(title: "Discount", value: "$\(invoice.totalDiscount)")
                row(title: "Net Total", value: "$\(invoice.netTotal)")
                row(title: "Payment", value: invoice.bookingType)
            }
            
            HStack {
                
                Button("View Details") {
                    
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button("Print") {
                    
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 3)
    }
    
    private func row(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
        }
    }
}
           
#Preview {
    InvoiceCardView(invoice: BookingHistoryDataModel(id: "", timestamp: "", userId: "", hotelId: "", roomId: "", guestName: "", guestPhone: "", guestEmail: "", numberOfGuests: 0, checkIn: "", checkOut: "", bookingStatus: "", bookingDetails: "", totalAmount: 0.0, bookingType: "", totalDiscount: 0.0, netTotal: 0.0))
}
