//
//  CatImagePersisted+CoreDataClass.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//
//

import Foundation
import CoreData


public class CatImagePersisted: NSManagedObject {

}

extension CatImagePersisted: Modelable {
    func toModel() -> CatImage {
        CatImage(id: id, url: url, width: Int(width), height: Int(height), dateCreated: nil)
    }
}
