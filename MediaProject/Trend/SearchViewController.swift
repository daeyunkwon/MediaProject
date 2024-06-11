//
//  SearchViewController.swift
//  MediaProject
//
//  Created by 권대윤 on 6/11/24.
//

import UIKit

import Alamofire
import SnapKit

final class SearchViewController: UIViewController {

    //MARK: - Properties
    
    var searchResults: [SearchResult] = [] {
        didSet {
            print(searchResults)
        }
    }
    var page = 1
    
    //MARK: - UI Components
    
    private let searchBar = UISearchBar()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        setupSearchBar()
        setupCollectionView()
        configureLayout()
        configureUI()
        //callRequest(query: "신세계")
    }
    
    private func setupNavi() {
        navigationItem.title = "검색"
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "영화, 드라마, 배우 이름 검색"
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        searchBar.backgroundImage = UIImage()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
    
    private func configureLayout() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .systemBackground
    }
    
    //MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 40
        layout.itemSize = CGSize(width: width / 3, height: 150)
        layout.scrollDirection = .vertical //스크롤 방향
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }
    
    private func callRequest(query: String) {
        let param: Parameters = [
            "query": query,
            "page": self.page,
            "lagnuage": "ko-KR",
            "include_adult": false
        ]
        
        let header: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": APIKey.apiKey
        ]
        
        AF.request(APIURL.searchAPIURL, method: .get, parameters: param, encoding: URLEncoding.queryString, headers: header).responseDecodable(of: Search.self) { response in
            switch response.result {
            case .success(let data):
                self.searchResults.append(contentsOf: data.results)
                
                self.collectionView.reloadData()
                if self.page == 1 && self.searchResults.count >= 1 {
                    self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {return}
        searchResults = []
        callRequest(query: text)
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else {return}
        
        if text.isEmpty {
            self.searchBar.enablesReturnKeyAutomatically = false
        } else {
            self.searchBar.enablesReturnKeyAutomatically = true
        }
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        cell.searchResult = self.searchResults[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionViewDataSourcePrefetching

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print(#function)
    }
}
