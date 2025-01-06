//
//  RemoteDataProvider.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/6/25.
//

import Foundation
import Alamofire

protocol RemoteDataProvider {
    var api: APIService { get }
}

extension RemoteDataProvider {
    var api: APIService {
        APIService.shared
    }
}
