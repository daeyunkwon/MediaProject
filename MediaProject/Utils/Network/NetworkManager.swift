//
//  NetworkManager.swift
//  MediaProject
//
//  Created by 권대윤 on 6/20/24.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchData<T: Decodable>(api: TMDBAPI, completion: @escaping (T?, String?) -> Void) {
        
        guard let safeURL = api.endpoint else {
            print("Error: cannot create URL")
            return
        }
        
        AF.request(safeURL, method: api.method, parameters: api.parameter, encoding: api.encoding, headers: api.header).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(data as T, nil)
            case .failure(let error):
                print(response.response?.statusCode ?? 0)
                print(error)
                completion(nil, "잠시 후 다시 시도해주세요.")
            }
        }
    }
}
