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
    
    
    func fetchCredits(mediaType: MediaType, id: Int, completion: @escaping (Credits) -> Void) {
        let param: Parameters = [
            "language": "ko-KR"
        ]
        
        let header: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": APIKey.apiKey
        ]
        
        var url: URL?
        switch mediaType {
        case .movie:
            url = APIURL.makeMovieCreditsAPIURL(with: String(id))
        case .tv:
            url = APIURL.makeTVCreditsAPIURL(with: String(id))
        }
        guard let safeURL = url else {return}
        
        AF.request(safeURL, method: .get, parameters: param, encoding: URLEncoding.queryString, headers: header).responseDecodable(of: Credits.self) { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(response.response?.statusCode ?? 0)
                print(error)
            }
        }
    }
    
    func fetchTrendData(completion: @escaping (TrendData) -> Void) {
        let param: Parameters = [
            "language": "ko-KR"
        ]
        
        let header: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": APIKey.apiKey
        ]
        
        AF.request(APIURL.trendAPIURL, method: .get, parameters: param, encoding: URLEncoding.queryString, headers: header).responseDecodable(of: TrendData.self) { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(response.response?.statusCode ?? 0)
                print(error)
            }
        }
    }
    
    func fetchSearch(query: String, page: Int, completion: @escaping (Search) -> Void) {
        let param: Parameters = [
            "query": query,
            "page": page,
            "lagnuage": "ko-KR",
            "include_adult": false
        ]
        
        let header: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": APIKey.apiKey
        ]
        
        AF.request(APIURL.searchAPIURL, method: .get, parameters: param, encoding: URLEncoding.queryString, headers: header).responseDecodable(of: Search.self) { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(response.response?.statusCode ?? 0)
                print(error)
            }
        }
    }
    
    func fetchSimilar(mediaType: MediaType, id: Int, completion: @escaping (Similar) -> Void) {
        let param: Parameters = [
            "language": "ko-KR"
        ]
        
        let header: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": APIKey.apiKey
        ]
        
        var url: URL?
        switch mediaType {
        case .movie:
            url = APIURL.makeMovieSimilarAPIURL(with: String(id))
        case .tv:
            url = APIURL.makeTVSimilarAPIURL(with: String(id))
        }
        guard let safeURL = url else {return}
        
        AF.request(safeURL, method: .get, parameters: param, encoding: URLEncoding.queryString, headers: header).responseDecodable(of: Similar.self) { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(response.response?.statusCode ?? 0)
                print(error)
            }
        }
    }
    
    func fetchRecommendation(mediaType: MediaType, id: Int, completion: @escaping (Recommendation) -> Void) {
        let param: Parameters = [
            "language": "ko-KR"
        ]
        
        let header: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": APIKey.apiKey
        ]
        
        var url: URL?
        switch mediaType {
        case .movie:
            url = APIURL.makeMovieRecommendationsAPIURL(with: String(id))
        case .tv:
            url = APIURL.makeTVRecommendationsAPIURL(with: String(id))
        }
        guard let safeURL = url else {return}
        
        AF.request(safeURL, method: .get, parameters: param, encoding: URLEncoding.queryString, headers: header).responseDecodable(of: Recommendation.self) { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(response.response?.statusCode ?? 0)
                print(error)
            }
        }
    }
    
    func fetchPoster(mediaType: MediaType, id: Int, completion: @escaping (Poster) -> Void) {
        let param: Parameters = [:]
        
        let header: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": APIKey.apiKey
        ]
        
        var url: URL?
        switch mediaType {
        case .movie:
            url = APIURL.makeMoviePosterAPIURL(with: String(id))
        case .tv:
            url = APIURL.makeTVPosterAPIURL(with: String(id))
        }
        guard let safeURL = url else {return}
        
        AF.request(safeURL, method: .get, parameters: param, encoding: URLEncoding.queryString, headers: header).responseDecodable(of: Poster.self) { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(response.response?.statusCode ?? 0)
                print(error)
            }
        }
    }
    
    
}
