//
//  TrendDetailViewController.swift
//  MediaProject
//
//  Created by 권대윤 on 6/10/24.
//

import UIKit

import SnapKit

final class TrendDetailViewController: UIViewController {

    //MARK: - Properties
    
    private var credits: [Cast] = []
    
    var mediaType: MediaType = .movie
    
    var id: Int = 0
    
    var titleText: String?
    var posterImagePath: String?
    var backPosterImagePath: String?
    var overView: String?
    
    //MARK: - UI Components
    
    private let backImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    }()
    
    private let mediaTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.textColor = .white
        return label
    }()
    
    private let tableView: UITableView = UITableView()
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "출연/제작"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.fetchCredits(mediaType: mediaType, id: id) { credits in
            self.credits = credits.cast
            self.tableView.reloadData()
        }
        setupNavi()
        setupTableView()
        configureLayout()
        configureUI()
    }
    
    private func setupNavi() {
        let button = UIButton(type: .system)
        button.setTitle("비슷한 콘텐츠", for: .normal)
        button.setImage(UIImage(systemName: "plus.magnifyingglass")?.applyingSymbolConfiguration(.init(font: UIFont.systemFont(ofSize: 13), scale: .large)), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(rightBarButtonTapped), for: .touchUpInside)
        let rightButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrendDetailOverViewTableViewCell.self, forCellReuseIdentifier: TrendDetailOverViewTableViewCell.identifier)
        tableView.register(TrendDetailCastTableViewCell.self, forCellReuseIdentifier: TrendDetailCastTableViewCell.identifier)
    }
    
    private func configureLayout() {
        view.addSubview(backImageView)
        backImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        view.addSubview(mediaTitleLabel)
        mediaTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(backImageView.snp.top).offset(10)
            make.leading.equalTo(backImageView.snp.leading).offset(20)
            make.height.equalTo(40)
        }
        
        view.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(mediaTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(backImageView.snp.leading).offset(20)
            make.bottom.equalTo(backImageView.snp.bottom).offset(-5)
            make.width.equalTo(100)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(backImageView.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        self.mediaTitleLabel.text = titleText
        
        backImageView.kf.setImage(with: APIURL.makeImageURL(path: backPosterImagePath ?? ""))
        
        posterImageView.kf.setImage(with: APIURL.makeImageURL(path: posterImagePath ?? ""))
    }
    
    //MARK: - Functions
    
    @objc func rightBarButtonTapped() {
        let vc = SimilarViewController()
        vc.mediaTitle = self.titleText
        vc.mediaType = self.mediaType
        vc.id = self.id
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension TrendDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "OverView"
        case 1:
            return "Cast"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return 100
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.credits.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TrendDetailOverViewTableViewCell.identifier, for: indexPath) as! TrendDetailOverViewTableViewCell
            cell.overView = self.overView
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TrendDetailCastTableViewCell.identifier, for: indexPath) as! TrendDetailCastTableViewCell
            cell.credit = self.credits[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: - TrendDetailOverViewCellDelegate

extension TrendDetailViewController: TrendDetailOverViewCellDelegate {
    func moreButtonTapped(for cell: TrendDetailOverViewTableViewCell) {
        if !cell.moreExecute {
            cell.moreExecute.toggle()
            cell.moreButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            cell.overViewTextView.snp.updateConstraints { make in
                make.height.lessThanOrEqualTo(1000)
            }
            
            cell.moreButton.snp.updateConstraints { make in
                make.height.lessThanOrEqualTo(40)
            }
        } else {
            cell.moreExecute.toggle()
            cell.moreButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            cell.overViewTextView.snp.updateConstraints { make in
                make.height.lessThanOrEqualTo(40)
            }
            
            cell.moreButton.snp.updateConstraints { make in
                make.height.lessThanOrEqualTo(1000)
            }
        }
        
        tableView.reloadData()
    }
}
