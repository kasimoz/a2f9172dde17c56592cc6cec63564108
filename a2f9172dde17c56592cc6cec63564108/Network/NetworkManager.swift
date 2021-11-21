//
//  NetworkManager.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 17.11.2021.
//

import Moya

protocol Networkable {
    var provider: MoyaProvider<NetworkApi> { get }
    
    func fetchSpaceStations(completion: @escaping (Result<[SpaceStation], Error>) -> ())
}

class NetworkManager: Networkable {
    
    var provider = MoyaProvider<NetworkApi>(plugins: [NetworkLoggerPlugin()])
    
    func fetchSpaceStations(completion: @escaping (Result<[SpaceStation], Error>) -> ()) {
        request(target: .spaceStations, completion: completion)
    }
}

private extension NetworkManager {
    private func request<T: Decodable>(target: NetworkApi, completion: @escaping (Result<T, Error>) -> ()) {
        
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
