//
//  TypingIndicatorView.swift
//  ChatBot
//
//  Created by Toqsoft on 04/06/26.
//


import SwiftUI

struct TypingIndicatorView: View {

    @State private var animating = false

    var body: some View {

        HStack(spacing: 6) {

            ForEach(0..<3) { index in

                Circle()
                    .fill(.gray)
                    .frame(width: 8, height: 8)
                    .scaleEffect(animating ? 1.3 : 0.7)
                    .animation(
                        .easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                        value: animating
                    )
            }
        }
        .padding()
        .background(AppColor.messageBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .onAppear {
            animating = true
        }
    }
}
