//
//  RemoteCatFactLoader.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 8/8/25.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public final class RemoteCatFactLoader {
    private let url: URL
    private let client: HTTPClient

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load() {
        client.get(from: url)
    }
}
