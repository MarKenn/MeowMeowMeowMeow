//
//  MeowFactPersisted+CoreDataProperties.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//
//

import Foundation
import CoreData


extension MeowFactPersisted {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MeowFactPersisted> {
        return NSFetchRequest<MeowFactPersisted>(entityName: "MeowFactPersisted")
    }

    @NSManaged public var fact: String?
    @NSManaged public var id: String?

}

extension MeowFactPersisted : Identifiable {

}
