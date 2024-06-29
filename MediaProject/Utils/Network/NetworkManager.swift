//
//  NetworkManager.swift
//  MediaProject
//
//  Created by 권대윤 on 6/20/24.
//

import Foundation
import Alamofire

enum TMDBNetworkError: Error {
    case failedCreateURL
    case failedRequest
    
    var errorMessageForAlert: String {
        return "잠시 후 다시 시도해주세요."
    }
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchData<T: Decodable>(api: TMDBAPI, model: T.Type, completion: @escaping (Result<T, TMDBNetworkError>) -> Void) {
        
        guard let safeURL = api.endpoint else {
            completion(.failure(.failedCreateURL))
            return
        }
        
        AF.request(safeURL, method: api.method, parameters: api.parameter, encoding: api.encoding, headers: api.header).validate(statusCode: 200...299).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            
            case .failure(let error):
                print(response.response?.statusCode ?? 0)
                print(error)
                completion(.failure(.failedRequest))
            }
        }
    }
}
