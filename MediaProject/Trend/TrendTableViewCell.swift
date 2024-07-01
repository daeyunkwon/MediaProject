//
//  TrendTableViewCell.swift
//  MediaProject
//
//  Created by 권대윤 on 6/10/24.
//

import UIKit

import Kingfisher

final class TrendTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var trend: Trend? {
        didSet {
            guard let trend = self.trend else {return}
            
            releaseDateLabel.text = trend.releaseDate ?? trend.firstAirDate
            let url = APIURL.makeImageURL(path: trend.posterPath ?? "")
            posterImageView.kf.setImage(with: url)
            averageValueLabel.text = trend.voteAverageString
            mediaTitleLabel.text = trend.title ?? trend.name
            mediaSubtitleLabel.text = trend.overview
        }
    }
    
    weak var delegate: TrendTableViewCellDelegate?
    
    //MARK: - UI Components
    
    private let backView: UIView = ShadowRadiusBackView()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .label
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var clipButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("", for: .normal)
        let image = Constant.SymbolSize.smallSize(systemName: "paperclip")
        btn.setImage(image, for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(clipButtonTapped), for: .touchUpInside)
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    private let averageTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        label.backgroundColor = .systemPurple
        label.textAlignment = .center
        return label
    }()
    
    private let averageValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let mediaTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    private let mediaSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()
    
    private let chevronRightMark: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .label
        return iv
    }()
    
    //MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        releaseDateLabel.text = ""
        typeLabel.text = ""
        mediaTitleLabel.text = ""
        mediaSubtitleLabel.text = ""
        averageValueLabel.text = ""
        posterImageView.image = nil
    }
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(releaseDateLabel)
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(releaseDateLabel.snp.bottom).offset(1)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        contentView.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.top)
            make.horizontalEdges.equalTo(backView.snp.horizontalEdges)
            make.bottom.equalTo(backView.snp.bottom).offset(-120)
        }
        
        contentView.addSubview(clipButton)
        clipButton.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.top).offset(15)
            make.trailing.equalTo(backView.snp.trailing).offset(-15)
            make.width.height.equalTo(30)
        }
        
        contentView.addSubview(averageTitleLabel)
        averageTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.leading).offset(15)
            make.bottom.equalTo(posterImageView.snp.bottom).offset(-15)
            make.width.equalTo(40)
            make.height.equalTo(30)
        }
        
        contentView.addSubview(averageValueLabel)
        averageValueLabel.snp.makeConstraints { make in
            make.top.equalTo(averageTitleLabel.snp.top)
            make.leading.equalTo(averageTitleLabel.snp.trailing)
            make.bottom.equalTo(averageTitleLabel.snp.bottom)
            make.width.equalTo(45)
        }
        
        contentView.addSubview(mediaTitleLabel)
        mediaTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(backView.snp.horizontalEdges).inset(15)
        }
        
        contentView.addSubview(mediaSubtitleLabel)
        mediaSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mediaTitleLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(backView.snp.horizontalEdges).inset(15)
        }
        
        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(mediaSubtitleLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(backView.snp.horizontalEdges).inset(15)
            make.height.equalTo(1)
        }
        
        contentView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { make in
            make.leading.equalTo(backView.snp.leading).offset(15)
            make.bottom.equalTo(backView.snp.bottom).offset(-15)
        }
        
        contentView.addSubview(chevronRightMark)
        chevronRightMark.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.trailing.equalTo(backView.snp.trailing).offset(-15)
            make.bottom.equalTo(backView.snp.bottom).offset(-15)
        }
    }
    
    private func configureUI() {
        contentView.backgroundColor = .systemBackground
        averageTitleLabel.text = "평점"
        detailLabel.text = "자세히 보기"
    }
    
    //MARK: - Functions
    
    @objc private func clipButtonTapped() {
        self.delegate?.clipButtonTapped(for: self)
    }
    
    func configureLabel(num: Int) {
        typeLabel.text = String(num) + "위 " + "#" + (trend?.type?.capitalized ?? "")
    }
}
