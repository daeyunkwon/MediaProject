//
//  TrailerViewController.swift
//  MediaProject
//
//  Created by 권대윤 on 7/1/24.
//

import UIKit
import WebKit

import SnapKit

final class TrailerViewController: BaseViewController {
    
    //MARK: - Properties
    
    var id: Int = 0
    
    var mediaType: MediaType = .movie
    
    
    //MARK: - UI Components
    
    private let webView = WKWebView()
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureLayout() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        //webView.load(URLRequest(url: url))
    }
    
    
    //MARK: - Functions
    

}
