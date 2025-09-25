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
  var insertCallCount = 0

  func deleteCachedCatFacts() {
    deleteCachedCatFactsCount += 1
  }

  func completeDeletion(with error: NSError) {

  }
}

final class CacheCatFactUseCaseTests: XCTestCase {

  func test_init_doesNotDeleteCacheUponCreation() {
    let (_, store) = makeSUT()

    XCTAssertEqual(store.deleteCachedCatFactsCount, 0)
  }

  func test_save_requestsCacheDeletion() {
    let catFacts: [String] = [anyFact(), anyFact()]
    let (sut, store) = makeSUT()

    sut.save(catFacts)

    XCTAssertEqual(store.deleteCachedCatFactsCount, 1)
  }

  func test_save_doesNotRequestsCacheInsertionOnDeletionError() {
    let catFacts: [String] = [anyFact(), anyFact()]
    let (sut, store) = makeSUT()
    let deletionError = anyNSError()

    sut.save(catFacts)
    store.completeDeletion(with: deletionError)

    XCTAssertEqual(store.insertCallCount, 0)
  }

  // MARK: Helpers

  private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (LocalCatFactLoader, CatFactStore) {
    let store = CatFactStore()
    let sut = LocalCatFactLoader(store: store)
    trackForMemoryLeaks(store, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return (sut, store)
  }

   private func anyFact() -> String {
     "any fact \(Int.random(in: 1...5))"
  }

  private func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
  }

}
