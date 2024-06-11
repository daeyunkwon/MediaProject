//
//  Search.swift
//  MediaProject
//
//  Created by 권대윤 on 6/11/24.
//

import Foundation

struct Search: Decodable {
    var page: Int
    let results: [SearchResult]
    var totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
    }
}

struct SearchResult: Decodable {
    let id: Int?
    let originalName: String?
    let originalTitle: String?
    let posterPath: String?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case originalName = "original_name"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case profilePath = "profile_path"
    }
}
