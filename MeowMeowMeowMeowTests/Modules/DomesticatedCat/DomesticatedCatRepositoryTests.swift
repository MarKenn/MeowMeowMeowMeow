//
//  DomesticatedCatRepositoryTests.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/8/25.
//

import XCTest
import CoreData
@testable import MeowMeowMeowMeow

final class DomesticatedCatRepositoryTests: XCTestCase {

    var repository: DomesticatedCatRepository!

    var mockFactProvider = MockFactProvider()
    var mockImageProvider = MockImageProvider()

    override func setUp() {
        mockFactProvider = MockFactProvider()
        mockImageProvider = MockImageProvider()
        repository = DomesticatedCatRepository(
            factProvider: mockFactProvider,
            imageProvider: mockImageProvider
        )
    }

    func testSubscribers() {
        XCTAssert(repository.domesticatedCatFacts.isEmpty)
        XCTAssert(repository.domesticatedCatImages.isEmpty)

        mockFactProvider.loadObjects()
        XCTAssertFalse(repository.domesticatedCatFacts.isEmpty)

        mockImageProvider.loadObjects()
        XCTAssertFalse(repository.domesticatedCatImages.isEmpty)
    }

    func testFetchDomesticatedCats() {
        XCTAssertFalse(mockFactProvider.loadObjectsHasBeenCalled)
        XCTAssertFalse(mockImageProvider.loadObjectsHasBeenCalled)

        repository.fetchDomesticatedCats()

        XCTAssert(mockFactProvider.loadObjectsHasBeenCalled)
        XCTAssert(mockImageProvider.loadObjectsHasBeenCalled)
    }

    func testSetFreeBothNil() {
        XCTAssertFalse(mockFactProvider.findHasBeenCalled)
        XCTAssertFalse(mockImageProvider.findHasBeenCalled)

        repository.setFree(fact: nil, catImage: nil)

        XCTAssertFalse(mockFactProvider.findHasBeenCalled)
        XCTAssertFalse(mockImageProvider.findHasBeenCalled)
    }

    func testSetFreeBothValued() {
        XCTAssertFalse(mockFactProvider.findHasBeenCalled)
        XCTAssertFalse(mockImageProvider.findHasBeenCalled)


        repository.setFree(
            fact: "Fact",
            catImage: CatImage(id: "id", url: "url", width: 1, height: 1))

        XCTAssert(mockFactProvider.findHasBeenCalled)
        XCTAssert(mockImageProvider.findHasBeenCalled)
    }

    func testSetFreeProceedsToDelete() {
        XCTAssertFalse(mockFactProvider.deleteHasBeenCalled)
        XCTAssertFalse(mockImageProvider.deleteHasBeenCalled)

        mockFactProvider.shoudlProceedToDelete = true
        mockImageProvider.shoudlProceedToDelete = true
        repository.setFree(
            fact: "Fact",
            catImage: CatImage(id: "id", url: "url", width: 1, height: 1))

        XCTAssert(mockFactProvider.deleteHasBeenCalled)
        XCTAssert(mockImageProvider.deleteHasBeenCalled)
    }
}
