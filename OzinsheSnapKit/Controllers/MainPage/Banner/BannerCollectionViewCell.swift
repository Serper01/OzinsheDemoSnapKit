//
//  BannerCollectionViewCell.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 28.02.2024.
//

import UIKit
import SnapKit
import SDWebImage

class BannerCollectionViewCell: UICollectionViewCell {
    
    var bannerImageView: UIImageView = {
        let bannerImageVIew = UIImageView()
        bannerImageVIew.contentMode = .scaleAspectFit
        bannerImageVIew.clipsToBounds = true
        bannerImageVIew.layer.cornerRadius = 12
        
        return bannerImageVIew
    }()
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        titleLabel.textColor = UIColor(named: "#111827 - #FFFFFF")
        titleLabel.textAlignment = .left
        
        return titleLabel
    }()
    
    var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.font = UIFont(name: "SFProDisplay-Regular", size: 12)
        subtitleLabel.textColor = UIColor(named: "#9CA3AF")
        subtitleLabel.textAlignment = .left
        subtitleLabel.numberOfLines = 0
        
        return subtitleLabel
        
    }()
    
    var categoryView: UIView = {
        let categoryView = UIView()
        categoryView.backgroundColor = UIColor(named: "#7E2DFC")
        categoryView.layer.cornerRadius = 8
        
        return categoryView
    }()
    
    var categoryLabel: UILabel = {
        let categoryLabel = UILabel()
        categoryLabel.font = UIFont(name: "SFProDisplay-Semibold", size: 12)
        categoryLabel.textColor = UIColor.white
        
        return categoryLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        contentView.addSubview(bannerImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(categoryView)
        contentView.addSubview(categoryLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension
extension BannerCollectionViewCell {
    
    func setupConstraints(){
        
        bannerImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(164)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bannerImageView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        categoryView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.equalTo(bannerImageView.snp.left).inset(8)
            make.height.equalTo(24)
        }
        categoryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(categoryView)
            make.horizontalEdges.equalTo(categoryView.snp.horizontalEdges).inset(8)
        }
    }
    
    func setData(bannerMovie: BannerMovie ){
        let transformer = SDImageResizingTransformer(size: CGSize(width: 300, height: 164), scaleMode: .aspectFill)
        bannerImageView.sd_setImage(with: URL(string: bannerMovie.link), placeholderImage: nil, context: [.imageTransformer: transformer])
        
        if let categoryName = bannerMovie.movie.categories.first?.name{
            categoryLabel.text = categoryName
        }
        titleLabel.text = bannerMovie.movie.name
        subtitleLabel.text = bannerMovie.movie.description
    }
}


