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
    
    override func fetchData() {
        NetworkManager.shared.fetchData(api: .video(id: self.id, mediaType: self.mediaType), model: VideoData.self) { result in
            switch result {
            case .success(let data):
                let trailerList = data.results.filter { video in
                    if video.type == "Trailer" {
                        return true
                    }
                    return false
                }
                
                guard let url = APIURL.makeYoutubeURL(key: trailerList.first?.key ?? "") else { return }
                
                let request = URLRequest(url: url)
                self.webView.load(request)
                
            case .failure(let error):
                self.showNetworkFailAlert(message: error.errorMessageForAlert)
                print(error)
            }
        }
    }
    
    override func configureLayout() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
}
