//
//  FilterSection.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 06/07/26.
//

import SwiftUI

struct FilterSection<Content: View>: View {
    let title:String
    
    @Binding var isExpanded: Bool
    @ViewBuilder var content: Content
    var body: some View {
        VStack(spacing:12){
            Button{
                withAnimation(.easeInOut) {
                    isExpanded.toggle()
                }
            } label : {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(AppColor.primaryText)
                    Spacer()
                    
                    Image(systemName:  isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(AppColor.primaryText)
                }
                .foregroundStyle(.primary)
            }
            
            if isExpanded{
                content
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical,8)
    }
}

#Preview {
    
    @Previewable @State var expanded = true
    
    FilterSection(
        title: "Hotel Type", isExpanded: $expanded
    ){
        VStack(alignment: .leading) {
            Text("Hotel")
            Text("Resort")
        }
        .padding(.leading)
    }
    .padding()
}
