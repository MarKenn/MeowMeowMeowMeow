//
//  WildCatView.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/6/25.
//

import SwiftUI

struct WildCatView: View {
    @State private var viewModel = Model()

    var body: some View {
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

                Text(viewModel.meowFact ?? "There was an unexpected error.")

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .padding()
        }
        .onAppear {
            getMeowFact()
            getCatImage()
        }
        .onTapGesture {
            getMeowFact()
            getCatImage()
        }
    }
}

extension WildCatView {
    func getMeowFact() {
        Task {
            await viewModel.getMeowFact()
        }
    }

    func getCatImage() {
        Task {
            await viewModel.getCatImage()
        }
    }
}

#Preview {
    WildCatView()
}
