//
//  PrimaryImageView.swift
//  MediaProject
//
//  Created by 권대윤 on 6/12/24.
//

import UIKit

final class PrimaryImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = 5
        self.backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
