//
//  ViewController.swift
//  MediaProject
//
//  Created by 권대윤 on 6/10/24.
//

import UIKit

import SnapKit

final class TrendViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var trends: [Trend] = []
    
    private var currentFilterType: TMDBAPI.TrendType = .tv
    
    private var itemsForMenu: [UIAction] {
        let filteredAll = UIAction(title: "전체") { [weak self] _ in
            self?.fetchData(type: .all)
        }
        
        let filteredMovie = UIAction(title: "영화") { [weak self] _ in
            self?.fetchData(type: .movie)
        }
        
        let filteredTv = UIAction(title: "드라마") { [weak self] _ in
            self?.fetchData(type: .tv)
        }
        
        return [filteredAll, filteredMovie, filteredTv]
    }
    
    //MARK: - UI Components
    
    private let tableView = UITableView()
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "차트 순위"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(type: .all)
    }
    
    private func fetchData(type: TMDBAPI.TrendType) {
        if self.currentFilterType == type {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            return
        }
        
        NetworkManager.shared.fetchData(api: .trend(type: type), model: TrendData.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.currentFilterType = type
                self.trends = data.results
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            
            case .failure(let error):
                self.showNetworkFailAlert(message: error.errorMessageForAlert)
                print(error)
            }
        }
    }
    
    override func setupNavi() {
        navigationController?.navigationBar.tintColor = .label
            
        let menu = UIMenu(title: "카테고리", children: self.itemsForMenu)
        let list = UIBarButtonItem(title: nil, image: UIImage(systemName: "list.dash"), primaryAction: nil, menu: menu)
        navigationItem.leftBarButtonItem = list
        
        let search = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchBarButtonTapped))
        navigationItem.rightBarButtonItem = search
    }
    
    override func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrendTableViewCell.self, forCellReuseIdentifier: TrendTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    override func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureUI() {
        super.configureUI()
        tableView.backgroundColor = .systemBackground
    }
    
    //MARK: - Functions
    
    @objc private func searchBarButtonTapped() {
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension TrendViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendTableViewCell.identifier, for: indexPath) as? TrendTableViewCell else {
            print("Failed to dequeue a TrendTableViewCell. Using default UITableViewCell.")
            return UITableViewCell()
        }
        cell.delegate = self
        cell.trend = self.trends[indexPath.row]
        cell.configureLabel(num: indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TrendDetailViewController()
        
        if self.trends[indexPath.row].mediaType == .movie {
            vc.mediaType = .movie
        } else if self.trends[indexPath.row].mediaType == .tv {
            vc.mediaType = .tv
        }
        
        vc.id = trends[indexPath.row].id ?? 0
        vc.titleText = trends[indexPath.row].title ?? trends[indexPath.row].name
        vc.posterImagePath = trends[indexPath.row].posterPath
        vc.backPosterImagePath = trends[indexPath.row].backdropPath
        vc.overView = trends[indexPath.row].overview
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - TrendTableViewCellDelegate

extension TrendViewController: TrendTableViewCellDelegate {
    func clipButtonTapped(for cell: TrendTableViewCell) {
        print(#function)
    }
}
