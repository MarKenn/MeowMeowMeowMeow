//
//  RemoteCatFactLoader.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 8/8/25.
//

import Foundation

public final class RemoteCatFactLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public enum Result: Equatable {
        case success([String])
        case failure(Error)
    }

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success(let data, let response):
                do {
                    let facts = try CatFactsMapper.map(data, response: response)
                    return completion(.success(facts))
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

private struct CatFactsMapper {
    private struct Root: Decodable {
        let data: [String]
    }

    static var OK_200: Int { return 200 }

    static func map(_ data: Data, response: HTTPURLResponse) throws -> [String] {
        guard response.statusCode == OK_200 else {
            throw RemoteCatFactLoader.Error.invalidData
        }

        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.data
    }
}
