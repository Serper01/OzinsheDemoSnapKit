//
//  DetailViewController.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 02.03.2024.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON
import SVProgressHUD
import Localize_Swift

class DetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var movie = Movie()
    var similarMovies: [Movie] = []
    var screenshots: [Screenshot] = []
    
    // MARK: - UI Elements
    var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        scrollView.isScrollEnabled = true
        scrollView.clipsToBounds = true
        scrollView.contentMode = .scaleAspectFill
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    var contentView: UIView = {
        var contentView = UIView()
        contentView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        return contentView
    }()
    
    var posterImageView: UIImageView = {
        var posterImageView = UIImageView()
        posterImageView.contentMode = .scaleAspectFill
        return posterImageView
    }()
    
    var gradientView: GradientView = {
        var gradientView = GradientView(frame: .zero)
        gradientView.startColor = UIColor(named: "#0F161D 0%")!
        gradientView.endColor = UIColor(named: "#0F161D  100%")!
        return gradientView
    }()
    
    var backButton: UIButton = {
        var backButton = UIButton()
        backButton.backgroundColor = UIColor.clear
        backButton.setImage(UIImage(named: ""), for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return backButton
    }()
    
    var favoriteButton: UIButton = {
        var favoriteButton = UIButton()
        favoriteButton.setImage(UIImage(named: "FavoriteButton2"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        return favoriteButton
    }()
    
    var playButton: UIButton = {
        var playButton = UIButton()
        playButton.setImage(UIImage(named: "PlayButton"), for: .normal)
        playButton.addTarget(self, action: #selector(playMovie), for: .touchUpInside)
        playButton.contentMode = .scaleAspectFill
        playButton.clipsToBounds = true
        return playButton
    }()
    
    var shareButton: UIButton = {
        var shareButton = UIButton()
        shareButton.setImage(UIImage(named: "ShareButton2"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareMovie), for: .touchUpInside)
        return shareButton
    }()
    
    var favoriteLabel: UILabel = {
        var favoriteLabel = UILabel()
        favoriteLabel.font = UIFont(name: "SFProDisplay-Bold", size: 12)
        favoriteLabel.textColor = UIColor(named: "#D1D5DB - #9CA3AF")
        favoriteLabel.text = "ADD_TO_FAVORITE".localized()
        return favoriteLabel
    }()
    
    var shareLabel: UILabel = {
        var shareLabel = UILabel()
        shareLabel.font = UIFont(name: "SFProDisplay-Bold", size: 12)
        shareLabel.textColor = UIColor(named: "#D1D5DB - #9CA3AF")
        shareLabel.text = "SHARE".localized()
        return shareLabel
    }()
    
    // MARK: -BackgroundView
    
    var backgroundView: UIView = {
        var backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        backgroundView.layer.cornerRadius = 32
        backgroundView.clipsToBounds = true
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return backgroundView
    }()
    
    var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        titleLabel.textColor = UIColor(named: "#111827 - #FFFFFF")
        return titleLabel
    }()
    
    var detailLabel: UILabel = {
        var detailLabel = UILabel()
        detailLabel.font = UIFont(name: "SFProDisplay-Bold", size: 12)
        detailLabel.textColor = UIColor(named: "#9CA3AF")
        return detailLabel
    }()
    
    var topLineView: UIView = {
        var topLineView = UIView()
        topLineView.backgroundColor = UIColor(named: "#D1D5DB - #1C2431")
        return topLineView
    }()
    
    var descriptionLabel: UILabel = {
        var descriptionLabel = UILabel()
        descriptionLabel.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
        descriptionLabel.textColor = UIColor(named: "#9CA3AF - #E5E7EB")
        descriptionLabel.numberOfLines = 4
        return descriptionLabel
    }()
    
    var descriptionGradientView: GradientView = {
        var descriptionGradientView = GradientView()
        descriptionGradientView.startColor = UIColor(named: "transparent")!
        descriptionGradientView.endColor = UIColor(named: " #FFFFFF - #121827")!
        return descriptionGradientView
    }()
    
    var showFullDescription: UIButton = {
        var showFullDescription = UIButton()
        showFullDescription.backgroundColor = UIColor.clear
        showFullDescription.setTitle("READ_MORE".localized(), for: .normal)
        showFullDescription.setTitleColor(UIColor(named: "#B376F7"), for: .normal)
        showFullDescription.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
        showFullDescription.addTarget(self, action: #selector(showDescription), for: .touchUpInside)
        return showFullDescription
    }()
    
    var directorLabel: UILabel = {
        var directorLabel = UILabel()
        directorLabel.text = "DIRECTOR:".localized()
        directorLabel.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        directorLabel.textColor = UIColor(named: "#4B5563")
        return directorLabel
    }()
    
    var directorNameLabel: UILabel = {
        var directorNameLabel = UILabel()
        directorNameLabel.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        directorNameLabel.textColor = UIColor(named: "#9CA3AF")
        return directorNameLabel
    }()
    
    var directorStackView: UIStackView = {
        var directorStackView = UIStackView()
        directorStackView.axis = .horizontal
        directorStackView.spacing = 19
        return directorStackView
    }()
    
    var producerLabel: UILabel = {
        var producerLabel = UILabel()
        producerLabel.text = "PRODUCER".localized()
        producerLabel.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        producerLabel.textColor = UIColor(named: "#4B5563")
        
        return producerLabel
    }()
    
    var producerNameLabel: UILabel = {
        var producerNameLabel = UILabel()
        producerNameLabel.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        producerNameLabel.textColor = UIColor(named: "#9CA3AF")
        return producerNameLabel
    }()
    
    var producerStackView: UIStackView = {
        var producerStackView = UIStackView()
        producerStackView.axis = .horizontal
        producerStackView.spacing = 19
        return producerStackView
    }()
    
    
    var bottomLineView: UIView = {
        var bottomLineView = UIView()
        bottomLineView.backgroundColor = UIColor(named: "#D1D5DB - #1C2431")
        return bottomLineView
    }()
    
    var seriesLabel: UILabel = {
        var seriesLabel = UILabel()
        seriesLabel.font = UIFont(name: "SFProDisplay-Bold", size: 16)
        seriesLabel.textColor = UIColor(named: "#111827 - #FFFFFF")
        seriesLabel.textAlignment = .left
        seriesLabel.text = "SECTIONS".localized()
        return seriesLabel
    }()
    
    var screenShotsLabel: UILabel = {
        var screenShotsLabel = UILabel()
        screenShotsLabel.font = UIFont(name: "SFProDisplay-Bold", size: 16)
        screenShotsLabel.textColor = UIColor(named: "#111827 - #FFFFFF")
        screenShotsLabel.textAlignment = .left
        screenShotsLabel.text = "SCREENSHOT".localized()
        return screenShotsLabel
    }()
    
    var similarMoviesLabel: UILabel = {
        var similarMoviesLabel = UILabel()
        similarMoviesLabel.text = "SIMILAR_SERIES".localized()
        similarMoviesLabel.font = UIFont(name: "SFProDisplay-Bold", size: 16)
        similarMoviesLabel.textColor = UIColor(named: "#111827 - #FFFFFF")
        similarMoviesLabel.textAlignment = .left
        return similarMoviesLabel
    }()
    
    var showSeasonsButton: UIButton = {
        var showSeasonsButton = UIButton()
        showSeasonsButton.setTitle("5 сезон, 46 серия", for: .normal)
        showSeasonsButton.setTitleColor(UIColor(named: "#9CA3AF"), for: .normal)
        showSeasonsButton.backgroundColor = UIColor.clear
        showSeasonsButton.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 12)
        showSeasonsButton.addTarget(self, action: #selector(showSeason), for: .touchUpInside)
        showSeasonsButton.layer.frame = CGRect(x: 0, y: 0, width: 100, height: 0)
        return showSeasonsButton
    }()
    
    var buttonArrowImage: UIImageView = {
        var buttonArrowImage = UIImageView()
        buttonArrowImage.image = UIImage(named: "arrow")
        return buttonArrowImage
    }()
    
    var showSimilar: UIButton = {
        var showSimilar = UIButton()
        showSimilar.backgroundColor = UIColor.clear
        showSimilar.setTitle("SHOW_ALL_MOVIES".localized(), for: .normal)
        showSimilar.setTitleColor(UIColor(named: "#B376F7"), for: .normal)
        showSimilar.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
        return showSimilar
    }()
    
    lazy var screenshotsCollectionView: UICollectionView = {
        var layout = TopAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.estimatedItemSize.height = 112
        layout.estimatedItemSize.width = 184
        layout.scrollDirection = .horizontal
        
        var screenshotsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        screenshotsCollectionView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        screenshotsCollectionView.delegate = self
        screenshotsCollectionView.dataSource = self
        screenshotsCollectionView.showsHorizontalScrollIndicator = false
        screenshotsCollectionView.showsVerticalScrollIndicator = false
        screenshotsCollectionView.register(ScreenshotCollectionViewCell.self, forCellWithReuseIdentifier: "screenshotsCell")
        return screenshotsCollectionView
    }()
    
    lazy var similarMoviesCollectionView: UICollectionView = {
        var layout = TopAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.estimatedItemSize.height = 220
        layout.estimatedItemSize.height = 112
        layout.scrollDirection = .horizontal
        
        var similarMovieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        similarMovieCollectionView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        similarMovieCollectionView.delegate = self
        similarMovieCollectionView.dataSource = self
        similarMovieCollectionView.showsHorizontalScrollIndicator = false
        similarMovieCollectionView.showsVerticalScrollIndicator = false
        similarMovieCollectionView.register(SimilarCollectionViewCell.self, forCellWithReuseIdentifier: "similarCell")
        return similarMovieCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        configureViews()
        downloadSimilarMovies()
        downloadScreenShots()
        setData()
    }
    
   
    
    //MARK: - CollectionVIew
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.similarMoviesCollectionView {
            return similarMovies.count
        }
        return movie.screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.similarMoviesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            let transformer = SDImageResizingTransformer(size: CGSize(width: 112, height: 164), scaleMode: .aspectFill)
            
            cell.imageView.sd_setImage(with: URL(string: similarMovies[indexPath.item].poster_link), placeholderImage: nil, context: [.imageTransformer: transformer])
            cell.titleLabel.text = similarMovies[indexPath.item].name
            
            if let genrename = similarMovies[indexPath.item].genres.first {
                cell.subtitleLabel.text = genrename.name
            } else {
                cell.subtitleLabel.text = ""
            }
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenshotsCell", for: indexPath) as! ScreenshotCollectionViewCell
        let transformer = SDImageResizingTransformer(size: CGSize(width: 184, height: 112), scaleMode: .aspectFill)
        cell.imageview.sd_setImage(with: URL(string: movie.screenshots[indexPath.item].link), placeholderImage: nil, context: [.imageTransformer: transformer])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let showVC = ScreenshotShowViewController()
        let transformer = SDImageResizingTransformer(size: CGSize(width: 184, height: 112), scaleMode: .aspectFill)
        showVC.imageview.sd_setImage(with: URL(string: screenshots[indexPath.row].link), placeholderImage: nil, context: [.imageTransformer: transformer])
        navigationController?.pushViewController(showVC, animated: true)
        
    }
    
}

// MARK: - Extension
extension DetailViewController {
    //    MARK: - setups
    func setupView() {
        view.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(posterImageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(backButton)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(favoriteLabel)
        contentView.addSubview(playButton)
        contentView.addSubview(shareButton)
        contentView.addSubview(shareLabel)
        contentView.addSubview(backgroundView)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(detailLabel)
        backgroundView.addSubview(topLineView)
        backgroundView.addSubview(descriptionLabel)
        backgroundView.addSubview(descriptionGradientView)
        backgroundView.addSubview(showFullDescription)
        backgroundView.addSubview(directorStackView)
        directorStackView.addArrangedSubview(directorLabel)
        directorStackView.addArrangedSubview(directorNameLabel)
        backgroundView.addSubview(producerStackView)
        producerStackView.addArrangedSubview(producerLabel)
        producerStackView.addArrangedSubview(producerNameLabel)
        backgroundView.addSubview(bottomLineView)
        backgroundView.addSubview(seriesLabel)
        backgroundView.addSubview(showSeasonsButton)
        backgroundView.addSubview(buttonArrowImage)
        backgroundView.addSubview(screenShotsLabel)
        backgroundView.addSubview(screenshotsCollectionView)
        backgroundView.addSubview(similarMoviesLabel)
        backgroundView.addSubview(showSimilar)
        backgroundView.addSubview(similarMoviesCollectionView)
    }
    
    func configureViews(){
        if movie.movieType == "MOVIE" {
            seriesLabel.isHidden = true
            showSeasonsButton.isHidden = true
            buttonArrowImage.isHidden = true
        } else {
            showSeasonsButton.setTitle("\(movie.seasonCount) сезон, \(movie.seriesCount) серия ", for: .normal)
        }
        if movie.favorite {
            favoriteButton.setImage(UIImage(named: "AddFavoriteButton"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "FavoriteButton2"), for: .normal)
        }
    }
    
    func setData(){
        posterImageView.sd_setImage(with: URL(string: movie.poster_link), completed: nil)
        titleLabel.text = movie.name
        detailLabel.text = "\(movie.year)"
        descriptionLabel.text = movie.description
        directorNameLabel.text = movie.director
        producerNameLabel.text = movie.producer
        
        for item in movie.genres {
            detailLabel.text = detailLabel.text! + " • " + item.name
        }
    }
    
    // MARK: - @objc funcs
    
    @objc func addToFavorite() {
        var method = HTTPMethod.post
        if movie.favorite {
            method = .delete
        }
        SVProgressHUD.show()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"]
        let parameters = ["movieId": movie.id] as [String: Any]
        AF.request(Urls.FAVORITE_URL, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData {
            response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print (resultString)
            }
            if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                self.movie.favorite.toggle()
                self.configureViews()
                
            } else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + "\(sCode)"
                }
                ErrorString = ErrorString + "\(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    
    @objc func playMovie() {
        if movie.movieType == "MOVIE" {
            let playerVC = MoviePlayerViewController()
            
            playerVC.video_link = movie.video_link
            
            navigationController?.show(playerVC, sender: self)
        } else {
            let seasonsVC = SeasonsSeriesViewController()
            seasonsVC.movie = movie
            navigationController?.show(seasonsVC, sender: self)
        }
        
    }
    
    @objc func shareMovie() {
        let text = "\(movie.name) \n\(movie.description)"
        let image = posterImageView.image
        let shareAll = [text,image!] as! [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController,animated: true, completion: nil)
    }
    
    @objc func showDescription() {
        if descriptionLabel.numberOfLines > 4 {
            descriptionLabel.numberOfLines = 4
            showFullDescription.setTitle("READ_MORE".localized(), for: .normal)
            descriptionGradientView.isHidden = false
        } else {
            descriptionLabel.numberOfLines = 30
            showFullDescription.setTitle("HIDE".localized(), for: .normal)
            descriptionGradientView.isHidden = true
        }
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func showSeason() {
        let seasonsViewController = SeasonsSeriesViewController()
        seasonsViewController.movie = movie
        navigationController?.show(seasonsViewController, sender: self)
    }
    
    // MARK: - DownnloadSimilarMovies
    func  downloadSimilarMovies() {
        
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(Urls.GET_SIMILAR + String(movie.id), method: .get, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    for item in array {
                        let movie = Movie(json: item)
                        self.similarMovies.append(movie)
                    }
                    self.similarMoviesCollectionView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
            } else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    
    // MARK: - DownnloadScreenShots
    func downloadScreenShots() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(Urls.GET_SCREENSHOTS + String(movie.id), method: .get, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    for item in array {
                        let screenshots = Screenshot(json: item)
                        self.screenshots.append(screenshots)
                    }
                    self.screenshotsCollectionView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
            } else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    // MARK: - SetupConstraints
    func setupConstraints(){
        
        scrollView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.top.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        posterImageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(340)
        }
        gradientView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(390)
        }
        playButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(192)
            make.height.width.equalTo(132)
        }
        favoriteButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(57)
            make.top.equalToSuperview().inset(224)
            make.height.width.equalTo(100)
        }
        favoriteLabel.snp.makeConstraints { make in
            make.centerX.equalTo(favoriteButton)
            make.top.equalTo(favoriteButton.snp.top).offset(adaptiveSize(for: 46))
        }
        shareButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(69)
            make.top.equalToSuperview().inset(224)
            make.height.width.equalTo(100)
        }
        shareLabel.snp.makeConstraints { make in
            make.centerX.equalTo(shareButton.snp.centerX)
            make.top.equalTo(shareButton.snp.top).inset(46)
        }
        backgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(posterImageView.snp.bottom).inset(32)
            make.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview().inset(24)
        }
        detailLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        topLineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(1)
            make.top.equalTo(detailLabel.snp.bottom).offset(adaptiveSize(for: 24))
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(topLineView.snp.bottom).offset(adaptiveSize(for: 24))
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
        }
        descriptionGradientView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.top)
            make.bottom.equalTo(showFullDescription.snp.top)
        }
        showFullDescription.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
        }
        directorStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(adaptiveSize(for: 24))
            make.top.equalTo(showFullDescription.snp.bottom).offset(adaptiveSize(for: 24))
        }
        producerStackView.snp.makeConstraints { make in
            make.top.equalTo(directorStackView.snp.bottom).offset(adaptiveSize(for: 8))
            make.left.equalToSuperview().inset(adaptiveSize(for: 24))
        }
        bottomLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
            make.top.equalTo(producerStackView.snp.bottom).offset(adaptiveSize(for: 24))
        }
        seriesLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(bottomLineView.snp.bottom).offset(24)
        }
        showSeasonsButton.snp.makeConstraints { make in
            make.top.equalTo(bottomLineView.snp.bottom).offset(28)
            make.left.equalTo(seriesLabel.snp.right).offset(123)
            make.centerY.equalTo(seriesLabel.snp.centerY)
        }
        buttonArrowImage.snp.makeConstraints { make in
            make.top.equalTo(bottomLineView.snp.bottom).offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(16)
            make.width.equalTo(16)
            make.left.equalTo(showSeasonsButton.snp.right).offset(8)
            make.centerY.equalTo(showSeasonsButton.snp.centerY)
        }
        screenShotsLabel.snp.makeConstraints { make in
            make.top.equalTo(seriesLabel.snp.bottom).offset(32)
            make.left.equalToSuperview().inset(25)
        }
        
        screenshotsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(screenShotsLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(112)
        }
        similarMoviesLabel.snp.makeConstraints { make in
            make.top.equalTo(screenshotsCollectionView.snp.bottom).inset(-32)
            make.left.equalToSuperview().inset(25)
            make.bottom.equalToSuperview()
        }
        similarMoviesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(similarMoviesLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(25)
        }
        showSimilar.snp.makeConstraints { make in
            make.centerY.equalTo(similarMoviesLabel)
            make.right.equalToSuperview().inset(24)
        }
        
    }
}
