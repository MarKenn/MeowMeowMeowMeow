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
    func setFree(fact: String?, catImage: CatImage?)
}

class DomesticatedCatRepository: DomesticatedCatDataSource {
    var localFactProvider: LocalMeowFactProvider
    var localImageProvider: LocalCatImageProvider

    @Published
    var domesticatedCatFacts = [String]()

    @Published
    var domesticatedCatImages = [CatImage]()

    var localFactSubscriber: AnyCancellable?
    var localImageSubscriber: AnyCancellable?

    init(
        factProvider: LocalMeowFactProvider =  LocalMeowFactProvider(),
        imageProvider: LocalCatImageProvider = LocalCatImageProvider()
    ) {
        self.localFactProvider = factProvider
        self.localImageProvider = imageProvider

        localFactSubscriber = localFactProvider.$objectsPublisher.sink { items in
            self.domesticatedCatFacts = items
        }

        localImageSubscriber = localImageProvider.$objectsPublisher.sink { items in
            self.domesticatedCatImages = items
        }
    }

    func fetchDomesticatedCats() {
        localFactProvider.loadObjects()
        localImageProvider.loadObjects()
    }

    func setFree(fact: String?, catImage: CatImage?) {
        if let fact, let item = localFactProvider.findObject(using: fact) {
            localFactProvider.delete(item)
        }

        if let catImage, let item = localImageProvider.findObject(using: catImage) {
            localImageProvider.delete(item)
        }
    }
}
