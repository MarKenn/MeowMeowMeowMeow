//
//  LocalDataProvider.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//

import CoreData

protocol LocalDataProvider: NSObject {
    associatedtype Object: NSManagedObject
    associatedtype ModelType: Codable

    var data: CoreDataService { get }
    var objectsPublisher: [ModelType] { get set }
    var fetchedObjects: [Object] { get set }

    var fetchedResultsController: NSFetchedResultsController<Object>! { get set }
    func fetchRequest() -> NSFetchRequest<Object>

    func loadObjects()
    func save(_ models: [any Persistable])
    func delete(_ item: NSManagedObject)
    func findObject(using: ModelType) -> Object?
}

extension LocalDataProvider {
    var data: CoreDataService {
        CoreDataService.shared
    }

    func defaultLoadObjects() {
        if fetchedResultsController == nil {
            let localRequest = fetchRequest()
            let sort = NSSortDescriptor(key: "dateCreated", ascending: true)
            localRequest.sortDescriptors = [sort]

            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: localRequest,
                managedObjectContext: data.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil)
        }

        do {
            try fetchedResultsController.performFetch()

            if let fetchedObjects = fetchedResultsController.fetchedObjects {
                self.fetchedObjects = fetchedObjects
            }
        } catch {
            assert(false, "Fetch for objects failed \(error)")
        }
    }

    func defaultSave(_ models: [any Persistable]) {
        for model in models {
            let leadPersistable = model.toPersistable(in: data.pendingChangesContext)
            print(leadPersistable)
        }

        data.saveContext()
        loadObjects()
    }

    func defaultDelete(_ item: NSManagedObject) {

        data.container.viewContext.delete(item)

        data.saveContext()
        loadObjects()
    }
}
