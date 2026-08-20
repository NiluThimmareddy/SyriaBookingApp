//
//  PriceSliderView.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 06/07/26.
//

import SwiftUI

struct PriceSliderView: View {
    @Binding var price: Double
    var body: some View {
        VStack(alignment: .leading){
           
            
            Slider(value: $price, in: 0...500)
            
            HStack{
                Text("$0")
                Spacer()
                Text("500")
                
            }
            
            Text("$0-$\(Int(self.price))")
                .frame(maxWidth: UIScreen.main.bounds.width * 0.90)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8.0))
        }
    }
}

#Preview {
    
    @Previewable @State var price : Double = 45.0
    PriceSliderView(price: $price)
}
