//
//  MeowFactAPIEndToEndTests.swift
//  MeowFactAPIEndToEndTests
//
//  Created by Mark Kenneth Bayona on 8/26/25.
//

import XCTest
import MeowMeowMeowMeow

final class MeowFactAPIEndToEndTests: XCTestCase {

    func test_endToEndServerGETCatFact_isNotEmpty() {
        switch getCatFact() {
        case .success(let catFact):
            let trimmedFact = catFact.trimmingCharacters(in: .whitespacesAndNewlines)
            XCTAssertFalse(trimmedFact.isEmpty)
        case .failure(let error):
            XCTFail("Expecting success, got \(error) instead")
        case .none:
            XCTFail("Expecting success, got no instead")
        }
    }

    // MARK: - Helpers

    func getCatFact(file: StaticString = #filePath, line: UInt = #line) -> RemoteCatFactLoader.Result? {
        let url = URL(string: "https://meowfacts.herokuapp.com/")!
        let client = URLSessionHTTPClient()
        let loader = RemoteCatFactLoader(url: url, client: client)

        trackFOrMemoryLeaks(client, file: file, line: line)
        trackFOrMemoryLeaks(loader, file: file, line: line)

        let exp = expectation(description: "Wait for load completion")

        var receivedResult: RemoteCatFactLoader.Result?
        loader.load { result in
            receivedResult = result

            exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)
        return receivedResult
    }

}
