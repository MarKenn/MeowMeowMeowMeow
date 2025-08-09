//
//  RemoteCatFactLoaderTests.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 8/7/25.
//

import XCTest
import MeowMeowMeowMeow

final class RemoteCatFactLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssert(client.requestedURLs.isEmpty)
    }

    func test_load_requestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load() { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load() { _ in }
        sut.load() { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        var capturedErrors = [RemoteCatFactLoader.Error]()
        sut.load { capturedErrors.append($0) }

        client.completions[0](NSError())

        XCTAssertEqual(capturedErrors, [.connectivity])
    }

    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        var completions = [(Error) -> Void]()

        func get(from url: URL, completion: @escaping (Error) -> Void) {
            requestedURLs.append(url)
            completions.append(completion)
        }
    }

    private func makeSUT(
        url: URL = URL(string: "https://a-url.com")!
    ) -> (sut: RemoteCatFactLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let remoteCatFactLoader = RemoteCatFactLoader(url: url, client: client)
        return (sut: remoteCatFactLoader, client: client)
    }
}
