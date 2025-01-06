//
//  APIService.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/6/25.
//

import Alamofire

class APIService {
    static let shared = APIService()

    private init() {}
    
    func load<ModelType: Decodable>(_ endpoint: APIEndpoint) async -> Result<ModelType, Error> {
        let dataRequest = AF.request(endpoint)
        dataRequest.cURLDescription { (curl) in
           print("CURL: \(curl)")
        }

        let response = await dataRequest.validate().serializingDecodable(ModelType.self).response

        if let data = response.data {
            let response = String(data: data, encoding: .utf8)
            print("Response: \(response ?? String(decoding: data, as: UTF8.self))")
        }

        switch response.result {
        case .success(let responseObject):
            return .success(responseObject)
        case .failure(let error):
            return .failure(error)
        }
    }
}
