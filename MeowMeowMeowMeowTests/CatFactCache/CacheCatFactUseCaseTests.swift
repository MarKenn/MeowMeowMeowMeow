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

  func save(_ facts: [String], completion: @escaping (Error?) -> Void) {
    store.deleteCachedFacts { [unowned self] error in
      if error == nil {
        store.insert(facts, timestamp: currentDate())
      } else {
        completion(error)
      }
    }
  }
}

class CatFactStore {
  typealias DeleteCompletion = (Error?) -> Void

  enum ReceivedMessage: Equatable {
    case deleteCachedFacts
    case insert([String], Date)
  }

  private(set) var receivedMessages = [ReceivedMessage]()

  private var deletionCompletions = [DeleteCompletion]()

  func deleteCachedFacts(completion: @escaping DeleteCompletion) {
    receivedMessages.append(.deleteCachedFacts)
    deletionCompletions.append(completion)
  }

  func completeDeletion(with error: Error, at index: Int = 0) {
    deletionCompletions[index](error)
  }

  func completeDeletionSuccessfully(at index: Int = 0) {
    deletionCompletions[index](nil)
  }

  func insert(_ facts: [String], timestamp: Date) {
    receivedMessages.append(.insert(facts, timestamp))
  }
}

final class CacheCatFactUseCaseTests: XCTestCase {

  func test_init_doesNotDeleteCacheUponCreation() {
    let (_, store) = makeSUT()

    XCTAssertEqual(store.receivedMessages, [])
  }

  func test_save_requestsCacheDeletion() {
    let facts: [String] = [anyFact(), anyFact()]
    let (sut, store) = makeSUT()

    sut.save(facts) { _ in }

    XCTAssertEqual(store.receivedMessages, [.deleteCachedFacts])
  }

  func test_save_doesNotRequestsCacheInsertionOnDeletionError() {
    let facts: [String] = [anyFact(), anyFact()]
    let (sut, store) = makeSUT()
    let deletionError = anyNSError()

    sut.save(facts) { _ in }
    store.completeDeletion(with: deletionError)

    XCTAssertEqual(store.receivedMessages, [.deleteCachedFacts])
  }

  func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
    let currentDate = Date()
    let facts: [String] = [anyFact(), anyFact()]
    let (sut, store) = makeSUT(currentDate: { currentDate })

    sut.save(facts) { _ in }
    store.completeDeletionSuccessfully()

    XCTAssertEqual(store.receivedMessages, [.deleteCachedFacts, .insert(facts, currentDate)])
  }

  func test_save_failsOnDeletionError() {
    let facts: [String] = [anyFact(), anyFact()]
    let (sut, store) = makeSUT()
    let deletionError = anyNSError()
    let exp = expectation(description: "Wait for save completion")

    var receivedError: Error?
    sut.save(facts) { error in
      receivedError = error
      exp.fulfill()
    }

    store.completeDeletion(with: deletionError)
    wait(for: [exp], timeout: 1.0)

    XCTAssertEqual(receivedError as? NSError, deletionError)
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
