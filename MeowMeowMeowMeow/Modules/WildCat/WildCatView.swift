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
        VStack {
            Text(viewModel.meowFact ?? "There was an unexpected error.")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .padding()
        .onAppear {
            getMeowFact()
        }
        .onTapGesture {
            getMeowFact()
        }
    }
}

extension WildCatView {
    func getMeowFact() {
        Task {
            await viewModel.getMeowFact()
        }
    }
}

#Preview {
    WildCatView()
}
