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
        let url = URL(string: "https://meowfacts.herokuapp.com/")!
        let client = URLSessionHTTPClient()
        let loader = RemoteCatFactLoader(url: url, client: client)

        let exp = expectation(description: "Wait for load completion")

        var receivedResult: RemoteCatFactLoader.Result?
        loader.load { result in
            receivedResult = result

            exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)

        switch receivedResult {
        case .success(let catFact):
            let trimmedFact = catFact.trimmingCharacters(in: .whitespacesAndNewlines)
            XCTAssertFalse(trimmedFact.isEmpty)
        default:
            XCTFail("Expecting success, got \(String(describing: receivedResult)) instead")
        }
    }

}
