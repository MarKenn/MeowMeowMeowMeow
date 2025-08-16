//
//  HTTPClient.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 8/16/25.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
