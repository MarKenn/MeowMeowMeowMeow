//
//  DomesticatedCatView.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//

import SwiftUI
import NukeUI

struct DomesticatedCatView: View {
    @State private var viewModel = Model()
    @State private var didTapSetFree = false

    var referenceWidth: CGFloat {
        UIScreen.main.bounds.width - 32
    }

    var body: some View {
        ZStack {
            if let selectedMeowFact = viewModel.selectedMeowFact {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Button("Set free", systemImage: "pawprint.fill") {
                            didTapSetFree = true
                            setFree()
                            if viewModel.catImages.isEmpty && viewModel.meowFacts.isEmpty {
                                didTapSetFree = false
                            }
                        }
                        .foregroundStyle(.orange)
                        .frame(maxWidth: .infinity, alignment: .center)

                        Group {
                            if let selectedCatImageURL = viewModel.selectedCatImage?.url {
                                LazyImage(url: URL(string: selectedCatImageURL)){ state in
                                    if let image = state.image {
                                        image.resizable().aspectRatio(contentMode: .fit)
                                    } else {
                                        ProgressView()
                                    }
                                }
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(
                            minWidth: referenceWidth,
                            maxWidth: referenceWidth,
                            minHeight: referenceWidth,
                            alignment: .center)
                        .aspectRatio(contentMode: .fit)
                        .background(Color.black.opacity(0.4))
                        .clipShape(.rect(cornerRadius: 25))

                        Text(selectedMeowFact)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .padding()
                }

                if didTapSetFree {
                    OverlayView(message: "Feralized!")
                        .onTapGesture {
                            didTapSetFree = false
                        }
                }
            } else {
                OverlayView(message: "You have no domesticated cats.")
            }
        }
        .onAppear {
            viewModel.fetchDomesticatedCats()
        }
        .onTapGesture {
            viewModel.randomizeDomesticatedCat()
        }
    }
}

extension DomesticatedCatView {
    func setFree() {
        viewModel.setFree()
    }
}

#Preview {
    DomesticatedCatView()
}
