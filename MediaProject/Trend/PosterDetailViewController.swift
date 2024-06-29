//
//  PosterDetailViewController.swift
//  MediaProject
//
//  Created by 권대윤 on 6/30/24.
//

import UIKit

import SnapKit

final class PosterDetailViewController: BaseViewController {
    
    //MARK: - Properties
    
    var poster: PosterResult?
    
    //MARK: - UI Components
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureLayout() {
        view.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureUI() {
        view.backgroundColor = .black
        
        guard let poster = self.poster else { return }
        let url = APIURL.makeImageURL(path: poster.posterPath ?? "")
        posterImageView.kf.setImage(with: url)
    }
}
