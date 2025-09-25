//
//  CacheCatFactUseCaseTests.swift
//  MeowMeowMeowMeowTests
//
//  Created by Mark Kenneth Bayona on 9/25/25.
//

import XCTest

class LocalCatFactLoader {
  let store: CatFactStore

  init(store: CatFactStore) {
    self.store = store
  }

  func save(_ catFacts: [String]) {
    store.deleteCachedCatFacts()
  }
}

class CatFactStore {
  var deleteCachedCatFactsCount = 0

  func deleteCachedCatFacts() {
    deleteCachedCatFactsCount += 1
  }
}

final class CacheCatFactUseCaseTests: XCTestCase {

  func test_init_doesNotDeleteCacheUponCreation() {
    let (_, store) = makeSUT()

    XCTAssertEqual(store.deleteCachedCatFactsCount, 0)
  }

  func test_save_requestsCacheDeletion() {
    let catFacts: [String] = ["Cat fact", "Cat fact 2"]
    let (sut, store) = makeSUT()

    sut.save(catFacts)

    XCTAssertEqual(store.deleteCachedCatFactsCount, 1)
  }

  // MARK: Helpers

  func makeSUT() -> (LocalCatFactLoader, CatFactStore) {
    let store = CatFactStore()
    let sut = LocalCatFactLoader(store: store)

    return (sut, store)
  }

}
