//
//  PersonCollectionViewCell.swift
//  MediaProject
//
//  Created by 권대윤 on 6/30/24.
//

import UIKit

import Kingfisher
import SnapKit

final class PersonCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Components
    
    private let posterImageView: UIImageView = {
        let iv = PrimaryImageView(frame: .zero)
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .systemGray
        return label
    }()
    
    //MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.posterImageView.image = nil
        self.titleLabel.text = nil
    }
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(3)
            make.horizontalEdges.equalTo(posterImageView.snp.horizontalEdges)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    
    func cellConfig(data: CombinedCredits) {
        guard let url = APIURL.makeImageURL(path: data.posterPath ?? "") else { return }
        posterImageView.kf.setImage(with: url)
        titleLabel.text = data.title ?? data.name
    }
}
