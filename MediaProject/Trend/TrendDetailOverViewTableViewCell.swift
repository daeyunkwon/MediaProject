//
//  TrendDetailTableViewCell.swift
//  MediaProject
//
//  Created by 권대윤 on 6/10/24.
//

import UIKit

import SnapKit

final class TrendDetailOverViewTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var overView: String? {
        didSet {
            overViewTextView.text = self.overView
        }
    }
    
    weak var delegate: TrendDetailOverViewCellDelegate?
    
    var moreExecute: Bool = false
    
    //MARK: - UI Components
    
    let overViewTextView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.textAlignment = .center
        tv.font = .systemFont(ofSize: 14)
        return tv
    }()
    
    lazy var moreButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("", for: .normal)
        btn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        btn.tintColor = .label
        btn.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    
    //MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.overViewTextView.text = ""
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
        contentView.addSubview(overViewTextView)
        overViewTextView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(30)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.height.lessThanOrEqualTo(40)
        }
        
        contentView.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(overViewTextView.snp.bottom).offset(10)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.lessThanOrEqualTo(1000)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
    }
    
    //MARK: - Functions
    
    @objc private func moreButtonTapped() {
        self.delegate?.moreButtonTapped(for: self)
    }
}
