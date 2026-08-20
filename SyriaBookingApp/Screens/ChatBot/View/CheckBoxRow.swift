//
//  CheckBoxRow.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 06/07/26.
//

import SwiftUI

struct CheckBoxRow: View {
    
    @Binding var item : FilterItem
    
    var body: some View {
        Button {
            
            item.isSelected.toggle()
        } label: {
            HStack {
                Image(systemName: item.isSelected ? "checkmark.square.fill" : "square")
                    .foregroundStyle(item.isSelected ? AppColor.brandGreen : .gray)
                    .imageScale(.large)
                   
                Text(item.name)
                    .font(.headline)
                Spacer()
            }
        }
        
        .buttonStyle(.plain)
        .foregroundStyle(.primary)
    }
}

#Preview {
    
    @Previewable @State var item = FilterItem(
          name: "Hotel",
          isSelected: true
      )

      CheckBoxRow(item: $item)
         
}

