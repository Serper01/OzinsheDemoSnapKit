//
//  GenreAgeCollectionViewCell.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 01.03.2024.
//

import UIKit
import SnapKit

class GenreAgeCollectionViewCell: UICollectionViewCell {
    var mainMovies = MainMovies()
    var delegate : MovieProtocol?
    
    var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(112)
            make.width.equalTo(184)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(imageView)
            make.horizontalEdges.equalTo(imageView).inset(24)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           collectionView.deselectItem(at: indexPath, animated: true)
           
           if mainMovies.cellType == .genre{
               delegate?.genreDidSelect(genreId: mainMovies.genres[indexPath.row].id, genreName: mainMovies.genres[indexPath.row].name)
           
           }else{
               delegate?.ageCategoryDidSelect(categoryAgeId: mainMovies.categoryAges[indexPath.row].id)
           }
          
       }
    
}
