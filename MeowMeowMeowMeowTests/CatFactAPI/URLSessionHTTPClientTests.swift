//
//  URLSessionHTTPClientTests.swift
//  MeowMeowMeowMeowTests
//
//  Created by Mark Kenneth Bayona on 8/20/25.
//

import XCTest
import MeowMeowMeowMeow

class URLSessionHTTPClient {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error {
                completion(.failure(error))
            }
        }.resume()
    }
}

final class URLSessionHTTPClientTests: XCTestCase {

    func test_getFromURL_failsOnRequestError() {
        URLProtocol.registerClass(URLProtocolStub.self)
        let url = URL(string: "https://a-url.com")!
        let expectedError = NSError(domain: "any error", code: 1)
        let sut = URLSessionHTTPClient()
        URLProtocolStub.stub(url: url, error: expectedError)

        let exp = expectation(description: "Wait for completion")

        sut.get(from: url) { result in
            switch result {
            case .failure(let receivedError as NSError):
                XCTAssertEqual(receivedError.domain, expectedError.domain)
                XCTAssertEqual(receivedError.code, expectedError.code)
            default:
                XCTFail("Expecting \(expectedError), got \(result) instead")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        URLProtocolStub.unregisterClass(URLProtocolStub.self)
    }

    // MARK: - Helpers

    class URLProtocolStub: URLProtocol {
        static var stub = [URL: Error]()

        static func stub(url: URL, error: Error) {
            stub[url] = error
        }

        override class func canInit(with request: URLRequest) -> Bool {
            guard let url = request.url else { return false }

            return URLProtocolStub.stub[url] != nil
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            request
        }

        override func startLoading() {
            guard let url = request.url, let error = URLProtocolStub.stub[url] else { return }

            client?.urlProtocol(self, didFailWithError: error)

            client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() {}
    }
}
