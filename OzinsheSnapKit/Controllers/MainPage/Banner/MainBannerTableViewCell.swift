//
//  MainBannerTableViewCell.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 28.02.2024.
//

import UIKit

class MainBannerTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
 
    var mainMovie = MainMovies()
    var delegate : MovieProtocol?
    
  lazy  var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 22, left: 24, bottom: 10, right: 24)
        layout.estimatedItemSize.width = 112
        layout.estimatedItemSize.height = 220
        
        var collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.isPagingEnabled = true
        collectionview.isScrollEnabled = true
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.bounces = false
        collectionview.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: "bannerCell")
        
        return collectionview
    }()
    
    override init(style: MainTableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        contentView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        contentView.addSubview(collectionView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           collectionView.deselectItem(at: indexPath, animated: true)
           delegate?.movieDidSelect(movie: mainMovie.bannerMovie[indexPath.row].movie)
       }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainMovie.bannerMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as! BannerCollectionViewCell
        
        cell.setData(bannerMovie: mainMovie.bannerMovie[indexPath.row])
        
        return cell
        
    }
}
// MARK: - Extension
extension MainBannerTableViewCell {
    
    func setData(mainMovie: MainMovies){
          self.mainMovie = mainMovie
          collectionView.reloadData()
      }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
}
