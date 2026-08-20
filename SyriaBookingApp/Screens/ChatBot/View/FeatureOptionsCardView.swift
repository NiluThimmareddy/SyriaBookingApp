//
//  FeatureOptionsCardView.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 18/06/26.
//

import SwiftUI

enum AssistantFeature {
    case hotelSearch
    case checkAvailability
    case bookingManagement
    case invoices
    case modifyBooking
    case bookingCancellation
    case support
}

struct FeatureOption: Identifiable {
    let id = UUID()
    let title: String
    let icon : String
    let action : AssistantFeature
}

struct FeatureOptionsCardView: View {
    
    let options: [FeatureOption]
    var onOptionTap: ((AssistantFeature) -> Void)?
    
    var body: some View {
        VStackLayout(alignment: .leading, spacing: 16){
            
            Text("👋 Welcome to SyriaBooking Assistant")
                .font(.subheadline)
                .foregroundColor(AppColor.primaryText)
            
            Text("I can help you with:")
                .font(.caption)
                .foregroundColor(AppColor.secondaryText)
            
            VStack(spacing: 0) {
                ForEach(options) { option in
                    HStack(spacing: 12) {
                        
                        Button {
                            onOptionTap?(option.action)
                        } label : {
                            HStack(spacing : 8) {
                                Image (systemName: option.icon)
                                    .foregroundColor(AppColor.brandGreen)
                                    
                                
                                Text(option.title)
                                    .foregroundColor(AppColor.primaryText)
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .overlay(
                        Rectangle()
                            .stroke(Color.gray.opacity(0.15))
                    )
                }
            }
            .buttonStyle(.plain)
            
            Text("Select any option to begin")
                .font(.headline)
                .foregroundColor(AppColor.chatBackground)
                .padding()
                .frame(maxWidth:UIScreen.main.bounds.width * 0.9)
                
                .background(AppColor.brandGreen)
        }
    }
    
    
}

#Preview {
    FeatureOptionsCardView(options: [])
}
