//
//  CatImagePersisted+CoreDataProperties.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//
//

import Foundation
import CoreData


extension CatImagePersisted {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CatImagePersisted> {
        return NSFetchRequest<CatImagePersisted>(entityName: "CatImagePersisted")
    }

    @NSManaged public var id: String?
    @NSManaged public var url: String?
    @NSManaged public var width: Int64
    @NSManaged public var height: Int64
    @NSManaged public var dateCreated: Int64

}

extension CatImagePersisted : Identifiable {

}
