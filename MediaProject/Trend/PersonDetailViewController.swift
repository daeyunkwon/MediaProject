//
//  PersonDetailViewController.swift
//  MediaProject
//
//  Created by 권대윤 on 6/30/24.
//

import UIKit

import Kingfisher
import SnapKit

final class PersonDetailViewController: BaseViewController {
    
    //MARK: - Properties
    
    var id: Int = 0
    
    private var profile: Profile?
    
    private var filmography: [CombinedCredits] = []
    
    //MARK: - UI Components
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.systemGray2.cgColor
        iv.clipsToBounds = true
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let birthdayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    private let birthplaceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "필모그래피"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: PersonCollectionViewCell.identifier)
        collectionView.register(PersonHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PersonHeaderCollectionViewCell.identifier)
        return collectionView
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func fetchData() {
        let group = DispatchGroup()
        
        group.enter()
        NetworkManager.shared.fetchData(api: .profile(id: self.id), model: Profile.self) { result in
            switch result {
            case .success(let data):
                self.profile = data
                group.leave()
            
            case .failure(let error):
                self.showNetworkFailAlert(message: error.errorMessageForAlert)
                print(error)
                group.leave()
            }
        }
        
        group.enter()
        NetworkManager.shared.fetchData(api: .combinedCredits(id: self.id), model: CombinedCreditsData.self) { result in
            switch result {
            case .success(let data):
                self.filmography = data.cast ?? []
                group.leave()
            
            case .failure(let error):
                self.showNetworkFailAlert(message: error.errorMessageForAlert)
                print(error)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }
    
    override func setupNavi() {
        navigationItem.title = "프로필 정보"
        navigationController?.navigationBar.tintColor = .label
        
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    override func configureLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }

    override func configureUI() {
        super.configureUI()
    }
    
    //MARK: - Functions
    
    @objc private func leftBarButtonTapped() {
        dismiss(animated: true)
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension PersonDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filmography.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PersonHeaderCollectionViewCell.identifier, for: indexPath) as? PersonHeaderCollectionViewCell else {
            print("Failed to dequeue a PersonHeaderCollectionViewCell. Using default UICollectionReusableView.")
            return UICollectionReusableView()
        }
        header.profile = self.profile
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCollectionViewCell.identifier, for: indexPath) as? PersonCollectionViewCell else {
            print("Failed to dequeue a PersonCollectionViewCell. Using default UICollectionViewCell.")
            return UICollectionViewCell()
        }
        
        cell.cellConfig(data: filmography[indexPath.row])
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension PersonDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.frame.width - 40) / 3
        
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 45
    }
}
