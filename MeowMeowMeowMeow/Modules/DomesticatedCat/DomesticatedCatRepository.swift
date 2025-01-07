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
    
    /// Subscribed to localFactProvider
    @Published
    var domesticatedCatFacts = [String]()

    /// Subscribed to localImageProvider
    @Published
    var domesticatedCatImages = [CatImage]()

    /// Subscribers
    var localFactSubscriber: AnyCancellable?
    var localImageSubscriber: AnyCancellable?

    init(
        factProvider: LocalMeowFactProvider =  LocalMeowFactProvider(),
        imageProvider: LocalCatImageProvider = LocalCatImageProvider()
    ) {
        self.localFactProvider = factProvider
        self.localImageProvider = imageProvider

        // Facts subscriber
        localFactSubscriber = localFactProvider.$objectsPublisher.sink { items in
            self.domesticatedCatFacts = items
        }

        // Images subscriber
        localImageSubscriber = localImageProvider.$objectsPublisher.sink { items in
            self.domesticatedCatImages = items
        }
    }

    /// Trigger reloads for facts and images
    func fetchDomesticatedCats() {
        localFactProvider.loadObjects()
        localImageProvider.loadObjects()
    }
    
    /// Removes the fact and image from local db if they are found on the providers using findObject(using:)
    /// - Parameters:
    ///   - fact: fact to remove
    ///   - catImage: catImage to remove
    func setFree(fact: String?, catImage: CatImage?) {
        if let fact, let item = localFactProvider.findObject(using: fact) {
            localFactProvider.delete(item)
        }

        if let catImage, let item = localImageProvider.findObject(using: catImage) {
            localImageProvider.delete(item)
        }
    }
}
