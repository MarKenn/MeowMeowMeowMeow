//
//  LocalDataProvider.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//

import CoreData

protocol LocalDataProvider: NSObject {
    associatedtype Object: NSManagedObject

    var data: CoreDataService { get }
    var objectsPublisher: [Object] { get set }

    var fetchedResultsController: NSFetchedResultsController<Object>! { get set }
    func fetchRequest() -> NSFetchRequest<Object>
}

extension LocalDataProvider {
    var data: CoreDataService {
        CoreDataService.shared
    }

    func loadObjects() {
        if fetchedResultsController == nil {
            let localRequest = fetchRequest()
            let sort = NSSortDescriptor(key: "fact", ascending: true)
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
                objectsPublisher = fetchedObjects
            }
        } catch {
            assert(false, "Fetch for objects failed \(error)")
        }
    }

    func save(_ models: [any Persistable]) {
        for model in models {
            let leadPersistable = model.toPersistable(in: data.pendingChangesContext)
            print(leadPersistable)
        }

        data.saveContext()
        loadObjects()
    }
}
