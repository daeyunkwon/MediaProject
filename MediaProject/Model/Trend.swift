//
//  Trend.swift
//  MediaProject
//
//  Created by 권대윤 on 6/10/24.
//

import Foundation

enum MediaType {
    case movie
    case tv
}

struct TrendData: Decodable {
    let results: [Trend]
}

struct Trend: Decodable {
    let id: Int?
    let posterPath: String?
    let title: String?
    let name: String?
    let releaseDate: String?
    let firstAirDate: String?
    let overview: String?
    let type: String?
    let voteAverage: Float?
    let backdropPath: String?
    
    var mediaType: MediaType {
        switch type {
        case "tv":
            return .tv
        case "movie":
            return .movie
        default:
            return .movie
        }
    }
    
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
        case backdropPath = "backdrop_path"
    }
}
