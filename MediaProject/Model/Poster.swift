//
//  Poster.swift
//  MediaProject
//
//  Created by 권대윤 on 6/25/24.
//

import Foundation

struct Poster: Decodable {
    let backdrops: [PosterResult]
}

struct PosterResult: Decodable {
    let posterPath: String?
    let width: Int
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "file_path"
        case width
    }
}
