//
//  MovieTableViewCell.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 02.03.2024.
//

import UIKit
import Localize_Swift

class MovieTableViewCell: UITableViewCell {

    var movie:[Movie] = []
    
    //MARK: - UI Elements
    var imageview: UIImageView = {
        var imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 8
        return imageview
    }()
    var nameLabel: UILabel = {
       var label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        label.textColor = UIColor(named: "#111827 - #FFFFFF")
        return label
    }()
    var yearLabel: UILabel = {
        var label = UILabel()
         label.font = UIFont(name: "SFProDisplay-Regular", size: 12)
         label.textColor = UIColor(named: "#9CA3AF")
         return label
    }()
   lazy var button: UIButton = {
       var button = UIButton()
        button.setTitleColor(UIColor(named: "#9753F0"), for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Bold", size: 12)
        button.backgroundColor = UIColor(named: "#F8EEFF - #1C2431")
        button.titleLabel?.snp.makeConstraints({ make in
            make.right.equalTo(button.snp.right).inset(12)
        })
        button.layer.cornerRadius = 8
        return button
    }()
    var playImageview: UIImageView = {
        var imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.image = UIImage(named: "Play")
        return imageview
    }()
    
    var genreNameLabel: UILabel = {
        var genreNameLabel = UILabel()
        genreNameLabel.font = UIFont(name: "SFProDisplay-Regular", size: 12)
        genreNameLabel.textColor = UIColor(named: "#9CA3AF")
        
        return genreNameLabel
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        contentView.addSubview(imageview)
        contentView.addSubview(nameLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(button)
        contentView.addSubview(playImageview)
//        contentView.addSubview(genreNameLabel)
        prepareForReuse()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        button.setTitle("PLAY".localized(), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

// MARK: - Extension, SetData, SetupConstraints
extension MovieTableViewCell {
    
    func setData(movie: Movie){
        imageview.sd_setImage(with: URL(string: movie.poster_link), completed: nil)
        nameLabel.text = movie.name
        genreNameLabel.text = "\(movie.genres)"
        yearLabel.text = "\(movie.year) • \(movie.genres.first?.name ?? "") • \(movie.categories.first?.name ?? "")"
    }
    
    func setupConstraints() {
    imageview.snp.makeConstraints { make in
        make.left.equalToSuperview().inset(adaptiveSize(for: 24))
        make.width.equalTo(71)
        make.height.equalTo(104)
        make.top.equalToSuperview().inset(adaptiveSize(for: 24))
    }
    nameLabel.snp.makeConstraints { make in
        make.top.equalToSuperview().inset(adaptiveSize(for: 24))
        make.left.equalTo(imageview.snp.right).inset(adaptiveSize(for: -17))
    }
    yearLabel.snp.makeConstraints { make in
        make.top.equalTo(nameLabel.snp.bottom).inset(adaptiveSize(for: -8))
        make.left.equalTo(imageview.snp.right).inset(adaptiveSize(for: -17))
    }
    button.snp.makeConstraints { make in
        make.top.equalTo(yearLabel.snp.bottom).inset(adaptiveSize(for: -24))
        make.left.equalTo(imageview.snp.right).inset(adaptiveSize(for: -17))
        make.height.equalTo(26)
        
    }
    playImageview.snp.makeConstraints { make in
        make.centerY.equalTo(button)
        make.width.height.equalTo(16)
        make.right.equalTo((button.titleLabel?.snp.left)!).inset(-6)
        make.left.equalTo(button.snp.left).inset(12)
    }
}
}
