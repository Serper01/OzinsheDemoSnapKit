//
//  SimilarCollectionViewCell.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 03.03.2024.
//

import UIKit

class SimilarCollectionViewCell: UICollectionViewCell {
    
    var posterImage: UIImageView = {
        let posterImage = UIImageView()
        posterImage.layer.cornerRadius = 8
        posterImage.clipsToBounds = true
        return posterImage
    }()
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "SFProDisplay-Semibold", size: 12)
        titleLabel.textColor = UIColor(named: "#111827 - #FFFFFF")
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.font = UIFont(name: "SFProDisplay-Regular", size: 12)
        subtitleLabel.textColor = UIColor(named: "#9CA3AF")
        subtitleLabel.textAlignment = .left
        return subtitleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: " #FFFFFF - #121827")
        contentView.addSubview(posterImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints(){
        posterImage.snp.makeConstraints { make in
           make.top.leading.trailing.equalToSuperview()
           make.width.equalTo(112)
           make.height.equalTo(164)
       }
       titleLabel.snp.makeConstraints { make in
           make.top.equalTo(posterImage.snp.bottom).offset(8)
           make.horizontalEdges.equalToSuperview()
       }
       subtitleLabel.snp.makeConstraints { make in
           make.top.equalTo(titleLabel.snp.bottom).offset(4)
           make.horizontalEdges.bottom.equalToSuperview()
       }
   }
    
}
