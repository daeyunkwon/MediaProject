//
//  ViewController.swift
//  MediaProject
//
//  Created by 권대윤 on 6/10/24.
//

import UIKit

import Alamofire
import SnapKit

final class TrendViewController: UIViewController {
    
    //MARK: - Properties
    
    private var trends: [Trend] = []
    
    //MARK: - UI Components
    
    private let tableView = UITableView()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callRequest()
        setupNavi()
        setupTableView()
        configureLayout()
        configureUI()
    }
    
    private func setupNavi() {
        navigationItem.title = ""
        navigationController?.navigationBar.tintColor = .label
        
        let list = UIBarButtonItem(image: UIImage(systemName: "list.triangle"), style: .plain, target: self, action: #selector(listBarButtonTapped))
        navigationItem.leftBarButtonItem = list
        
        let search = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchBarButtonTapped))
        navigationItem.rightBarButtonItem = search
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrendTableViewCell.self, forCellReuseIdentifier: TrendTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
    }
    
    //MARK: - Functions
    
    private func callRequest() {
        let param: Parameters = [
            "language": "ko-KR"
        ]
        
        let header: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": APIKey.apiKey
        ]
        
        AF.request(APIURL.trendAPIURL, method: .get, parameters: param, encoding: URLEncoding.queryString, headers: header).responseDecodable(of: TrendData.self) { response in
            switch response.result {
            case .success(let data):
                self.trends = data.results
                self.tableView.reloadData()
            case .failure(let error):
                print(response.response?.statusCode ?? 0)
                print(error)
            }
        }
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: TrendTableViewCell.identifier, for: indexPath) as! TrendTableViewCell
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

