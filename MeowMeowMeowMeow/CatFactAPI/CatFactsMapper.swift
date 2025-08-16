//
//  CatFactsMapper.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 8/16/25.
//

import Foundation

struct CatFactsMapper {
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
