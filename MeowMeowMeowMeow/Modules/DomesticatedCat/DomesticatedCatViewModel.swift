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
        var meowImageSubscriber: AnyCancellable?
        var meowFacts: [String] = []
        var catImages: [CatImage] = []
        var selectedMeowFact: String?
        var selectedCatImage: CatImage?
        var error: Error?

        init(repository: DomesticatedCatDataSource =  DomesticatedCatRepository()) {
            self.repository = repository

            /// Subscribe to the repository facts and images
            if let repository = repository as? DomesticatedCatRepository {
                meowFactsSubscriber = repository.$domesticatedCatFacts.sink { facts in
                    self.meowFacts = facts
                    self.randomizeDomesticatedCat()
                }

                meowImageSubscriber = repository.$domesticatedCatImages.sink { images in
                    self.catImages = images
                    self.randomizeDomesticatedCat()
                }
            }
        }

        func fetchDomesticatedCats() {
            repository.fetchDomesticatedCats()
        }

        func randomizeDomesticatedCat() {
            selectedMeowFact = meowFacts.randomElement()
            selectedCatImage = catImages.randomElement()
        }

        func setFree() {
            repository.setFree(fact: selectedMeowFact, catImage: selectedCatImage)
        }
    }
}
