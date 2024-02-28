////
////  MainTableViewCell.swift
////  OzinsheSnapKit
////
////  Created by Serper Kurmanbek on 28.02.2024.
////
//
//import UIKit
//import SDWebImage
//import Localize_Swift
//
//class TopAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
//    
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let attributes = super.layoutAttributesForElements(in: rect)?
//            .map { $0.copy() } as? [UICollectionViewLayoutAttributes]
//        
//        attributes?
//            .reduce([CGFloat: (CGFloat, [UICollectionViewLayoutAttributes])]()) {
//                guard $1.representedElementCategory == .cell else { return $0 }
//                return $0.merging([ceil($1.center.y): ($1.frame.origin.y, [$1])]) {
//                    ($0.0 < $1.0 ? $0.0 : $1.0, $0.1 + $1.1)
//                }
//            }
//            .values.forEach { minY, line in
//                line.forEach {
//                    $0.frame = $0.frame.offsetBy(
//                        dx: 0,
//                        dy: minY - $0.frame.origin.y
//                    )
//                }
//            }
//        
//        return attributes
//    }
//    
//}
//    class MainTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
//        
//        var mainMovie = MainMovies()
//        
//        override func awakeFromNib() {
//            super.awakeFromNib()
//            // Initialization code
//        }
//        
//        var categoryNameLabel: UILabel = {
//            var categoryNameLabel = UILabel()
//            categoryNameLabel.font = UIFont(name: "SFProDisplay-Bold", size: 16)
//            categoryNameLabel.textColor = UIColor(named: "#111827 - #FFFFFF")
//            
//            return categoryNameLabel
//        }()
//        
//        var  collectionview: UICollectionView = {
//            var layout = TopAlignedCollectionViewFlowLayout()
//            layout.sectionInset = UIEdgeInsets(top: 0, left: 24.0, bottom: 0, right: 24.0)
//            layout.minimumInteritemSpacing = 16
//            layout.minimumLineSpacing = 16
//            layout.scrollDirection = .horizontal
//            layout.estimatedItemSize.width = 112
//            layout.estimatedItemSize.height = 220
//            
//          var collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
//            collectionview.backgroundColor = UIColor(named: " #FFFFFF - #121827")
//            collectionview.isPagingEnabled = true
//            collectionview.isScrollEnabled = true
//            collectionview.showsHorizontalScrollIndicator = false
//            collectionview.bounces = false
//            collectionview.translatesAutoresizingMaskIntoConstraints = false
//           
//            return collectionview
//        }()
//        
//        let button: UIButton = {
//            var button = UIButton()
//            button.setTitle("SHOW_ALL_MOVIES".localized(), for: .normal)
//            button.setTitleColor(UIColor(named: "#B376F7"), for: .normal)
//            button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
//        }()
//        
//        override init(style: MainTableViewCell.CellStyle, reuseIdentifier: String?) {
//                super.init(style: style, reuseIdentifier: reuseIdentifier)
//                contentView.backgroundColor = UIColor(named: " #FFFFFF - #121827" )
//                contentView.addSubview(categoryNameLabel)
//                contentView.addSubview(collectionview)
//                contentView.addSubview(button)
//                setupConstraints()
//            }
//        
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//        
//        
//        override func setSelected(_ selected: Bool, animated: Bool) {
//            super.setSelected(selected, animated: animated)
//            
//        }
//        
//        func setData(mainMovie: MainMovies){
//            self.mainMovie = mainMovie
//            categoryNameLabel.text = mainMovie.categoryName
//            collectionview.reloadData()
//            
//        }
//        
//        
//        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            mainMovie.movies.count
//        }
//        
//        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: <#T##String#>, for: <#T##IndexPath#>)
//            
//         // ImageView
//            let transformer = SDImageResizingTransformer(size: CGSize(width: 112, height: 164), scaleMode: .aspectFill)
//            cell.imageView
//            
//            
//            
//            sd_setImage(with: URL(string: mainMovie.movies[indexPath.row].poster_link),placeholderImage: nil,context: [.imageTransformer: transformer])
//            imageview.layer.cornerRadius = 8
//        }
//        
//        
//        
//        func setupConstraints(){}
//    }
//    
//
