//
//  CacheCatFactUseCaseTests.swift
//  MeowMeowMeowMeowTests
//
//  Created by Mark Kenneth Bayona on 9/25/25.
//

import XCTest

class LocalCatFactLoader {
  private let store: CatFactStore
  private let currentDate: () -> Date

  init(store: CatFactStore, currentDate: @escaping () -> Date) {
    self.store = store
    self.currentDate = currentDate
  }

  func save(_ facts: [String]) {
    store.deleteCachedFacts { [unowned self] error in
      if error == nil {
        store.insert(facts, timestamp: currentDate())
      }
    }
  }
}

class CatFactStore {
  typealias DeleteCompletion = (Error?) -> Void

  var deleteCachedFactsCount = 0
  var insertions = [(facts: [String], timestamp: Date)]()

  private var deletionCompletions = [DeleteCompletion]()

  func deleteCachedFacts(completion: @escaping DeleteCompletion) {
    deleteCachedFactsCount += 1
    deletionCompletions.append(completion)
  }

  func completeDeletion(with error: Error, at index: Int = 0) {
    deletionCompletions[index](error)
  }

  func completeDeletionSuccessfully(at index: Int = 0) {
    deletionCompletions[index](nil)
  }

  func insert(_ facts: [String], timestamp: Date) {
    insertions.append((facts, timestamp))
  }
}

final class CacheCatFactUseCaseTests: XCTestCase {

  func test_init_doesNotDeleteCacheUponCreation() {
    let (_, store) = makeSUT()

    XCTAssertEqual(store.deleteCachedFactsCount, 0)
  }

  func test_save_requestsCacheDeletion() {
    let facts: [String] = [anyFact(), anyFact()]
    let (sut, store) = makeSUT()

    sut.save(facts)

    XCTAssertEqual(store.deleteCachedFactsCount, 1)
  }

  func test_save_doesNotRequestsCacheInsertionOnDeletionError() {
    let facts: [String] = [anyFact(), anyFact()]
    let (sut, store) = makeSUT()
    let deletionError = anyNSError()

    sut.save(facts)
    store.completeDeletion(with: deletionError)

    XCTAssertEqual(store.insertions.count, 0)
  }

  func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
    let currentDate = Date()
    let facts: [String] = [anyFact(), anyFact()]
    let (sut, store) = makeSUT(currentDate: { currentDate })

    sut.save(facts)
    store.completeDeletionSuccessfully()

    XCTAssertEqual(store.insertions.count, 1)
    XCTAssertEqual(store.insertions.first?.facts, facts)
    XCTAssertEqual(store.insertions.first?.timestamp, currentDate)
  }

  // MARK: Helpers

  private func makeSUT(
    currentDate: @escaping () -> Date = Date.init,
    file: StaticString = #filePath,
    line: UInt = #line
  ) -> (LocalCatFactLoader, CatFactStore) {
    let store = CatFactStore()
    let sut = LocalCatFactLoader(store: store, currentDate: currentDate)
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
