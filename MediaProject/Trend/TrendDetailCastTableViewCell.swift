//
//  TrendDetailCastTableViewCell.swift
//  MediaProject
//
//  Created by 권대윤 on 6/10/24.
//

import UIKit

import SnapKit

final class TrendDetailCastTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var credit: Cast? {
        didSet {
            guard let cast = credit else {return}
            
            let url = APIURL.makeImageURL(path: cast.profilePath ?? "")
            profileImageView.kf.setImage(with: url)
            
            nameLabel.text = cast.actorName
            characterNameLabel.text = cast.characterName
        }
    }
    
    //MARK: - UI Components
    
    private let profileImageView: UIImageView = {
        let iv = PrimaryImageView(frame: .zero)
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .label
        return label
    }()
    
    private let characterNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        return label
    }()

    //MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = ""
        characterNameLabel.text = ""
    }
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(5)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.bottom.equalTo(contentView.snp.bottom).offset(-5)
            make.width.equalTo(70)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
            make.centerY.equalTo(profileImageView.snp.centerY).offset(-13)
        }
        
        contentView.addSubview(characterNameLabel)
        characterNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
            make.centerY.equalTo(profileImageView.snp.centerY).offset(13)
        }
    }
}
