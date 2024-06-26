//
//  TMDBAPI.swift
//  MediaProject
//
//  Created by 권대윤 on 6/26/24.
//

import Foundation

import Alamofire

enum TMDBAPI {
    case trend
    case credits(id: Int, mediaType: MediaType)
    case search(query: String, page: Int)
    case similar(id: Int, mediaType: MediaType)
    case recommendation(id: Int, mediaType: MediaType)
    case poster(id: Int, mediaType: MediaType)
    
    var baseURL: String {
        return APIURL.baseURL
    }
    
    var endpoint: URL? {
        switch self {
        case .trend:
            guard let url = URL(string: baseURL + "trending/all/day") else {return nil}
            return url
        
        case .credits(let id, let mediaType):
            switch mediaType {
            case .movie:
                guard let url = URL(string: baseURL + APIURL.creditsMovieURL(id: String(id))) else {return nil}
                return url
            case .tv:
                guard let url = URL(string: baseURL + APIURL.creditsTVURL(id: String(id))) else {return nil}
                return url
            }
        
        case .search:
            guard let url = URL(string: baseURL + APIURL.searchURL) else {return nil}
            return url
        
        case .similar(let id, let mediaType):
            switch mediaType {
            case .movie:
                guard let url = URL(string: baseURL + APIURL.similarMovieURL(id: String(id))) else {return nil}
                return url
            case .tv:
                guard let url = URL(string: baseURL + APIURL.similarTVURL(id: String(id))) else {return nil}
                return url
            }
            
        case .recommendation(let id, let mediaType):
            switch mediaType {
            case .movie:
                guard let url = URL(string: baseURL + APIURL.recommendationsMovieURL(id: String(id))) else {return nil}
                return url
            case .tv:
                guard let url = URL(string: baseURL + APIURL.recommendationsTVURL(id: String(id))) else {return nil}
                return url
            }
            
        case .poster(let id, let mediaType):
            switch mediaType {
            case .movie:
                guard let url = URL(string: baseURL + APIURL.posterMovieURL(id: String(id))) else {return nil}
                return url
            case .tv:
                guard let url = URL(string: baseURL + APIURL.posterTVURL(id: String(id))) else {return nil}
                return url
            }
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameter: Parameters {
        switch self {
        case .trend, .credits, .similar, .recommendation:
            return ["language": "ko-KR"]
            
        case .search(let query, let page):
            return ["query": query,
                    "page": page,
                    "lagnuage": "ko-KR"]
            
        case .poster:
            return [:]
        }
    }
    
    var header: HTTPHeaders {
        return ["accept": "application/json",
                "Authorization": APIKey.apiKey]
    }
    
    var encoding: URLEncoding {
        return .queryString
    }
}
