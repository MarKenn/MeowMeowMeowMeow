//
//  DomesticatedCatViewModelTests.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//

import XCTest
@testable import MeowMeowMeowMeow

final class DomesticatedCatViewModelTests: XCTestCase {

    var viewModel: DomesticatedCatView.Model!
    
    var mockRepository = MockRepository()

    class MockRepository: DomesticatedCatDataSource {
        var domesticatedCatsHasBeenCalled = false
        var setFreeHasBeenCalled = false

        func fetchDomesticatedCats() {
            domesticatedCatsHasBeenCalled = true
        }

        func setFree(fact: MeowMeowMeowMeow.MeowFactPersisted?, catImage: MeowMeowMeowMeow.CatImagePersisted?) {
            setFreeHasBeenCalled = true
        }
    }

    override func setUp() {
        mockRepository = MockRepository()
        viewModel = DomesticatedCatView.Model(repository: mockRepository)
    }

    func testFetchDomesticatedCats() {
        XCTAssertFalse(mockRepository.domesticatedCatsHasBeenCalled)

        viewModel.fetchDomesticatedCats()

        XCTAssert(mockRepository.domesticatedCatsHasBeenCalled)
    }

    func testSetFree() {
        XCTAssertFalse(mockRepository.setFreeHasBeenCalled)

        viewModel.setFree()

        XCTAssert(mockRepository.setFreeHasBeenCalled)
    }

    func testRandomizeDomesticatedCat() {
        XCTAssertNil(viewModel.selectedMeowFact)
        XCTAssertNil(viewModel.selectedCatImage)

        viewModel.randomizeDomesticatedCat()
        
        XCTAssertNil(viewModel.selectedMeowFact)
        XCTAssertNil(viewModel.selectedCatImage)
    }

    func testRandomizeDomesticatedCatWithValues() {
        viewModel.catImages = [CatImagePersisted()]
        viewModel.meowFacts = [MeowFactPersisted()]

        XCTAssertNil(viewModel.selectedMeowFact)
        XCTAssertNil(viewModel.selectedCatImage)

        viewModel.randomizeDomesticatedCat()

        XCTAssertNotNil(viewModel.selectedMeowFact)
        XCTAssertNotNil(viewModel.selectedCatImage)
    }
}
