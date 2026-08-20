//
//  HotelFilterCard.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 05/07/26.
//

import SwiftUI

 func getCurrentTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter.string(from: Date())
    
}

struct HotelFilterCard: View {
    
    let cityName : String
    var onFilterTap: () -> Void
    var onShowAllTap : () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "building.2")
                    .foregroundStyle(AppColor.brandGreen)
                
                //Title
                Text("Hotel in \(cityName)...")
                    .font(.headline)
                    .foregroundStyle(AppColor.brandGreen)
                
            }
                //Description
                Text("Would you like to filter your search?")
                    .font(.caption)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
            
                
                //Filter Button
                
                Button(action: onFilterTap){
                    HStack{
                        Spacer()
                        Image(systemName: "magnifyingglass")
                        
                        Text("Filter Hotels")
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(AppColor.brandGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                }
                
                //Show all hotels
                
                Button(action: onShowAllTap){
                    HStack{
                        Spacer()
                        
                        Image(systemName: "building.2")
                        
                        Text("Show All Hotels")
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    
                    .foregroundStyle(AppColor.brandGreen)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColor.brandGreen, lineWidth: 1)
                    )
                }
                
                //Time
                HStack{
                    Spacer()
                    
                    Text(getCurrentTime())
                        .font(.caption)
                        .foregroundStyle(.gray)
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
    HotelFilterCard(cityName: "Aleppo", onFilterTap: { }   , onShowAllTap: {})
}
