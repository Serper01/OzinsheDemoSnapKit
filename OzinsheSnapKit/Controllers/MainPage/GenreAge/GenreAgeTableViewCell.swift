//
//  GenreAgeTableViewCell.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 28.02.2024.
//

import UIKit
import SDWebImage
import Localize_Swift

class GenreAgeTableViewCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDataSource {
  
    var mainMovie = MainMovies()
    var delegate : MovieProtocol?
    
    var categoryNameLabel: UILabel = {
        var categoryNameLabel = UILabel()
        categoryNameLabel.font = UIFont(name: "SFProDisplay-Bold", size: 16)
        categoryNameLabel.textColor = UIColor(named: "#111827 - #FFFFFF")
        
        return categoryNameLabel
    }()
    
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24.0, bottom: 0, right: 24.0)
        layout.estimatedItemSize.height = 112
        layout.estimatedItemSize.width = 184
        
        var collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GenreAgeCollectionViewCell.self,forCellWithReuseIdentifier: "genreAgeCell")
        return collectionView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        contentView.addSubview(categoryNameLabel)
        contentView.addSubview(collectionView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(mainMovie:MainMovies) {
        self.mainMovie = mainMovie
        collectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if mainMovie.cellType == .ageCategory {
            return mainMovie.categoryAges.count
        }
        return mainMovie.genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreAgeCell", for: indexPath) as! GenreAgeCollectionViewCell
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: 184, height: 112), scaleMode: .aspectFill)
         
        if mainMovie.cellType == .ageCategory {
            cell.imageView.sd_setImage(with: URL(string: mainMovie.categoryAges[indexPath.row].link), placeholderImage: nil, context: [.imageTransformer: transformer])
            cell.titleLabel.text = mainMovie.categoryAges[indexPath.row].name
            categoryNameLabel.text = "Жасына сәйкес"
        } else {
            cell.imageView.sd_setImage(with: URL(string: mainMovie.genres[indexPath.row].link), placeholderImage: nil, context: [.imageTransformer: transformer])
            cell.titleLabel.text = mainMovie.genres[indexPath.row].name
            categoryNameLabel.text = "Жанрды таңдаңыз"
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           collectionView.deselectItem(at: indexPath, animated: true)
           
           if mainMovie.cellType == .genre{
               delegate?.genreDidSelect(genreId: mainMovie.genres[indexPath.row].id, genreName: mainMovie.genres[indexPath.row].name)
           
           }else{
               delegate?.ageCategoryDidSelect(categoryAgeId: mainMovie.categoryAges[indexPath.row].id)
           }
          
       }
    func setupConstraints() {
        categoryNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.leading.equalToSuperview().inset(24)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryNameLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
