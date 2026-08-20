//
//  RatingSection.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 06/07/26.
//

import SwiftUI

struct RatingSection: View {
    
   
    @Binding var items : [FilterItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            
            ForEach($items) { $item in
                Button{
                    item.isSelected.toggle()
                } label: {
                    HStack{
                        Image(systemName: item.isSelected ? "checkmark.square.fill" : "square")
                            .foregroundStyle(item.isSelected ? AppColor.brandGreen : .gray)
                            .imageScale(.large)
                        Text(item.name)
                            .foregroundStyle(.yellow)
                        
                        Spacer()
                    }
                }
                .foregroundStyle(.primary)
            }
            
        }
        .padding(20)
    }
}

#Preview {
    
    @Previewable @State  var  ratingItem : [FilterItem] = [
        FilterItem(name: "5.0+ Star", isSelected: true),
        FilterItem(name: "4.0+ Star", isSelected: false),
        FilterItem(name: "3.0+ Star", isSelected: true),
        FilterItem(name: "2.0+ Star", isSelected: false),
        FilterItem(name: "1.0+ Star", isSelected: false)
    ]
    RatingSection(items: $ratingItem)
}
