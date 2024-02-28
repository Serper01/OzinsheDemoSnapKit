//
//  OnboardingCell.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 21.02.2024.
//

import UIKit
import SnapKit

class OnboardingCell: UICollectionViewCell {
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
        
    }()
    
    let titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        titleLabel.textColor = UIColor(named: "#111827 - #FFFFFF")
        titleLabel.textAlignment = .center
        
        return titleLabel
    }()
    
    let subtitleLabel: UILabel = {
        var subtitleLabel = UILabel()
        subtitleLabel.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
        subtitleLabel.textColor = UIColor(named: "#9CA3AF")
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        
        return subtitleLabel
    }()
    
    
    override init(frame: CGRect){
        super.init(frame:frame)
        contentView.backgroundColor = UIColor(named: "#FFFFFF - #121827")
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(adaptiveSize(for: 504))
        }
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 40))
            make.bottom.equalTo(backgroundImageView.snp.bottom).inset(adaptiveSize(for: 2))
        }
        subtitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset((adaptiveSize(for: 32)))
            make.top.equalTo(titleLabel.snp.bottom).offset(adaptiveSize(for: 24))
        }
        
    }
    func setData(image: UIImage,title: String, subtitle: String) {
        backgroundImageView.image = image
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
