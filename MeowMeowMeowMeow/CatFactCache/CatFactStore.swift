//
//  CatFactStore.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 9/26/25.
//

import Foundation

public protocol CatFactStore {
    typealias DeleteCompletion = (Error?) -> Void
    typealias InsertCompletion = (Error?) -> Void

    func deleteCachedFacts(completion: @escaping DeleteCompletion)
    func insert(_ facts: [String], timestamp: Date, completion: @escaping InsertCompletion)
}
