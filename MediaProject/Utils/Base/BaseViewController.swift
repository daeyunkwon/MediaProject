//
//  BaseViewController.swift
//  MediaProject
//
//  Created by 권대윤 on 6/26/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureUI()
    }
    
    func configureLayout() {}
    
    func configureUI() {}
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showNetworkFailAlert(message: String) {
        let alert = UIAlertController(title: "네트워크 불안정", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
    }
}
