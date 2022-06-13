//
//  NetworkApi.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 17.11.2021.
//

import Moya

enum NetworkApi {
    case spaceStations
}

extension NetworkApi: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://run.mocky.io/v3/") else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .spaceStations:
            return "e7211664-cbb6-4357-9c9d-f12bf8bab2e2"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .spaceStations:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
