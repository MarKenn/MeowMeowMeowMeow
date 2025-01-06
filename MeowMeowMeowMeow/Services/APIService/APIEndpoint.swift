//
//  APIEndpoint.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/6/25.
//

import Foundation
import Alamofire

protocol APIEndpoint: URLRequestConvertible {
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: String]? { get }
    var body: Encodable? { get }
}

extension APIEndpoint {
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method

        if let parameters = parameters {
            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        }

        if let body = body {
            request = try JSONParameterEncoder().encode(body, into: request)
        }

        return request
    }
}
