//
//  CitySelectionCardView.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 19/06/26.
//

import SwiftUI

struct CitySelectionCardView: View {
    
    let cities: [String]
    var onCitySelected: ((String) -> Void)?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "building.2")
                    .foregroundColor(AppColor.brandGreen)
                
                Text("Hotel Search")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColor.brandGreen)
            }
            
            Text("Which city would you like to stay in?")
                .font(.subheadline)
                .foregroundColor(AppColor.primaryText)
            
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 100))
                ],
                spacing: 10
            ) {
                ForEach(cities, id: \.self) { city in
                    Button {
                        onCitySelected?(city)
                    } label: {
                        Text(city)
                            .font(.subheadline)
                            .foregroundColor(AppColor.brandGreen)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
//                            .background(
//                                AppColor.brandGreen.opacity(0.05)
//                            )
                            .overlay(
                               RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        AppColor.brandGreen,
                                        lineWidth: 1
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(
            color: .black.opacity(0.05),
            radius: 5,
            x: 0,
            y: 2
        )
    }
}

#Preview {
    CitySelectionCardView(cities: ["Damscus", "Aleppo"])
}
