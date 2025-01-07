//
//  LocalCatImageProvider.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/8/25.
//

import CoreData

class LocalCatImageProvider: NSObject, LocalDataProvider {
    @Published
    var objectsPublisher = [CatImage]()

    var fetchedObjects: [CatImagePersisted] = [] {
        didSet {
            objectsPublisher = fetchedObjects.map { $0.toModel() }
        }
    }

    var fetchedResultsController: NSFetchedResultsController<CatImagePersisted>!

    func fetchRequest() -> NSFetchRequest<CatImagePersisted> {
        CatImagePersisted.fetchRequest()
    }

    func findObject(using: CatImage) -> CatImagePersisted? {
        fetchedObjects.first(where: { $0.url == using.url })
    }

    func loadObjects() {
        defaultLoadObjects()
    }

    func save(_ models: [any Persistable]) {
        defaultSave(models)
    }

    func delete(_ item: NSManagedObject) {
        defaultDelete(item)
    }
}
