//
//  LocalMeowFactProvider.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/8/25.
//

import CoreData

class LocalMeowFactProvider: NSObject, LocalDataProvider {
    @Published
    var objectsPublisher = [String]()

    var fetchedObjects: [MeowFactPersisted] = [] {
        didSet {
            objectsPublisher = fetchedObjects.map { $0.fact }
        }
    }

    var fetchedResultsController: NSFetchedResultsController<MeowFactPersisted>!

    func fetchRequest() -> NSFetchRequest<MeowFactPersisted> {
        MeowFactPersisted.fetchRequest()
    }

    func findObject(using: String) -> MeowFactPersisted? {
        fetchedObjects.first(where: { $0.fact == using })
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
