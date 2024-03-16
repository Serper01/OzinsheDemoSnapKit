//
//  CategoryCollectionViewCell.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 02.03.2024.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        titleLabel.textColor = UIColor(named: "#111827 - #FFFFFF")
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    var subtitleLabel:UILabel = {
        var subtitleLabel = UILabel()
        subtitleLabel.font = UIFont(name: "SFProDisplay-Regular", size: 12)
        subtitleLabel.textColor = UIColor(named: "#9CA3AF")
        subtitleLabel.textAlignment = .left
        return subtitleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension
extension CategoryCollectionViewCell {
    
    func setupConstraints(){
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(164)
            make.width.equalTo(112)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
}
