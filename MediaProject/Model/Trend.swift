//
//  Trend.swift
//  MediaProject
//
//  Created by 권대윤 on 6/10/24.
//

import Foundation

struct TrendData: Codable {
    let results: [Trend]
}

struct Trend: Codable {
    let id: String?
    let posterPath: String?
    let title: String?
    let releaseDate: String?
    let overview: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
        case releaseDate = "release_date"
        case overview
        case type = "media_type"
    }
}
