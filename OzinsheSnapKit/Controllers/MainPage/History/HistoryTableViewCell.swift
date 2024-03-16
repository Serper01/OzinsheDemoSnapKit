//
//  HistoryTableViewCell.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 28.02.2024.
//

import UIKit
import SnapKit
import SDWebImage
import Localize_Swift

class HistoryTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
     
    var mainMovie = MainMovies()
    var delegate : MovieProtocol?
    
    var categoryNameLabel: UILabel = {
        var categoryNameLabel = UILabel()
        categoryNameLabel.font = UIFont(name: "SFProDisplay-Bold", size: 16)
        categoryNameLabel.textColor = UIColor(named: "#111827 - #FFFFFF")
        categoryNameLabel.text = "CONTINUE_WATCHING".localized()
        return categoryNameLabel
    }()
    
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        layout.estimatedItemSize.width = 184
        layout.estimatedItemSize.height = 112
        
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(HistoryCollectionViewCell.self, forCellWithReuseIdentifier: "historyCell")
          
        return collectionView
    }()
    
    override init(style:UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
               contentView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
               contentView.addSubview(categoryNameLabel)
               contentView.addSubview(collectionView)
               
               setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(mainMovie: MainMovies){
        self.mainMovie = mainMovie
        collectionView.reloadData()
        
    }
    //MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         collectionView.deselectItem(at: indexPath, animated: true)
         delegate?.movieDidSelect(movie: mainMovie.movies[indexPath.row])
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainMovie.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyCell", for: indexPath) as! HistoryCollectionViewCell
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: 184, height: 112), scaleMode: .aspectFill)
                 
        cell.imageView.sd_setImage(with: URL(string: mainMovie.movies[indexPath.row].poster_link),placeholderImage: nil,context: [.imageTransformer: transformer])
                
        cell.titleLabel.text = mainMovie.movies[indexPath.row].name
            
        if let genrename = mainMovie.movies[indexPath.row].genres.first{
            cell.subtitleLabel.text = genrename.name
        }else{
            cell.subtitleLabel.text = ""
        }
        
        return cell
    }
}
// MARK: - Extension
extension HistoryTableViewCell {
    
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

