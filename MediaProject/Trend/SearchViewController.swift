//
//  SearchViewController.swift
//  MediaProject
//
//  Created by 권대윤 on 6/11/24.
//

import UIKit

import SnapKit

final class SearchViewController: BaseViewController {

    //MARK: - Properties
    
    private var searchResults: [SearchResult] = []
    private var page = 0
    private var totalPage = 0
    private var searchText: String = ""
    
    //MARK: - UI Components
    
    private let searchBar = UISearchBar()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }
    
    override func setupNavi() {
        navigationItem.title = "검색"
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "영화, 드라마, 배우 이름 검색"
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        searchBar.backgroundImage = UIImage()
    }
    
    override func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
    
    override func configureLayout() {
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
    
    override func configureUI() {
        super.configureUI()
        collectionView.backgroundColor = .systemBackground
    }
    
    //MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let cellCount: CGFloat = 3
        let spacing: CGFloat = 10
        let sectionInset: CGFloat = 10
        let width = UIScreen.main.bounds.width - ((spacing * (cellCount - 1) + sectionInset * 2))
        layout.itemSize = CGSize(width: width / cellCount, height: 150)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
        return layout
    }
}

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard var text = searchBar.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {return}
        text = text.trimmingCharacters(in: .whitespaces)
        
        if text == self.searchText {
            view.endEditing(true)
            return
        } else {
            self.searchText = text
            searchResults = []
            self.page = 1
            
            NetworkManager.shared.fetchData(api: .search(query: text, page: self.page)) { (data: Search?, error) in
                if error != nil {
                    self.showNetworkFailAlert(message: error ?? "")
                    return
                }
                
                if let safeData = data {
                    self.totalPage = safeData.totalPages
                    self.searchResults.append(contentsOf: safeData.results)
                    self.collectionView.reloadData()
                    if self.page == 1 && self.searchResults.count >= 1 {
                        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                    }
                }
            }
            view.endEditing(true)
        }
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
        for item in indexPaths {
            if item.row == self.searchResults.count - 3 && self.page < self.totalPage  {
                self.page += 1
                
                NetworkManager.shared.fetchData(api: .search(query: self.searchText, page: self.page)) { (data: Search?, error) in
                    if error != nil {
                        self.showNetworkFailAlert(message: error ?? "")
                        return
                    }
                    
                    if let safeData = data {
                        self.totalPage = safeData.totalPages
                        self.searchResults.append(contentsOf: safeData.results)
                        self.collectionView.reloadData()
                        if self.page == 1 && self.searchResults.count >= 1 {
                            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                        }
                    }
                }
            }
        }
    }
}
