//
//  HotelFilterView.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 06/07/26.
//

import SwiftUI

struct FilterItem : Identifiable {
    let id = UUID()
    let name : String
    var isSelected = false
}
struct HotelFilterView: View {
    
    @State private var isHotelExpanded = true
    @State private var isAmenitiesExpanded = true
    @State private var isPriceExpanded = true
    @State private var isStarRatingExpanded = true
    @State private var isReviewScoreExpanded = true
    
    @State private var price: Double = 500
    
    @State private var hotelTypes = [
        FilterItem(name: "All"),
        FilterItem(name: "Hotel"),
        FilterItem(name: "Resort"),
        FilterItem(name: "Motel"),
        FilterItem(name: "Hostel"),
        FilterItem(name: "Bed and Breakfast"),
        FilterItem(name: "Apartment"),
        FilterItem(name: "Villa"),
        FilterItem(name: "Geusthouse"),
        FilterItem(name: "Boutique"),
        FilterItem(name: "Lodge"),
        FilterItem(name: "Capsule"),
        FilterItem(name: "Homestay"),
        FilterItem(name: "Camp")
    ]
    
    @State private var amenities = [
        FilterItem(name: "Air Conditioning"),
        FilterItem(name: "Balcony"),
        FilterItem(name: "Bathtub"),
        FilterItem(name: "Coffeemaker"),
        FilterItem(name: "Extra Pillow"),
        FilterItem(name: "Hairdryer"),
        FilterItem(name: "Heater"),
        FilterItem(name: "Iron"),
        FilterItem(name: "Minibar"),
        FilterItem(name: "Room Service"),
        FilterItem(name: "Safe"),
        FilterItem(name: "Television"),
        FilterItem(name: "Wi-Fi"),
        FilterItem(name: "Work Desk")
    ]
    
    @State private var stars = [
        FilterItem(name: "★ ★ ★ ★ ★"),
        FilterItem(name: "★ ★ ★ ★"),
        FilterItem(name: "★ ★ ★"),
        FilterItem(name: "★ ★"),
        FilterItem(name: "★")
    ]
    
    @State private var reviewScore = [
        FilterItem(name: "5.0+ stars"),
        FilterItem(name: "4.0+ stars"),
        FilterItem(name: "3.0+ stars"),
        FilterItem(name: "2.0+ stars"),
        FilterItem(name: "1.0+ stars")
    ]
    
    
    var body: some View {
        ScrollView{
            
            VStack{
                HStack(spacing: 8) {
                    Image(systemName: "building.2")
                        .foregroundStyle(AppColor.brandGreen)
                    
                    //Title
                    Text("Hotel Search")
                        .font(.headline)
                        .foregroundStyle(AppColor.brandGreen)
                }
                
                Text("Customize your search")
                
                HStack{
                    Spacer()
                    
                    Text(getCurrentTime())
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            .padding(20)
            .frame(maxWidth: UIScreen.main.bounds.width * 0.90, alignment: .leading)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(color: .black.opacity(0.08), radius: 4, x:0, y:2)
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 20){
                FilterSection(title: "Filter Price", isExpanded: $isHotelExpanded){
                    PriceSliderView(price: $price)
                }
                
                FilterSection(title: "Hotel Type", isExpanded: $isHotelExpanded){
                    FilterHotelTypeSection(items:$hotelTypes)
                    
                }
                
                FilterSection(title: "Amenities", isExpanded:$isAmenitiesExpanded ){
                    FilterHotelTypeSection( items: $amenities)
                }
                
                FilterSection(title: "Star Rating", isExpanded:$isStarRatingExpanded ){
                    RatingSection(items: $stars)
                }
                
                FilterSection(title: "Review Score", isExpanded:$isReviewScoreExpanded ){
                    FilterHotelTypeSection( items: $reviewScore)
                }
                
                HStack{
                    Button("Clear"){
                        
                    }
                    .font(.caption)
                    .foregroundStyle(AppColor.brandGreen)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(AppColor.brandGreen))
                    
                    Button("Apply Filters"){
                        let summary = filterSummary()
                    }
                    .font(.caption)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.90)
                    .frame(height: 46)
                    .background(AppColor.brandGreen)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding()
            .frame(maxWidth: UIScreen.main.bounds.width * 0.90, alignment: .leading)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(color: .black.opacity(0.08), radius: 4, x:0, y:2)
            .padding(.horizontal)
            
        }
    }
    
    private func filterSummary() -> [FilterSummaryItem]{
        var items : [FilterSummaryItem] = []
        
        items.append(
            FilterSummaryItem(
                icon: "dollarsign.circle",
                title:"Price",
                value: "$0 - $\(Int(price))"
            )
        )
        
        // Hotel Type
        let selectedHotels = hotelTypes.filter{ $0.isSelected && $0.name.lowercased() != "all" }
            .map { $0.name}
        
        if !selectedHotels.isEmpty {
            items.append(
                FilterSummaryItem(
                    icon: "building.2",
                    title:"Hotel Type",
                    value: selectedHotels.joined(separator: ", ")
                )
            )
        }
        
        //Amenities
        
        let selectedAmenities = amenities
            .filter({$0.isSelected})
            .map{ $0.name}
        
        if !selectedAmenities.isEmpty {
            items.append(
                FilterSummaryItem(
                    icon: "wifi",
                    title: "Amenities",
                    value: selectedAmenities.joined(separator: ", ")
                )
            )
        }
        
        //Star Rating
        let selectedStars = stars.filter { $0.isSelected }.map{ $0.name }
        
        if !selectedStars.isEmpty {
            items.append(
                FilterSummaryItem(
                    icon: "star.fill",
                    title: "Star Rating",
                    value: selectedStars.joined(separator: ", ")
                )
            )
        }
        
        let selectedReviewScores = reviewScore
            .filter{ $0.isSelected }
            .map{ $0.name }
        
        if !selectedReviewScores.isEmpty {
            items.append(
                FilterSummaryItem(
                    icon: "checkmark,seal",
                    title: "Review Score",
                    value: selectedReviewScores.joined(separator: ", ")
                )
            )
        }
        return items
    }
}

#Preview {
    HotelFilterView()
}
