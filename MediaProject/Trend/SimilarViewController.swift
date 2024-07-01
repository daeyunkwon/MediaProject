//
//  SimilarViewController.swift
//  MediaProject
//
//  Created by 권대윤 on 6/24/24.
//

import UIKit

import SnapKit

final class SimilarViewController: BaseViewController {
    
    //MARK: - Properties
    
    var mediaTitle: String?
    var mediaType: MediaType = .movie
    var id: Int = 0
    
    private var similarList: [SimilarResult] = []
    private var recommendationList: [RecommendationResult] = []
    private var posterList: [PosterResult] = []
    
    private enum CellType: Int, CaseIterable {
        case similarity
        case recommendation
        case poster
        
        var title: String {
            switch self {
            case .similarity:
                return "비슷한 콘텐츠"
            case .recommendation:
                return "추천 콘텐츠"
            case .poster:
                return "포스터"
            }
        }
    }
    
    //MARK: - UI Components
    
    private let mediaTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.textColor = .label
        return label
    }()
    
    private let tableView = UITableView()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func fetchData() {
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkManager.shared.fetchData(api: .similar(id: self.id, mediaType: self.mediaType), model: Similar.self) { result in
                switch result {
                case .success(let data):
                    self.similarList = data.results
                    group.leave()
                
                case .failure(let error):
                    self.showNetworkFailAlert(message: error.errorMessageForAlert)
                    print(error)
                    group.leave()
                }
            }
        }
        
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkManager.shared.fetchData(api: .recommendation(id: self.id, mediaType: self.mediaType), model: Recommendation.self) { result in
                switch result {
                case .success(let data):
                    self.recommendationList = data.results
                    group.leave()
                
                case .failure(let error):
                    self.showNetworkFailAlert(message: error.errorMessageForAlert)
                    print(error)
                    group.leave()
                }
            }
        }
        
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkManager.shared.fetchData(api: .poster(id: self.id, mediaType: self.mediaType), model: Poster.self) { result in
                switch result {
                case .success(let data):
                    self.posterList = data.backdrops
                    group.leave()
                
                case .failure(let error):
                    self.showNetworkFailAlert(message: error.errorMessageForAlert)
                    print(error)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
    override func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SimilarCollectionTableViewCell.self, forCellReuseIdentifier: SimilarCollectionTableViewCell.identifier)
    }
    
    override func configureLayout() {
        view.addSubview(mediaTitleLabel)
        mediaTitleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(30)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(mediaTitleLabel.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureUI() {
        super.configureUI()
        mediaTitleLabel.text = mediaTitle
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension SimilarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case CellType.similarity.rawValue, CellType.recommendation.rawValue:
            return 200
        case CellType.poster.rawValue:
            return 350
        default:
            return 200
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SimilarCollectionTableViewCell.identifier, for: indexPath) as? SimilarCollectionTableViewCell else {
            print("Failed to dequeue a SimilarCollectionTableViewCell. Using default UITableViewCell.")
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case CellType.similarity.rawValue:
            cell.cellType = .similarity
            cell.headerTextLabel.text = CellType.allCases[indexPath.section].title
            cell.similarList = self.similarList
            cell.collectionView.tag = indexPath.section
            
        case CellType.recommendation.rawValue:
            cell.cellType = .recommendation
            cell.headerTextLabel.text = CellType.allCases[indexPath.section].title
            cell.recommendationList = self.recommendationList
            cell.collectionView.tag = indexPath.section
            
        case CellType.poster.rawValue:
            cell.cellType = .poster
            cell.headerTextLabel.text = CellType.allCases[indexPath.section].title
            cell.posterList = self.posterList
            cell.collectionView.tag = indexPath.section
        default:
            break
        }
        
        cell.collectionView.delegate = self
        
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension SimilarViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case CellType.similarity.rawValue:
            self.presentTrendDetailVC(
                id: similarList[indexPath.row].id, 
                mediaType: self.mediaType,
                titleText: similarList[indexPath.row].name ?? similarList[indexPath.row].title,
                posterImagePath: similarList[indexPath.row].posterPath,
                backPosterImagePath: similarList[indexPath.row].backdropPath,
                overView: similarList[indexPath.row].overview,
                modalStyle: .automatic
            )
        
        case CellType.recommendation.rawValue:
            self.presentTrendDetailVC(
                id: recommendationList[indexPath.row].id, 
                mediaType: self.mediaType,
                titleText: recommendationList[indexPath.row].name ?? recommendationList[indexPath.row].title,
                posterImagePath: recommendationList[indexPath.row].posterPath,
                backPosterImagePath: recommendationList[indexPath.row].backdropPath,
                overView: recommendationList[indexPath.row].overview,
                modalStyle: .automatic
            )
            
        case CellType.poster.rawValue:
            let vc = PosterDetailViewController()
            vc.poster = posterList[indexPath.row]
            present(vc, animated: true)
        default:
            break
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SimilarViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 20
        
        var size: CGFloat = 0.0
        switch collectionView.tag {
        case CellType.similarity.rawValue: size = 3.4
        case CellType.recommendation.rawValue: size = 3.4
        case CellType.poster.rawValue: size = 2.2
        default:
            break
        }
        let width: CGFloat = (collectionView.bounds.width - margin) / size
        let height: CGFloat = (collectionView.bounds.height - margin)
        
        return CGSize(width: width, height: height )
    }
}
