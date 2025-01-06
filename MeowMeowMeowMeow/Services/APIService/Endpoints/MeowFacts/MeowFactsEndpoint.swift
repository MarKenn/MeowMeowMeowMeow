//
//  MeowFactsEndpoint.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/6/25.
//

import Foundation
import Alamofire

enum MeowFactsEndpoint: APIEndpoint {
    case getRandomCatFact

    var baseURL: URL {
        guard let url = URL(string: "https://meowfacts.herokuapp.com/") else {
            fatalError("Invalid base url")
        }

        return url
    }

    var method: HTTPMethod {
        switch self {
        case .getRandomCatFact: .get
        }
    }

    var path: String {
        switch self {
        case .getRandomCatFact: ""
        }
    }

    var parameters: [String : String]? {
        switch self {
        default:
            return nil
        }
    }

    var body: (any Encodable)? {
        switch self {
        default:
            return nil
        }
    }
}
