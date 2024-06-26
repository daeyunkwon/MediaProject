//
//  UIViewController+Extension.swift
//  MediaProject
//
//  Created by 권대윤 on 6/26/24.
//

import UIKit

extension UIViewController {
    func showNetworkFailAlert(message: String) {
        let alert = UIAlertController(title: "네트워크 불안정", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
    }
}
