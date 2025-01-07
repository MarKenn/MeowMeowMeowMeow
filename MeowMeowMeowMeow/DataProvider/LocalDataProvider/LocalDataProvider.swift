//
//  LocalDataProvider.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//

import CoreData

// Data Provider utilizing CoreDataService
protocol LocalDataProvider: NSObject {
    /// Generic for the CoreData entity being processed
    associatedtype Object: NSManagedObject

    /// Generic for the Codable object requirement of the provider
    associatedtype ModelType: Codable

    //// Custom CoreData service
    var data: CoreDataService { get }

    /// Should be used as the publisher after transforming the CoreData objects
    var objectsPublisher: [ModelType] { get set }

    /// Objects fetch from the local db
    var fetchedObjects: [Object] { get set }

    /// CoreData
    var fetchedResultsController: NSFetchedResultsController<Object>! { get set }
    func fetchRequest() -> NSFetchRequest<Object>

    /// Generic transactions
    func loadObjects()
    func save(_ models: [any Persistable])
    func delete(_ item: NSManagedObject)
    func findObject(using: ModelType) -> Object?
}

extension LocalDataProvider {
    var data: CoreDataService {
        CoreDataService.shared
    }

    /// Fetches array of type `Object` from the local db and sets it to the fetchedObjects property
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

    
    /// Converts an array of `Persistable` models to CoreData entities, saves it  to the local db, and then loads it using loadObjects()
    /// - Parameter models: array of `Persistable`
    func defaultSave(_ models: [any Persistable]) {
        for model in models {
            let leadPersistable = model.toPersistable(in: data.pendingChangesContext)
            print(leadPersistable)
        }

        data.saveContext()
        loadObjects()
    }

    
    /// Deletes a CoreData entity item from the local db
    /// - Parameter item: CoreData entity to delete
    func defaultDelete(_ item: NSManagedObject) {
        data.container.viewContext.delete(item)

        data.saveContext()
        loadObjects()
    }
}
