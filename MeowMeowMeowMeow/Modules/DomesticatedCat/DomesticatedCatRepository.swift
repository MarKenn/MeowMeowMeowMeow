//
//  DomesticatedCatRepository.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//

import Foundation
import Combine

protocol DomesticatedCatDataSource {
    func fetchDomesticatedCats()
}

class DomesticatedCatRepository: DomesticatedCatDataSource {
    var localDataProvider = LocalMeowProvider()

    @Published
    var domesticatedCatFacts = [String]()

    var localInboxSubscriber: AnyCancellable?

    init() {
        localInboxSubscriber = localDataProvider.$objectsPublisher.sink { items in
            self.domesticatedCatFacts = items.compactMap { $0.fact }
        }
    }

    func fetchDomesticatedCats() {
        localDataProvider.loadObjects()
    }
}
