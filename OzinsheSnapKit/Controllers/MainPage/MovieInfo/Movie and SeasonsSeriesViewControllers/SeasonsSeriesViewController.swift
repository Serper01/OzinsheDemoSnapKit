//
//  SeasonsSeriesViewController.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 03.03.2024.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class SeasonsSeriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource{
    
    var movie = Movie()
    var seasons: [Season] = []
    var currentSeason = 0
    
    // MARK: - UI Elements
  lazy  var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.sectionInset.left = 24
        layout.sectionInset.right = 24
        layout.sectionInset.top = 24
        layout.sectionInset.bottom = 8
        layout.estimatedItemSize.width = 76
        layout.estimatedItemSize.height = 34
        layout.scrollDirection = .horizontal
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.layer.cornerRadius = 8
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
   lazy var tableView: UITableView = {
       var tableView = UITableView()
       tableView.backgroundColor = UIColor(named: " #FFFFFF - #121827" )
       tableView.delegate = self
       tableView.dataSource = self
       tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        view.addSubview(collectionView)
        view.addSubview(tableView)
        setupConstraints()
        downloadSeasons()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - collectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seasons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.contentView.layer.cornerRadius = 8
        cell.contentMode = .scaleAspectFit
           let label = UILabel()
               label.text = "\(seasons[indexPath.row].number) сезон"
               label.font = UIFont(name: "SFProDisplay-Bold", size: 12)
        cell.contentView.addSubview(label)
        
               label.snp.makeConstraints { make in
                  make.centerY.equalToSuperview()
                  make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 16))
               }
        if currentSeason == seasons[indexPath.row].number - 1 {
            label.textColor = UIColor(named: "#F9FAFB")
            cell.contentView.backgroundColor = UIColor(named: "#9753F0")
        } else {
            label.textColor = UIColor(named: "#374151 - #F9FAFB")
            cell.contentView.backgroundColor = UIColor(named: "#F3F4F6 - #374151")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        currentSeason = seasons[indexPath.row].number - 1
        tableView.reloadData()
        collectionView.reloadData()
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if seasons.isEmpty {
            return 0
        }
        return seasons[currentSeason].videos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.contentView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        label.textColor = UIColor(named: "#111827 - #FFFFFF")
        label.text = "\(seasons[currentSeason].videos[indexPath.row].number)-ші бөлім"
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.sd_setImage(with: URL(string: "https://img.youtube.com/vi/\(seasons[currentSeason].videos[indexPath.row].link)/hqdefault.jpg"), completed: nil)
        
        cell.contentView.addSubview(imageView)
        cell.contentView.addSubview(label)
        
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
            make.top.equalToSuperview().inset(adaptiveSize(for: 16))
            make.height.equalTo(178)
        }
        label.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
            make.top.equalTo(imageView.snp.bottom).inset(adaptiveSize(for: -8))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let playerVC = MoviePlayerViewController()
        
        playerVC.video_link = seasons[currentSeason].videos[indexPath.row].link
        navigationController?.pushViewController(playerVC, animated: true)
    }
}

// MARK: - Extension
extension SeasonsSeriesViewController {
    func setupConstraints(){
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(74)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func downloadSeasons() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(Urls.GET_SEASONS + String(movie.id), method: .get, headers: headers).responseData { response in
            
            print("\(String(describing: response.request))")  // original URL request
            print("\(String(describing: response.request?.allHTTPHeaderFields))")  // all HTTP Header Fields
            print("\(String(describing: response.response))") // HTTP URL response
            print("\(String(describing: response.data))")     // server data
            print("\(response.result)")   // result of response serialization
            print("\(String(describing: response.value))")   // result of response serialization
            
            
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
                        let season = Season(json: item)
                        self.seasons.append(season)
                    }
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
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
}
