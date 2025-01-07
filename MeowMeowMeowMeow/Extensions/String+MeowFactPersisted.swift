//
//  String+MeowFactPersisted.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//

import CoreData

extension String: Persistable {
    func toPersistable(in context: NSManagedObjectContext) -> MeowFactPersisted {
        let object = MeowFactPersisted(entity: MeowFactPersisted.entity(), insertInto: context)
        object.fact = self
        object.dateCreated = Int64(Date().timeIntervalSince1970)

        return object
    }
}
