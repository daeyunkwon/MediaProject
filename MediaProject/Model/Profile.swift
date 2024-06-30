//
//  Profile.swift
//  MediaProject
//
//  Created by 권대윤 on 6/30/24.
//

import Foundation

struct Profile: Decodable {
    let alsoKnownAs: [String]?
    let birthday: String?
    let name: String?
    let birthplace: String?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case alsoKnownAs = "also_known_as"
        case birthday
        case name
        case birthplace = "place_of_birth"
        case profilePath = "profile_path"
    }
    
    var birthdayDateString: String {
        
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = myFormatter.date(from: self.birthday ?? "") ?? Date()
        
        //원하는 format으로 표시하기 위해 다시 Date -> String 으로 변환하기
        myFormatter.dateFormat = "yyyy년 MM월 dd일"
        let dateString = myFormatter.string(from: date)
        
        return dateString
    }
}
