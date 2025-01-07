//
//  CatImage.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//

import CoreData

struct CatImage: Codable {
    let id: String
    let url: String
    let width: Int
    let height: Int
    var dateCreated: Int?
}

extension CatImage: Persistable {
    /// Converts current instance of CatImage to CatImagePersisted
    /// - Parameter context: CoreData context
    /// - Returns: CatImagePersisted
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

extension CatImage: Equatable {
    static func == (lhs: CatImage, rhs: CatImage) -> Bool {
        lhs.id == rhs.id && lhs.url == rhs.url
    }
}
