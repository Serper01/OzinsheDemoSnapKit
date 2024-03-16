//
//  MainTableViewCell.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 28.02.2024.
//

import UIKit
import SDWebImage
import Localize_Swift

class TopAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)?
            .map { $0.copy() } as? [UICollectionViewLayoutAttributes]
        
        attributes?
            .reduce([CGFloat: (CGFloat, [UICollectionViewLayoutAttributes])]()) {
                guard $1.representedElementCategory == .cell else { return $0 }
                return $0.merging([ceil($1.center.y): ($1.frame.origin.y, [$1])]) {
                    ($0.0 < $1.0 ? $0.0 : $1.0, $0.1 + $1.1)
                }
            }
            .values.forEach { minY, line in
                line.forEach {
                    $0.frame = $0.frame.offsetBy(
                        dx: 0,
                        dy: minY - $0.frame.origin.y
                    )
                }
            }
        
        return attributes
    }
    
}
class MainTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var mainMovie = MainMovies()
    var delegate : MovieProtocol?
    
    // MARK: - UI Elements
    var categoryNameLabel: UILabel = {
        var categoryNameLabel = UILabel()
        categoryNameLabel.font = UIFont(name: "SFProDisplay-Bold", size: 16)
        categoryNameLabel.textColor = UIColor(named: "#111827 - #FFFFFF")
        return categoryNameLabel
    }()
    
    lazy var  collectionview: UICollectionView = {
        var layout = TopAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24.0, bottom: 0, right: 24.0)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize.width = 112
        layout.estimatedItemSize.height = 220
        
        var collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.isPagingEnabled = true
        collectionview.isScrollEnabled = true
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.bounces = false
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "mainCollectionViewCell")
        return collectionview
    }()
    
    let button: UIButton = {
        var button = UIButton()
        button.setTitleColor(UIColor(named: "#B376F7"), for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
        return button
    }()
    
    override init(style: MainTableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(named: " #FFFFFF - #121827" )
        contentView.addSubview(categoryNameLabel)
        contentView.addSubview(collectionview)
        contentView.addSubview(button)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        button.setTitle("SHOW_ALL_MOVIES".localized(), for: .normal)
    }
    
    func setData(mainMovie: MainMovies){
        self.mainMovie = mainMovie
        categoryNameLabel.text = mainMovie.categoryName
        collectionview.reloadData()
    }
    
    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mainMovie.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.movieDidSelect(movie: mainMovie.movies[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        // ImageView
        let transformer = SDImageResizingTransformer(size: CGSize(width: 112, height: 164), scaleMode: .aspectFill)
        cell.imageView.sd_setImage(with: URL(string: mainMovie.movies[indexPath.row].poster_link),placeholderImage: nil, context: [.imageTransformer: transformer])
        cell.titleLabel.text = mainMovie.movies[indexPath.row].name
        
        if let genreName = mainMovie.movies[indexPath.row].genres.first {
            cell.subtitleLabel.text = genreName.name
        } else {
            cell.subtitleLabel.text = ""
        }
        return cell
    }
}
    // MARK: - Extension
   extension MainTableViewCell {
    
    func setupConstraints() {
        categoryNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.leading.equalToSuperview().inset(24)
        }
        collectionview.snp.makeConstraints { make in
            make.top.equalTo(categoryNameLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        button.snp.makeConstraints { make in
            make.centerY.equalTo(categoryNameLabel)
            make.right.equalToSuperview().inset(24)
        }
    }
}
