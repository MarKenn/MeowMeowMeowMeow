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
        var meowFacts: [MeowFactPersisted] = []
        var catImages: [CatImagePersisted] = []
        var selectedMeowFact: MeowFactPersisted?
        var selectedCatImage: CatImagePersisted?
        var error: Error?

        init(repository: DomesticatedCatDataSource =  DomesticatedCatRepository()) {
            self.repository = repository

            if let repository = repository as? DomesticatedCatRepository {
                meowFactsSubscriber = repository.$domesticatedCatFacts.sink { facts in
                    self.meowFacts = facts
                    self.randomizeDomesticatedCat()
                }

                meowImageSubscriber = repository.$domesticatedCatImageURLs.sink { images in
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
