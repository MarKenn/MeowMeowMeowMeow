//
//  Persistable.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//

import CoreData

/// Protocol to provide functionality for Core Data managed object conversion.
protocol Persistable {
    associatedtype ManagedObject

    /// Converts a conforming instance to a managed object instance.
    ///
    /// - Parameter context: The managed object context to use.
    /// - Returns: The converted managed object instance.
    func toPersistable(in context: NSManagedObjectContext) -> ManagedObject
}
