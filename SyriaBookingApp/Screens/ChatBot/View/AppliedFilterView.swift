//
//  AppliedFilterView.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 13/07/26.
//

import SwiftUI

struct FilterSummaryItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let value: String
}


struct AppliedFilterView: View {
    
    @State var Data = [
        
    ]
    var body: some View {
        VStack(spacing: 10) {
            HStack{
                
            }
        }
    }
    
}

#Preview {
    AppliedFilterView()
}
