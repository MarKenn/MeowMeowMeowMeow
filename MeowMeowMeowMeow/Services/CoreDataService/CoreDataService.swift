//
//  CoreDataService.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//

import CoreData

class CoreDataService {
    private init() {}
    static let shared = CoreDataService()
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }

#if DEBUG
        // If you have multiple stores saved in different directories, you need to print them out one by one
        if let url = container.persistentStoreCoordinator.persistentStores.first?.url {
            print("CoreData - db path: \(url)")
        }
#endif

        return container
    }()

    var mainViewContext: NSManagedObjectContext {
        container.viewContext
    }

    lazy var pendingChangesContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(.privateQueue)
        context.persistentStoreCoordinator = container.persistentStoreCoordinator
        return context
    }()

    func saveContext() {
        if pendingChangesContext.hasChanges {
            do {
                try pendingChangesContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        } else if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
}
