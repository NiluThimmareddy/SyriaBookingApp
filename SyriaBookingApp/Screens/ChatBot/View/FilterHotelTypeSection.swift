//
//  FilterHotelTypeSection.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 06/07/26.
//

import SwiftUI

struct FilterHotelTypeSection: View {
   
    @Binding var items : [FilterItem]
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            ForEach($items) { $items in
                CheckBoxRow(item: $items)
                
            }
        }
        .padding(20)
    }
}

#Preview {
    @Previewable @State var items: [FilterItem] = [
        FilterItem(name: "Hotel", isSelected: true)
        ,FilterItem(name: "Airbnb", isSelected: false),
        FilterItem(name: "Apartment", isSelected: false)
        
    ]
    FilterHotelTypeSection(items: $items)
}
