//
//  DomesticatedCatView.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//

import SwiftUI

struct DomesticatedCatView: View {
    @State private var viewModel = Model()
    
    var body: some View {
        ZStack {
            if let selectedMeowFact = viewModel.selectedMeowFact {
                ScrollView {
                    VStack(alignment: .leading) {
                        AsyncImage(url: URL(string: viewModel.catImage?.url ?? "")) { phase in
                            switch phase {
                            case .failure:
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                            case .success(let image):
                                image
                                    .resizable()
                            default:
                                ProgressView()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(.rect(cornerRadius: 25))

                        Text(selectedMeowFact)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .background(.yellow)
                    .padding()
                }
            } else {
                OverlayView(message: "You have no domesticated cats yet.")
            }
        }
        .onAppear {
            viewModel.fetchDomesticatedCats()
        }
        .onTapGesture {
            viewModel.randomizeMeowFact()
        }
    }
}

#Preview {
    DomesticatedCatView()
}
