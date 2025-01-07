//
//  TheCatAPIEndpoint.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/7/25.
//

import Foundation
import Alamofire

enum TheCatAPIEndpoint: APIEndpoint {
    case getRandomCatImage

    var baseURL: URL {
        guard let url = URL(string: "https://api.thecatapi.com/v1/") else {
            fatalError("Invalid base url")
        }

        return url
    }

    var method: HTTPMethod {
        switch self {
        case .getRandomCatImage: .get
        }
    }

    var path: String {
        switch self {
        case .getRandomCatImage: "images/search"
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
