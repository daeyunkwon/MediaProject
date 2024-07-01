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
        collectionView.keyboardDismissMode = .onDrag
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
        
        if text != self.searchText {
            self.searchText = text
            searchResults = []
            self.page = 1
            NetworkManager.shared.fetchData(api: .search(query: text, page: self.page), model: Search.self) { result in
                switch result {
                case .success(let data):
                    self.totalPage = data.totalPages
                    self.searchResults.append(contentsOf: data.results)
                    self.collectionView.reloadData()
                    if self.page == 1 && self.searchResults.count >= 1 {
                        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                    }
                    
                case .failure(let error):
                    self.showNetworkFailAlert(message: error.errorMessageForAlert)
                    print(error)
                }
            }
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = searchResults[indexPath.item].mediaType
        let mediaType = MediaType.allCases.filter {
            if $0.rawValue == type {
                return true
            }
            return false
        }
        
        switch mediaType.first ?? .movie {
        case MediaType.movie, MediaType.tv:
            self.presentTrendDetailVC(
                id: searchResults[indexPath.item].id,
                mediaType: mediaType.first ?? .movie,
                titleText: searchResults[indexPath.item].name ?? searchResults[indexPath.item].title,
                posterImagePath: searchResults[indexPath.item].posterPath,
                backPosterImagePath: searchResults[indexPath.item].backdropPath,
                overView: searchResults[indexPath.item].overview,
                modalStyle: .fullScreen,
                isShowSimilarButton: true
            )
            
        case MediaType.person:
            let vc = PersonDetailViewController()
            vc.id = searchResults[indexPath.item].id
            let navi = UINavigationController(rootViewController: vc)
            navi.modalPresentationStyle = .fullScreen
            present(navi, animated: true)
        }
    }
}

//MARK: - UICollectionViewDataSourcePrefetching

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            if item.row == self.searchResults.count - 3 && self.page < self.totalPage  {
                self.page += 1
                NetworkManager.shared.fetchData(api: .search(query: self.searchText, page: self.page), model: Search.self) { result in
                    switch result {
                    case .success(let data):
                        self.totalPage = data.totalPages
                        self.searchResults.append(contentsOf: data.results)
                        self.collectionView.reloadData()
                        if self.page == 1 && self.searchResults.count >= 1 {
                            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                        }
                        
                    case .failure(let error):
                        print(error)
                        self.showNetworkFailAlert(message: error.errorMessageForAlert)
                    }
                }
            }
        }
    }
}
