//
//  MockImageProvider.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/8/25.
//

import CoreData
@testable import MeowMeowMeowMeow

class MockImageProvider: LocalCatImageProvider {
    var loadObjectsHasBeenCalled = false
    var saveHasBeenCalled = false
    var deleteHasBeenCalled = false
    var findHasBeenCalled = false
    var shoudlProceedToDelete = false

    override func loadObjects() {
        loadObjectsHasBeenCalled = true
        objectsPublisher = [CatImage(id: "", url: "", width: 1, height: 1)]
    }

    override func save(_ models: [any Persistable]) {
        saveHasBeenCalled = true
    }

    override func delete(_ item: NSManagedObject) {
        deleteHasBeenCalled = true
    }

    override func findObject(using: CatImage) -> CatImagePersisted? {
        findHasBeenCalled = true
        return shoudlProceedToDelete ? CatImagePersisted() : nil
    }
}
