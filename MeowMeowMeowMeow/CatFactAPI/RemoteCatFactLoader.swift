//
//  RemoteCatFactLoader.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 8/8/25.
//

import Foundation

public final class RemoteCatFactLoader: CatFactLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public typealias Result = Swift.Result<String, Error>

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] clientResult in
            guard self != nil else { return }
            
            switch clientResult {
            case .success(let result):
                completion(CatFactsMapper.map(result.data, response: result.response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }

    public func getCatFact() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            client.get(from: url) { clientResult in
                switch clientResult {
                case .success(let result):
                    continuation.resume(
                        with: CatFactsMapper.map(result.data,response: result.response)
                    )
                case .failure:
                    continuation.resume(with: .failure(Error.connectivity))
                }
            }
        }
    }
}
