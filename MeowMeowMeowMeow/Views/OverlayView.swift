//
//  OverlayView.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//

import SwiftUI

struct OverlayView: View {
    var isLoading: Bool = false
    var message: String?

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)


            VStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }

                if let message = message {
                    Text(message)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, isLoading ? 20 : 0)
                }
            }
            .padding(40)
            .background(Color.black.opacity(0.8))
            .cornerRadius(10)
        }
        .transition(.opacity)
        .animation(.easeInOut, value: isLoading)
    }
}

#Preview("ProgressOnly") {
    OverlayView(isLoading: true)
}

#Preview("ProgressAndLabel") {
    OverlayView(isLoading: true, message: "Loading...")
}

#Preview("LabelOnly") {
    OverlayView(message: "Messsage")
}
