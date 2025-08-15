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

        expect(sut, toCompleteWithError: .connectivity) {
            client.complete(with: NSError())
        }
    }

    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWithError: .invalidData) {
                client.complete(withStatus: code, at: index)
            }
        }
    }

    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWithError: .invalidData) {
            let invalidJSON = Data("Invalid JSON".utf8)
            client.complete(withStatus: 200, data: invalidJSON)
        }
    }

    // MARK: - Helpers

    private func makeSUT(
        url: URL = URL(string: "https://a-url.com")!
    ) -> (sut: RemoteCatFactLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let remoteCatFactLoader = RemoteCatFactLoader(url: url, client: client)
        return (sut: remoteCatFactLoader, client: client)
    }

    private func expect(
        _ sut: RemoteCatFactLoader,
        toCompleteWithError error: RemoteCatFactLoader.Error,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        var capturedResult = [RemoteCatFactLoader.Result]()
        sut.load { capturedResult.append($0) }

        action()

        XCTAssertEqual(capturedResult, [.failure(error)], file: file, line: line)
    }

    private class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()

        var requestedURLs: [URL] {
            messages.map { $0.url }
        }

        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }

        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }

        func complete(withStatus code: Int, data: Data = Data(), at index: Int = 0) {
            let httpResponse = HTTPURLResponse(
                url: messages[index].url,
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            messages[index].completion(.success(data, httpResponse))
        }
    }
}
