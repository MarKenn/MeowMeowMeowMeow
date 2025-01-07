//
//  Modelable.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/8/25.
//

/// Protocol to provide functionality for data model conversion.
protocol Modelable: Identifiable {
    associatedtype Model

    var id: String { get }

    /// Converts a conforming instance to a data model instance.
    ///
    /// - Returns: The converted data model instance.
    func toModel() -> Model
}
