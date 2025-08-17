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

    func test_getCatFact_requestDataFromURL() async {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url, clientResult: .failure(NSError()))

        _ = try? await sut.getCatFact()

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load() { _ in }
        sut.load() { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_getCatFactTwice_requestDataFromURLTwice() async {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url, clientResult: .failure(NSError()))

        _ = try? await sut.getCatFact()
        _ = try? await sut.getCatFact()

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.connectivity)) {
            client.complete(with: NSError())
        }
    }

    func test_getCatFact_deliversErrorOnClientError() async {
        let (sut, _) = makeSUT(clientResult: .failure(NSError()))

        await expect(sut, toThrowError: .connectivity)
    }

    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData)) {
                let json = makeItemsJSON([])
                client.complete(withStatus: code, data: json, at: index)
            }
        }
    }

    func test_getCatFact_deliversErrorOnNon200HTTPResponse() async {
        let samples = [199, 201, 300, 400, 500]

        for code in samples {
            let url = URL(string: "https://a-url.com")!
            let json = makeItemsJSON([])
            let httpResponse = HTTPURLResponse(
                url: url,
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            let (sut, client) = makeSUT(url: url, clientResult: .success(json, httpResponse))

            await expect(sut, toThrowError: .invalidData)
        }
    }

    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.invalidData)) {
            let invalidJSON = Data("Invalid JSON".utf8)
            client.complete(withStatus: 200, data: invalidJSON)
        }
    }

    func test_load_deliversErrorOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.invalidData)) {
            let emptyJSON = makeItemsJSON([])
            client.complete(withStatus: 200, data: emptyJSON)
        }
    }

    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()

        let fact1 = "This is cat fact 1"
        let fact2 = "This is cat fact 2"
        
        let catFacts = [fact1, fact2]

        expect(sut, toCompleteWith: .success(fact1)) {
            let json = makeItemsJSON(catFacts)
            client.complete(withStatus: 200, data: json)
        }
    }

    func test_Load_doesNotDeliverItemsAfterSUTInstanceHasBeenDeallocated() {
        let client: HTTPClientSpy
        var sut: RemoteCatFactLoader?
        (sut, client) = makeSUT()

        var capturedResult = [RemoteCatFactLoader.Result]()
        sut?.load { capturedResult.append($0) }

        sut = nil
        client.complete(withStatus: 200, data: makeItemsJSON([]))

        XCTAssert(capturedResult.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT(
        url: URL = URL(string: "https://a-url.com")!,
        clientResult: HTTPClientResult? = nil,
        file: StaticString = #file,
        line: UInt = #line,
    ) -> (sut: RemoteCatFactLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy(result: clientResult)
        let remoteCatFactLoader = RemoteCatFactLoader(url: url, client: client)

        trackFOrMemoryLeaks(remoteCatFactLoader, file: file, line: line)
        trackFOrMemoryLeaks(client, file: file, line: line)

        return (sut: remoteCatFactLoader, client: client)
    }

    private func trackFOrMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line,
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance,
                         "Instance should be deallocated. Potential memory leak.",
                         file: file,
                         line: line)
        }
    }

    private func makeItemsJSON(_ items: [String]) -> Data {
        let itemsJSON = ["data": items]
        return try! JSONSerialization.data(withJSONObject: itemsJSON)
    }

    private func expect(
        _ sut: RemoteCatFactLoader,
        toCompleteWith result: RemoteCatFactLoader.Result,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line,
    ) {
        var capturedResult = [RemoteCatFactLoader.Result]()
        sut.load { capturedResult.append($0) }

        action()

        XCTAssertEqual(capturedResult, [result], file: file, line: line)
    }

    private func expect(
        _ sut: RemoteCatFactLoader,
        toThrowError expectedError: RemoteCatFactLoader.Error,
        file: StaticString = #filePath,
        line: UInt = #line,
    )  async {
        do {
            _ = try await sut.getCatFact()
            XCTFail(
                "Expecting to throw \(expectedError)), got success instead.",
                file: file,
                line: line
            )
        } catch {
            XCTAssertEqual(
                error as! RemoteCatFactLoader.Error,
                expectedError,
                file: file,
                line: line
            )
        }
    }

    private class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        var result: HTTPClientResult?

        init(result: HTTPClientResult? = nil) {
            self.result = result
        }

        var requestedURLs: [URL] {
            messages.map { $0.url }
        }

        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))

            if let result {
                completion(result)
            }
        }

        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }

        func complete(withStatus code: Int, data: Data, at index: Int = 0) {
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
