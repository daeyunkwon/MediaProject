//
//  SimilarCollectionViewCell.swift
//  MediaProject
//
//  Created by 권대윤 on 6/24/24.
//

import UIKit

import SnapKit

final class SimilarCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var similar: SimilarResult? {
        didSet {
            guard let similar = self.similar else {return}
            let url = APIURL.makeImageURL(path: similar.posterPath ?? "")
            posterImageView.kf.setImage(with: url)
        }
    }
    
    var recommendation: RecommendationResult? {
        didSet {
            guard let recommendation = self.recommendation else {return}
            let url = APIURL.makeImageURL(path: recommendation.posterPath ?? "")
            posterImageView.kf.setImage(with: url)
        }
    }
    
    var poster: PosterResult? {
        didSet {
            guard let poster = self.poster else {return}
            let url = APIURL.makeImageURL(path: poster.posterPath ?? "")
            posterImageView.kf.setImage(with: url)
        }
    }
    
    //MARK: - UI Components
    
    private let posterImageView: UIImageView = {
        let iv = PrimaryImageView(frame: .zero)
        iv.clipsToBounds = true
        return iv
    }()
    
    //MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.posterImageView.image = nil
    }
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
