//
//  MeowFactData.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/6/25.
//

import CoreData

struct MeowFactData: Decodable {
    var data: [String]
}

extension MeowFactData {
    func toPersistables(in context: NSManagedObjectContext) -> [MeowFactPersisted] {
        var result: [MeowFactPersisted] = []

        for fact in data {
            let object = MeowFactPersisted(entity: MeowFactPersisted.entity(), insertInto: context)
            object.fact = fact
            object.dateCreated = Int64(Date().timeIntervalSince1970)

            result.append(object)
        }

        return result
    }
}
