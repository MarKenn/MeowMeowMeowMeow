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

    var referenceWidth: CGFloat {
        UIScreen.main.bounds.width - 32
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
                                .aspectRatio(contentMode: .fit)
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(
                        minWidth: referenceWidth,
                        maxWidth: referenceWidth,
                        minHeight: referenceWidth,
                        alignment: .center)
                    .background(Color.black.opacity(0.4))
                    .clipShape(.rect(cornerRadius: 25))
                    .aspectRatio(contentMode: .fit)

                    if let fact = viewModel.meowFact {
                        Text(fact)
                    }
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
        getWildCat()
    }

    func getWildCat() {
        withAnimation {
            viewModel.catUIImage = nil
            Task {
                async let getCatImage: () = viewModel.getCatImage()
                async let getMeowFact: () = viewModel.getMeowFact()

                let (catImage: (), meowFact: ()) = await (getCatImage, getMeowFact)
            }
        }
    }
}

#Preview {
    WildCatView()
}
