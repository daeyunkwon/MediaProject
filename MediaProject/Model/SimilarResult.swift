//
//  Similar.swift
//  MediaProject
//
//  Created by 권대윤 on 6/24/24.
//

import Foundation

struct Similar: Decodable {
    let page: Int
    let results: [SimilarResult]
}

struct SimilarResult: Decodable {
    let id: Int
    let posterPath: String?
    let overview: String?
    let name: String?
    let title: String?
    let backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case overview
        case name
        case backdropPath = "backdrop_path"
        case title
    }
}
