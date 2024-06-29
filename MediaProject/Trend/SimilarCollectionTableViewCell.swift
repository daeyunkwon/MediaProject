//
//  SimilarCollectionTableViewCell.swift
//  MediaProject
//
//  Created by 권대윤 on 6/24/24.
//

import UIKit

import SnapKit

final class SimilarCollectionTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var collectionCellWidthDivider: CGFloat = 0
    
    enum CellType {
        case similarity
        case recommendation
        case poster
    }
    var cellType: CellType = .similarity
    
    var similarList: [SimilarResult] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var recommendationList: [RecommendationResult] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var posterList: [PosterResult] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - UI Components
    
    let headerTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .label
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SimilarCollectionViewCell.self, forCellWithReuseIdentifier: SimilarCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(headerTextLabel)
        headerTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerTextLabel.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SimilarCollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch cellType {
        case .similarity: return self.similarList.count
        case .recommendation: return self.recommendationList.count
        case .poster: return self.posterList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarCollectionViewCell.identifier, for: indexPath) as? SimilarCollectionViewCell else {
            print("Failed to dequeue a SimilarCollectionViewCell. Using default UICollectionViewCell.")
            return UICollectionViewCell()
        }
        
        switch cellType {
        case .similarity:
            cell.similar = self.similarList[indexPath.row]
        case .recommendation:
            cell.recommendation = self.recommendationList[indexPath.row]
        case .poster:
            cell.poster = self.posterList[indexPath.row]
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SimilarCollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 20
        
        var size: CGFloat = 0.0
        switch cellType {
        case .similarity: size = 3.4
        case .recommendation: size = 3.4
        case .poster: size = 2.2
        }
        let width: CGFloat = (collectionView.bounds.width - margin) / size
        let height: CGFloat = (collectionView.bounds.height - margin)
        
        return CGSize(width: width, height: height )
    }
}
