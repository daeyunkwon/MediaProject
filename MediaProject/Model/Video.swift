//
//  Video.swift
//  MediaProject
//
//  Created by 권대윤 on 7/1/24.
//

import Foundation

struct VideoData: Decodable {
    let id: Int?
    let results: [Video]
}

struct Video: Decodable {
    let key: String?
}
