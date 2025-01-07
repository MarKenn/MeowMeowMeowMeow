//
//  WildCatRepositoryTests.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/8/25.
//

import XCTest
import CoreData
@testable import MeowMeowMeowMeow

final class WildCatRepositoryTests: XCTestCase {

    var repository: WildCatRepository!

    var mockRemoteProvider = MockRemoteProvider()
    var mockFactProvider = MockFactProvider()
    var mockImageProvider = MockImageProvider()

    enum MockRemoteError : Error {
        case cancelled
    }

    class MockRemoteProvider: RemoteMeowProvider {
        var getRandomMeowFactHasBeenCalled = false
        var getRandomCatImageHasBeenCalled = false
        var downloadCatUIImageHasBeenCalled = false
        var shouldFail = false

        let testMeowFactData = MeowFactData(data: ["test data 123123"])
        let testCatImage = CatImage(id: "id", url: "url", width: 1, height: 1)
        let testUIImage = UIImage(
            systemName: "square.and.arrow.up.trianglebadge.exclamationmark.fill")

        override func getRandomMeowFact() async -> Result<MeowFactData, Error> {
            getRandomMeowFactHasBeenCalled = true
            return shouldFail
            ? .failure(MockRemoteError.cancelled)
            : .success(testMeowFactData)
        }

        override func getRandomCatImage() async -> Result<[CatImage], Error> {
            getRandomCatImageHasBeenCalled = true
            return shouldFail
            ? .failure(MockRemoteError.cancelled)
            : .success([testCatImage])
        }

        override func downloadCatUIImage(from urlString: String) async -> UIImage? {
            downloadCatUIImageHasBeenCalled = true

            return shouldFail ? nil : testUIImage
        }
    }

    override func setUp() {
        mockRemoteProvider = MockRemoteProvider()
        mockFactProvider = MockFactProvider()
        mockImageProvider = MockImageProvider()

        repository = WildCatRepository(
            remoteProvider: mockRemoteProvider,
            factProvider: mockFactProvider,
            imageProvider: mockImageProvider
        )
    }

    func testGetMeowFact() async {
        XCTAssertFalse(mockRemoteProvider.getRandomMeowFactHasBeenCalled)

        let result = await repository.getMeowFact()

        XCTAssert(mockRemoteProvider.getRandomMeowFactHasBeenCalled)

        switch result {
        case .success(let data):
            XCTAssertEqual(data, mockRemoteProvider.testMeowFactData.data.first)
        case .failure:
            XCTFail("Expected success, but got failure")
        }
    }

    func testGetMeowFactShouldFail() async {
        XCTAssertFalse(mockRemoteProvider.getRandomMeowFactHasBeenCalled)

        mockRemoteProvider.shouldFail = true
        let result = await repository.getMeowFact()

        XCTAssert(mockRemoteProvider.getRandomMeowFactHasBeenCalled)

        switch result {
        case .success:
            XCTFail("Expected failure, but got success")
        case .failure(let error):
            XCTAssertEqual(error as! MockRemoteError, MockRemoteError.cancelled)
        }
    }

    func testGetCatImage() async {
        XCTAssertFalse(mockRemoteProvider.getRandomCatImageHasBeenCalled)

        let result = await repository.getCatImage()

        XCTAssert(mockRemoteProvider.getRandomCatImageHasBeenCalled)

        switch result {
        case .success(let data):
            XCTAssertEqual(data, mockRemoteProvider.testCatImage)
        case .failure:
            XCTFail("Expected success, but got failure")
        }
    }

    func testGetCatImageShouldFail() async {
        XCTAssertFalse(mockRemoteProvider.getRandomCatImageHasBeenCalled)

        mockRemoteProvider.shouldFail = true
        let result = await repository.getCatImage()

        XCTAssert(mockRemoteProvider.getRandomCatImageHasBeenCalled)

        switch result {
        case .success:
            XCTFail("Expected failure, but got success")
        case .failure(let error):
            XCTAssertEqual(error as! MockRemoteError, MockRemoteError.cancelled)
        }
    }

    func testDownloadCatUIImage() async {
        XCTAssertFalse(mockRemoteProvider.downloadCatUIImageHasBeenCalled)

        let result = await repository.downloadCatUIImage(from: "testURL")

        XCTAssert(mockRemoteProvider.downloadCatUIImageHasBeenCalled)
        XCTAssertEqual(result, mockRemoteProvider.testUIImage)
    }

    func testDownloadCatUIImageShouldFail() async {
        XCTAssertFalse(mockRemoteProvider.downloadCatUIImageHasBeenCalled)

        mockRemoteProvider.shouldFail = true
        let result = await repository.downloadCatUIImage(from: "testURL")

        XCTAssert(mockRemoteProvider.downloadCatUIImageHasBeenCalled)
        XCTAssertNil(result)
    }

    func testDomesticateBothNil() {
        XCTAssertFalse(mockFactProvider.saveHasBeenCalled)
        XCTAssertFalse(mockImageProvider.saveHasBeenCalled)

        repository.domesticate(meowFact: nil, catImage: nil)

        XCTAssertFalse(mockFactProvider.saveHasBeenCalled)
        XCTAssertFalse(mockImageProvider.saveHasBeenCalled)
    }

    func testDomesticateBothValued() {
        XCTAssertFalse(mockFactProvider.saveHasBeenCalled)
        XCTAssertFalse(mockImageProvider.saveHasBeenCalled)

        repository.domesticate(
            meowFact: "test fact",
            catImage: mockRemoteProvider.testCatImage)

        XCTAssert(mockFactProvider.saveHasBeenCalled)
        XCTAssert(mockImageProvider.saveHasBeenCalled)
    }
}
