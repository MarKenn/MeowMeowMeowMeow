//
//  DomesticatedCatViewModel.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//

import Foundation
import Combine

extension DomesticatedCatView {
    @Observable
    class Model {
        var repository: DomesticatedCatDataSource

        var meowFactsSubscriber: AnyCancellable?
        var meowFacts: [String] = []
        var selectedMeowFact: String?
        var catImage: CatImage?
        var error: Error?

        init(repository: DomesticatedCatDataSource =  DomesticatedCatRepository()) {
            self.repository = repository

            if let repository = repository as? DomesticatedCatRepository {
                meowFactsSubscriber = repository.$domesticatedCatFacts.sink { facts in
                    self.meowFacts = facts
                    self.randomizeMeowFact()
                }
            }
        }

        func fetchDomesticatedCats() {
            repository.fetchDomesticatedCats()
        }

        func randomizeMeowFact() {
            selectedMeowFact = meowFacts.randomElement()
        }
    }
}
