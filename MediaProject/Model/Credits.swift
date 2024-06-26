//
//  Credits.swift
//  MediaProject
//
//  Created by 권대윤 on 6/10/24.
//

import Foundation

struct Credits: Decodable {
    let cast: [Cast]
}

struct Cast: Decodable {
    let actorName: String?
    let characterName: String?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case actorName = "original_name"
        case characterName = "character"
        case profilePath = "profile_path"
    }
}
