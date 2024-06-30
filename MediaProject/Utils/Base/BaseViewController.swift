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
        fetchData()
        setupNavi()
        setupTableView()
        setupCollectionView()
        configureLayout()
        configureUI()
    }
    
    func fetchData() {}
    
    func setupNavi() {}
    
    func setupTableView() {}
    
    func setupCollectionView() {}
    
    func configureLayout() {}
    
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
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
    
    func pushVC(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func presentTrendDetailVC(id: Int, mediaType: MediaType , titleText: String?, posterImagePath: String?, backPosterImagePath: String?, overView: String?, modalStyle: UIModalPresentationStyle) {
        let vc = TrendDetailViewController()
        vc.id = id
        vc.mediaType = mediaType
        vc.titleText = titleText
        vc.posterImagePath = posterImagePath
        vc.backPosterImagePath = backPosterImagePath
        vc.overView = overView
        vc.modalPresentationStyle = modalStyle
        if modalStyle == .fullScreen {
            vc.viewType = .fullover
            let navi = UINavigationController(rootViewController: vc)
            navi.navigationBar.tintColor = .label
            navi.modalPresentationStyle = modalStyle
            present(navi, animated: true)
        } else {
            present(vc, animated: true)
        }
    }
}
