//
//  TMDBAPI.swift
//  MediaProject
//
//  Created by 권대윤 on 6/26/24.
//

import Foundation

import Alamofire

enum TMDBAPI {
    case trend(type: TrendType)
    case credits(id: Int, mediaType: MediaType)
    case search(query: String, page: Int)
    case similar(id: Int, mediaType: MediaType)
    case recommendation(id: Int, mediaType: MediaType)
    case poster(id: Int, mediaType: MediaType)
    case profile(id: Int)
    case combinedCredits(id: Int)
    case video(id: Int, mediaType: MediaType)
    
    enum TrendType {
        case all
        case movie
        case tv
    }
    
    var baseURL: String {
        return APIURL.baseURL
    }
    
    var endpoint: URL? {
        switch self {
        case .trend(let type):
            switch type {
            case .all:
                guard let url = URL(string: baseURL + "trending/all/day") else {return nil}
                return url
            case .movie:
                guard let url = URL(string: baseURL + "trending/movie/day") else {return nil}
                return url
            case .tv:
                guard let url = URL(string: baseURL + "trending/tv/day") else {return nil}
                return url
            }
            
        case .credits(let id, let mediaType):
            switch mediaType {
            case .movie:
                guard let url = URL(string: baseURL + APIURL.creditsMovieURL(id: String(id))) else {return nil}
                return url
            case .tv:
                guard let url = URL(string: baseURL + APIURL.creditsTVURL(id: String(id))) else {return nil}
                return url
            default: break
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
            default: break
            }
            
        case .recommendation(let id, let mediaType):
            switch mediaType {
            case .movie:
                guard let url = URL(string: baseURL + APIURL.recommendationsMovieURL(id: String(id))) else {return nil}
                return url
            case .tv:
                guard let url = URL(string: baseURL + APIURL.recommendationsTVURL(id: String(id))) else {return nil}
                return url
            default: break
            }
            
        case .poster(let id, let mediaType):
            switch mediaType {
            case .movie:
                guard let url = URL(string: baseURL + APIURL.posterMovieURL(id: String(id))) else {return nil}
                return url
            case .tv:
                guard let url = URL(string: baseURL + APIURL.posterTVURL(id: String(id))) else {return nil}
                return url
            default: break
            }
            
        case .profile(let id):
            guard let url = URL(string: baseURL + APIURL.profileURL(id: String(id))) else {return nil}
            return url
            
        case .combinedCredits(let id):
            guard let url = URL(string: baseURL + APIURL.combinedCreditsURL(id: String(id))) else {return nil}
            return url
            
        case .video(let id, let mediaType):
            switch mediaType {
            case .movie:
                guard let url = URL(string: baseURL + APIURL.videoMovieURL(id: String(id))) else {return nil}
                return url
            case .tv:
                guard let url = URL(string: baseURL + APIURL.videoTVURL(id: String(id))) else {return nil}
                return url
            default: break
            }
        }
        
        return nil
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameter: Parameters {
        switch self {
        case .trend, .credits, .similar, .recommendation, .profile, .combinedCredits:
            return ["language": "ko-KR"]
            
        case .search(let query, let page):
            return ["query": query,
                    "page": page,
                    "lagnuage": "ko-KR"]
            
        case .poster, .video:
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
