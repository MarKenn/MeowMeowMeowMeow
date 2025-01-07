//
//  WildCatView.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/6/25.
//

import SwiftUI

struct WildCatView: View {
    @State private var viewModel = Model()
    @State private var didTapDomesticate = false

    var screenSize: CGRect {
        UIScreen.main.bounds
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Button("Domesticate", systemImage: "heart.fill") {
                        didTapDomesticate = true
                        domesticate()
                    }
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .center)

                    Group {
                        if let catUIImage = viewModel.catUIImage {
                            Image(uiImage: catUIImage)
                                .resizable()
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(
                        width: screenSize.width - 32,
                        height: screenSize.width - 32)
                    .aspectRatio(contentMode: .fit)
                    .background(Color.black.opacity(0.4))
                    .clipShape(.rect(cornerRadius: 25))

                    Text(viewModel.meowFact ?? "There was an unexpected error.")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .padding()
            }

            if didTapDomesticate {
                OverlayView(message: "Domesticated!")
                    .onTapGesture {
                        didTapDomesticate = false
                    }
            }
        }
        .onAppear {
            getWildCat()
        }
        .onTapGesture {
            getWildCat()
        }
    }
}

extension WildCatView {
    func domesticate() {
        viewModel.domesticate()
    }

    func getWildCat() {
        viewModel.catUIImage = nil
        Task {
            async let getCatImage: () = viewModel.getCatImage()
            async let getMeowFact: () = viewModel.getMeowFact()

            let (catImage: (), meowFact: ()) = await (getCatImage, getMeowFact)
        }
    }
}

#Preview {
    WildCatView()
}
