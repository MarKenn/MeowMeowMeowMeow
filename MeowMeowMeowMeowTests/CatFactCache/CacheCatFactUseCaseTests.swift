//
//  CacheCatFactUseCaseTests.swift
//  MeowMeowMeowMeowTests
//
//  Created by Mark Kenneth Bayona on 9/25/25.
//

import XCTest
import MeowMeowMeowMeow

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
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()

        expect(sut, toCompleteWith: deletionError) {
            store.completeDeletion(with: deletionError)
        }
    }

    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()

        expect(sut, toCompleteWith: insertionError) {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        }
    }

    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: nil) {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        }
    }

    func test_save_doesNotDeliverDeletionErrorAfterInstanceHasBeenDeallocated() {
        let store = CatFactStoreSpy()
        var sut: LocalCatFactLoader? = LocalCatFactLoader(store: store, currentDate: Date.init)

        var receivedResults = [Error?]()
        sut?.save([anyFact()]) { receivedResults.append($0)}

        sut = nil
        store.completeDeletion(with: anyNSError())

        XCTAssert(receivedResults.isEmpty)
    }

    func test_save_doesNotDeliverInsertionErrorAfterInstanceHasBeenDeallocated() {
        let store = CatFactStoreSpy()
        var sut: LocalCatFactLoader? = LocalCatFactLoader(store: store, currentDate: Date.init)

        var receivedResults = [Error?]()
        sut?.save([anyFact()]) { receivedResults.append($0)}

        store.completeDeletionSuccessfully()
        sut = nil
        store.completeInsertion(with: anyNSError())

        XCTAssert(receivedResults.isEmpty)
    }

    // MARK: Helpers

    private func makeSUT(
        currentDate: @escaping () -> Date = Date.init,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (LocalCatFactLoader, CatFactStoreSpy) {
        let store = CatFactStoreSpy()
        let sut = LocalCatFactLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }

    private func expect(
        _ sut: LocalCatFactLoader,
        toCompleteWith expectedError: NSError?,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for save completion")

        var receivedError: Error?
        sut.save([anyFact(), anyFact()]) { error in
            receivedError = error
            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)

        XCTAssertEqual(receivedError as? NSError, expectedError, file: file, line: line)
    }

    private class CatFactStoreSpy: CatFactStore {
        enum ReceivedMessage: Equatable {
            case deleteCachedFacts
            case insert([String], Date)
        }

        private(set) var receivedMessages = [ReceivedMessage]()

        private var deletionCompletions = [DeleteCompletion]()
        private var insertionCompletions = [InsertCompletion]()

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

        func insert(_ facts: [String], timestamp: Date, completion: @escaping InsertCompletion) {
            receivedMessages.append(.insert(facts, timestamp))
            insertionCompletions.append(completion)
        }

        func completeInsertion(with error: Error, at index: Int = 0) {
            insertionCompletions[index](error)
        }

        func completeInsertionSuccessfully(at index: Int = 0) {
            insertionCompletions[index](nil)
        }
    }

    private func anyFact() -> String {
        "any fact \(Int.random(in: 1...5))"
    }

    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }

}
