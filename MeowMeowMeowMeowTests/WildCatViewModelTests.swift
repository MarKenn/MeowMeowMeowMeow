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
    case generic
    }
    class TestRepository: WildCatDataSource {
        var shouldFail: Bool = false
        var getMeowFactHasBeenCalled = false

        func getMeowFact() async -> Result<String?, any Error> {
            getMeowFactHasBeenCalled = true
            return shouldFail ? .failure(RepositoryError.generic) : .success("Meow!")
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
        XCTAssert(viewModel.error is WildCatViewModelTests.RepositoryError)
    }
}
