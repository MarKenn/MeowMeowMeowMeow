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
}

class CatFactStore {
  var deleteCachedCatFactsCount = 0
}

final class CacheCatFactUseCaseTests: XCTestCase {

  func test_init_doesNotDeleteCacheUponCreation() {
    let store = CatFactStore()
    _ = LocalCatFactLoader(store: store)

    XCTAssertEqual(store.deleteCachedCatFactsCount, 0)
  }

}
