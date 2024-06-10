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
    let id: Int?
    let posterPath: String?
    let title: String?
    let name: String?
    let releaseDate: String?
    let firstAirDate: String?
    let overview: String?
    let type: String?
    let voteAverage: Float?
    
    var voteAverageString: String? {
        let formatter = NumberFormatter()
        formatter.roundingMode = .floor
        formatter.maximumFractionDigits = 1
        return formatter.string(from: (voteAverage ?? 0) as NSNumber)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
        case name
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case overview
        case type = "media_type"
        case voteAverage = "vote_average"
    }
}
