//
//  NetworkManager.swift
//  MediaProject
//
//  Created by 권대윤 on 6/20/24.
//

import Foundation
import UIKit

import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    var session: URLSession!
    var sessionDelegate: UIViewController!
    
    enum TMDBNetworkError: Error {
        case failedCreateURL
        case failedRequest
        
        var errorMessageForAlert: String {
            return "잠시 후 다시 시도해주세요."
        }
    }
    
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
    
    func fetchTrendDataWithURLSession(api: TMDBAPI, delegate: UIViewController) {
        
        let parameters = ["language": "ko-KR"]
        
        let headers = [
            "accept": "application/json",
            "Authorization": APIKey.apiKey
        ]
        
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.themoviedb.org"
        
        if api.endpoint == TMDBAPI.trend(type: .all).endpoint {
            component.path = "/3/trending/all/day"
        }
        
        if api.endpoint == TMDBAPI.trend(type: .movie).endpoint {
            component.path = "/3/trending/movie/day"
        }
        
        if api.endpoint == TMDBAPI.trend(type: .tv).endpoint {
            component.path = "/3/trending/tv/day"
        }
        
        //queryString setting
        var queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        component.queryItems = queryItems
        
        //create URLRequest
        guard let url = component.url else {
            print("Failed Create URL")
            return
        }
        var request = URLRequest(url: url, timeoutInterval: 10)
        
        //header setting
        request.httpMethod = "GET"
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        //setup URLSession
        session = URLSession(configuration: .default, delegate: delegate as? URLSessionDelegate, delegateQueue: .main)
        
        session.dataTask(with: request).resume()
    }
}
