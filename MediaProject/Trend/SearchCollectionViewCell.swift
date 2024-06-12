//
//  SearchCollectionViewCell.swift
//  MediaProject
//
//  Created by 권대윤 on 6/11/24.
//

import UIKit

import SnapKit

final class SearchCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var searchResult: SearchResult? {
        didSet {
            guard let data = searchResult else {return}
            
            let url = APIURL.makeImageURL(path: (data.posterPath ?? data.profilePath) ?? "")
            mainImageView.kf.setImage(with: url)
        }
    }
    
    //MARK: - UI Components
    
    private let mainImageView: UIImageView = {
        let iv = PrimaryImageView(frame: .zero)
        iv.clipsToBounds = true
        return iv
    }()
    
    //MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.image = nil
    }
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
    }
    
    private func configureUI() {
        contentView.backgroundColor = .systemBackground
    }
}
