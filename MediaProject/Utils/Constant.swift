//
//  Constant.swift
//  MediaProject
//
//  Created by 권대윤 on 6/12/24.
//

import UIKit

enum Constant {
    enum SymbolSize {
        static func smallSize(systemName: String) -> UIImage? {
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .small)
            let image = UIImage(systemName: systemName, withConfiguration: config)
            return image
        }
    }
    
    
}
