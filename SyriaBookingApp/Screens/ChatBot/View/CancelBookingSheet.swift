//
//  CancelBookingSheet.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 15/06/26.
//
import SwiftUI

struct CancelBookingSheet: View {

    let booking: BookingHistoryModel

    @Binding var isPresented: Bool

    @State private var selectedReason: String?
    @State private var customReason = ""
    @State private var showValidationError = false

    var onConfirm: ((String) -> Void)?

    let reasons = [
        "Change of plans",
        "Found better hotel",
        "Booked by mistake",
        "Other"
    ]

    private var canCancel: Bool {

        guard let selectedReason else {
            return false
        }

        if selectedReason == "Other" {
            return !customReason
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .isEmpty
        }

        return true
    }

    var body: some View {

        VStack(spacing: 20) {

            Text("Cancel Booking")
                .font(.title2)
                .fontWeight(.bold)

            Text(booking.hotelName)
                .font(.headline)
                .multilineTextAlignment(.center)

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 12
            ) {

                ForEach(reasons, id: \.self) { reason in

                    Button {

                        selectedReason = reason
                        showValidationError = false

                    } label: {

                        Text(reason)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                selectedReason == reason
                                ? Color.red.opacity(0.15)
                                : Color.clear
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        selectedReason == reason
                                        ? Color.red
                                        : Color.gray.opacity(0.4),
                                        lineWidth: 1
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                }
            }

            if selectedReason == "Other" {

                VStack(alignment: .leading, spacing: 8) {

                    Text("Please specify the reason")
                        .font(.subheadline)

                    TextField(
                        "Enter cancellation reason",
                        text: $customReason
                    )
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: customReason) { _, _ in
                        showValidationError = false
                    }

                    if showValidationError {

                        Text("Please enter a reason")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {

                Text("Cancellation is permanent")
                    .fontWeight(.bold)

                Text("""
                Your booking will be cancelled immediately.
                Any refund will be processed according to the hotel's cancellation policy.
                This action cannot be undone.
                """)
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.orange.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            HStack(spacing: 12) {

                Button {

                    isPresented = false

                } label: {

                    Text("Keep Booking")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.15))
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12)
                        )
                }

                Button {

                    guard let selectedReason else {
                        return
                    }

                    if selectedReason == "Other" {

                        let trimmedReason = customReason
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )

                        guard !trimmedReason.isEmpty else {
                            showValidationError = true
                            return
                        }

                        onConfirm?(trimmedReason)

                    } else {

                        onConfirm?(selectedReason)
                    }

                    isPresented = false

                } label: {

                    Text("Cancel Booking")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12)
                        )
                }
                .disabled(!canCancel)
                .opacity(canCancel ? 1 : 0.5)
            }
        }
        .padding()
    }
}

#Preview {
    CancelBookingSheet(booking: BookingHistoryModel(id: "", type: "", status: "", hotelId: "", roomId: "", hotelName: "", roomType: "", checkInUtc: "", checkOutUtc: "", totalAmount: 0.0, lastUpdatedUtc: "", title: "", subtitle: "", deepLink: ""), isPresented: .constant(true))
}
