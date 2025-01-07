//
//  WildCatViewModelTests.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//

import XCTest
@testable import MeowMeowMeowMeow

final class WildCatViewModelTests: XCTestCase {

    var viewModel: WildCatView.Model!

    var testRepository = TestRepository()

    enum RepositoryError : Error {
        case factError
        case imageError
    }
    class TestRepository: WildCatDataSource {
        var shouldFail: Bool = false
        var getMeowFactHasBeenCalled = false
        var getCatImageHasBeenCalled = false
        var domesticateHasBeenCalled = false
        var downloadCatUIImageHasBeenCalled = false

        func getMeowFact() async -> Result<String?, any Error> {
            getMeowFactHasBeenCalled = true
            return shouldFail ? .failure(RepositoryError.factError) : .success("Meow!")
        }

        func getCatImage() async -> Result<MeowMeowMeowMeow.CatImage?, any Error> {
            getCatImageHasBeenCalled = true
            return shouldFail
            ? .failure(RepositoryError.imageError)
            : .success(CatImage(id: "testId", url: "testString", width: 50, height: 50))
        }

        func domesticate(meowFact: String?, catImage: MeowMeowMeowMeow.CatImage?) {
            domesticateHasBeenCalled = true
        }

        func downloadCatUIImage(from urlString: String) async -> UIImage? {
            downloadCatUIImageHasBeenCalled = true
            return UIImage()
        }
    }

    override func setUp() {
        testRepository = TestRepository()
        viewModel = WildCatView.Model(repository: testRepository)
    }

    func testGetMeowFact() async {
        XCTAssertFalse(testRepository.getMeowFactHasBeenCalled)
        XCTAssertNil(viewModel.error)

        await viewModel.getMeowFact()

        XCTAssert(testRepository.getMeowFactHasBeenCalled)
        XCTAssertNil(viewModel.error)
    }

    func testGetMeowFactShouldFail() async {
        XCTAssertFalse(testRepository.getMeowFactHasBeenCalled)
        XCTAssertNil(viewModel.error)

        testRepository.shouldFail = true
        await viewModel.getMeowFact()

        XCTAssert(testRepository.getMeowFactHasBeenCalled)
        XCTAssertEqual(
            viewModel.error as? RepositoryError, RepositoryError.factError)
    }

    func testGetCatImage() async {
        XCTAssertFalse(testRepository.getCatImageHasBeenCalled)
        XCTAssertNil(viewModel.error)

        await viewModel.getCatImage()

        XCTAssert(testRepository.getCatImageHasBeenCalled)
        XCTAssertNil(viewModel.error)
    }

    func testGetCatImageShouldFail() async {
        XCTAssertFalse(testRepository.getCatImageHasBeenCalled)
        XCTAssertNil(viewModel.error)

        testRepository.shouldFail = true
        await viewModel.getCatImage()

        XCTAssert(testRepository.getCatImageHasBeenCalled)
        XCTAssertEqual(
            viewModel.error as? RepositoryError, RepositoryError.imageError)
    }

    func testDomesticate() {
        XCTAssertFalse(testRepository.domesticateHasBeenCalled)

        viewModel.domesticate()

        XCTAssert(testRepository.domesticateHasBeenCalled)
    }

    func testDownloadCatUIImageCatImageURLIsNil() async {
        XCTAssertFalse(testRepository.downloadCatUIImageHasBeenCalled)
        XCTAssertNil(viewModel.catImage?.url)

        await viewModel.downloadCatUIImage()

        XCTAssertFalse(testRepository.downloadCatUIImageHasBeenCalled)
    }

    func testdownloadCatUIImage() async {
        viewModel.catImage = CatImage(id: "testId", url: "testURL", width: 1, height: 1)
        XCTAssertFalse(testRepository.downloadCatUIImageHasBeenCalled)
        XCTAssertNotNil(viewModel.catImage?.url)

        await viewModel.downloadCatUIImage()

        XCTAssert(testRepository.downloadCatUIImageHasBeenCalled)
    }
}
