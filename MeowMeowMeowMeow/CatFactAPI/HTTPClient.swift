//
//  HTTPClient.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 8/16/25.
//

import Foundation

public typealias HTTPClientResult = Result<(Data,HTTPURLResponse), Error>

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
