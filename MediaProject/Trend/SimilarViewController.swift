//
//  SimilarViewController.swift
//  MediaProject
//
//  Created by 권대윤 on 6/24/24.
//

import UIKit

import SnapKit

final class SimilarViewController: UIViewController {
    
    //MARK: - Properties
    
    var mediaTitle: String?
    
    //MARK: - UI Components
    
    private let mediaTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.textColor = .label
        return label
    }()
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureUI()
    }
    
    private func configureLayout() {
        view.addSubview(mediaTitleLabel)
        mediaTitleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        mediaTitleLabel.text = mediaTitle
    }
    
    
    //MARK: - Functions
    

}
