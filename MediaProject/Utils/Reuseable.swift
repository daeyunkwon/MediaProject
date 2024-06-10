//
//  Reuseable.swift
//  MediaProject
//
//  Created by 권대윤 on 6/10/24.
//

import UIKit

protocol Reuseable: AnyObject {
    static var identifier: String {get}
}

extension UITableViewCell: Reuseable {
    static var identifier: String {
        return String(describing: self)
    }
}
