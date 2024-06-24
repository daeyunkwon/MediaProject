//
//  SimilarViewController.swift
//  MediaProject
//
//  Created by 권대윤 on 6/24/24.
//

import UIKit

import SnapKit

final class SimilarViewController: UIViewController {
    
    //MARK: - Properties
    
    var mediaTitle: String?
    var mediaType: MediaType = .movie
    var id: Int = 0
    
    var similarList: [SimilarResult] = []
    var recommendationList: [RecommendationResult] = []
    var posterList: [PosterResult] = []
    
    enum CellType: Int, CaseIterable {
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
        
        NetworkManager.shared.fetchSimilar(mediaType: self.mediaType, id: self.id) { data in
            self.similarList = data.results
            self.tableView.reloadData()
        }
        NetworkManager.shared.fetchRecommendation(mediaType: self.mediaType, id: self.id) { data in
            self.recommendationList = data.results
            self.tableView.reloadData()
        }
        NetworkManager.shared.fetchPoster(mediaType: self.mediaType, id: self.id) { data in
            self.posterList = data.backdrops
            self.tableView.reloadData()
        }
        setupTableView()
        configureLayout()
        configureUI()
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SimilarCollectionTableViewCell.self, forCellReuseIdentifier: SimilarCollectionTableViewCell.identifier)
    }
    
    private func configureLayout() {
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
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
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
        let cell = tableView.dequeueReusableCell(withIdentifier: SimilarCollectionTableViewCell.identifier, for: indexPath) as! SimilarCollectionTableViewCell
        
        switch indexPath.section {
        case CellType.similarity.rawValue:
            cell.cellType = .similarity
            cell.headerTextLabel.text = CellType.allCases[indexPath.section].title
            cell.similarList = self.similarList
            
        case CellType.recommendation.rawValue:
            cell.cellType = .recommendation
            cell.headerTextLabel.text = CellType.allCases[indexPath.section].title
            cell.recommendationList = self.recommendationList
            
        case CellType.poster.rawValue:
            cell.cellType = .poster
            cell.headerTextLabel.text = CellType.allCases[indexPath.section].title
            cell.posterList = self.posterList
        default:
            break
        }
        
        return cell
    }
}
