//
//  CatImage.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//

import CoreData

struct CatImage: Decodable {
    let id: String
    let url: String
    let width: Int
    let height: Int
    var dateCreated: Int?
}

extension CatImage: Persistable {
    func toPersistable(in context: NSManagedObjectContext) -> CatImagePersisted {
        let object = CatImagePersisted(entity: CatImagePersisted.entity(), insertInto: context)
        object.id = id
        object.url = url
        object.width = Int64(width)
        object.height = Int64(height)
        object.dateCreated = Int64(Date().timeIntervalSince1970)

        return object
    }
}
