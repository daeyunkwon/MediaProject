//
//  CombinedCredits.swift
//  MediaProject
//
//  Created by 권대윤 on 6/30/24.
//

import Foundation

struct CombinedCreditsData: Decodable {
    let cast: [CombinedCredits]?
}

struct CombinedCredits: Decodable {
    let id: Int?
    let title: String?
    let posterPath: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case name
    }
}
