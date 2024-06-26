//
//  ShadowRadiusBackView.swift
//  MediaProject
//
//  Created by 권대윤 on 6/12/24.
//

import UIKit

final class ShadowRadiusBackView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 1
        layer.shadowRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
