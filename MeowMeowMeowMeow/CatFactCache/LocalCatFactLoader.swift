//
//  LocalCatFactLoader.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 9/26/25.
//

import Foundation

public class LocalCatFactLoader {
    private let store: CatFactStore
    private let currentDate: () -> Date

    public init(store: CatFactStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }

    public func save(_ facts: [String], completion: @escaping (Error?) -> Void) {
        store.deleteCachedFacts { [weak self] error in
            guard let self else { return }

            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                cache(facts, with: completion)
            }
        }
    }

    private func cache(_ facts: [String], with completion: @escaping (Error?) -> Void) {
        store.insert(facts, timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}
