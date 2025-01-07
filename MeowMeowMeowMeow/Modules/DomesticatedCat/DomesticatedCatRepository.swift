//
//  DomesticatedCatRepository.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//

import Foundation
import Combine
import CoreData

protocol DomesticatedCatDataSource {
    func fetchDomesticatedCats()
    func setFree(fact: MeowFactPersisted?, catImage: CatImagePersisted?)
}

class DomesticatedCatRepository: DomesticatedCatDataSource {
    var localFactProvider = LocalMeowFactProvider()
    var localImageProvider = LocalCatImageProvider()

    @Published
    var domesticatedCatFacts = [MeowFactPersisted]()

    @Published
    var domesticatedCatImageURLs = [CatImagePersisted]()

    var localFactSubscriber: AnyCancellable?
    var localImageSubscriber: AnyCancellable?

    init() {
        localFactSubscriber = localFactProvider.$objectsPublisher.sink { items in
            self.domesticatedCatFacts = items.filter { $0.fact != nil }
        }

        localImageSubscriber = localImageProvider.$objectsPublisher.sink { items in
            self.domesticatedCatImageURLs = items.filter { $0.url != nil }
        }
    }

    func fetchDomesticatedCats() {
        localFactProvider.loadObjects()
        localImageProvider.loadObjects()
    }

    func setFree(fact: MeowFactPersisted?, catImage: CatImagePersisted?) {
        if let fact {
            localFactProvider.delete(fact)
        }

        if let catImage {
            localImageProvider.delete(catImage)
        }
    }
}

class LocalMeowFactProvider: NSObject, LocalDataProvider {
    @Published
    var objectsPublisher = [MeowFactPersisted]()

    var fetchedResultsController: NSFetchedResultsController<MeowFactPersisted>!

    func fetchRequest() -> NSFetchRequest<MeowFactPersisted> {
        MeowFactPersisted.fetchRequest()
    }
}

class LocalCatImageProvider: NSObject, LocalDataProvider {
    @Published
    var objectsPublisher = [CatImagePersisted]()

    var fetchedResultsController: NSFetchedResultsController<CatImagePersisted>!

    func fetchRequest() -> NSFetchRequest<CatImagePersisted> {
        CatImagePersisted.fetchRequest()
    }
}
