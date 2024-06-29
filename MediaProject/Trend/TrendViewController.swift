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
    
    //MARK: - UI Components
    
    private let tableView = UITableView()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func fetchData() {
        NetworkManager.shared.fetchData(api: .trend) { (data: TrendData?, error) in
            if error != nil {
                self.showNetworkFailAlert(message: error ?? "")
                return
            }
            
            if let safeData = data?.results {
                self.trends = safeData
                self.tableView.reloadData()
            }
        }
    }
    
    override func setupNavi() {
        navigationItem.title = ""
        navigationController?.navigationBar.tintColor = .label
        
        let list = UIBarButtonItem(image: UIImage(systemName: "list.triangle"), style: .plain, target: self, action: #selector(listBarButtonTapped))
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
    
    @objc func listBarButtonTapped() {
        print(#function)
    }
    
    @objc func searchBarButtonTapped() {
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
