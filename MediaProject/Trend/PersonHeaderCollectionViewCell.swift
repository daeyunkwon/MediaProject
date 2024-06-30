//
//  PersonHeaderCollectionViewCell.swift
//  MediaProject
//
//  Created by 권대윤 on 6/30/24.
//

import UIKit

import SnapKit

final class PersonHeaderCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var profile: Profile? {
        didSet {
            guard let data = self.profile else { return }
            
            guard let url = APIURL.makeImageURL(path: data.profilePath ?? "") else { return }
            self.profileImageView.kf.setImage(with: url)
            
            self.nameLabel.text = data.name
            self.birthdayLabel.text = data.birthdayDateString
            self.birthplaceLabel.text = data.birthplace
        }
    }
    
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
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    private let birthplaceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "필모그래피"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    //MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profileImageView.image = nil
        self.nameLabel.text = nil
        self.birthdayLabel.text = nil
        self.birthplaceLabel.text = nil
    }
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        
        DispatchQueue.main.async {
            self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.height / 2
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.width.height.equalTo(120)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(birthdayLabel)
        birthdayLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(birthplaceLabel)
        birthplaceLabel.snp.makeConstraints { make in
            make.top.equalTo(birthdayLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(birthplaceLabel.snp.bottom).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(10)
        }
    }
}
