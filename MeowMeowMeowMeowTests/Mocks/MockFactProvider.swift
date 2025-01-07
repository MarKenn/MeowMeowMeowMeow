//
//  MockFactProvider.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/8/25.
//

import CoreData
@testable import MeowMeowMeowMeow

class MockFactProvider: LocalMeowFactProvider {
    var loadObjectsHasBeenCalled = false
    var saveHasBeenCalled = false
    var deleteHasBeenCalled = false
    var findHasBeenCalled = false
    var shoudlProceedToDelete = false

    override func loadObjects() {
        loadObjectsHasBeenCalled = true
        objectsPublisher = ["test"]
    }

    override func save(_ models: [any Persistable]) {
        saveHasBeenCalled = true
    }

    override func delete(_ item: NSManagedObject) {
        deleteHasBeenCalled = true
    }

    override func findObject(using: String) -> MeowFactPersisted? {
        findHasBeenCalled = true
        return shoudlProceedToDelete ? MeowFactPersisted() : nil
    }
}
