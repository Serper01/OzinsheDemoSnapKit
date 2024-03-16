//
//  SearchViewController.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 23.02.2024.
//

import UIKit
import SnapKit
import Alamofire
import SDWebImage
import SwiftyJSON
import SVProgressHUD
import Localize_Swift

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        return attributes
    }
}

class SearchViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource{
    
    var categories: [Category] = []
    var movies: [Movie] = []
    
    var searchTextField: UITextField = {
        var searchTextField = UITextField()
        searchTextField.textColor = UIColor(named: "#111827 - #FFFFFF")
        searchTextField.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        searchTextField.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        searchTextField.layer.borderColor = UIColor(named: "#E5EBF0- #1C2431")?.cgColor
        searchTextField.layer.cornerRadius = 12
        searchTextField.layer.borderWidth = 1
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: searchTextField.frame.height))
        searchTextField.leftViewMode = .always
        searchTextField.addTarget(self, action: #selector(didBegin), for: .editingDidBegin)
        searchTextField.addTarget(self, action: #selector(didEnd), for: .editingDidEnd)
        searchTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        return searchTextField
    }()
    
    var searchButton: UIButton = {
        var searchButton = UIButton()
        searchButton.backgroundColor = UIColor(named: "#F3F4F6 - #374151")
        searchButton.layer.cornerRadius = 12
        searchButton.setImage(UIImage(named:"SearchButton"), for: .normal)
        searchButton.frame.size = CGSize(width: 56, height: 56)
        searchButton.addTarget(self, action: #selector(startSearch), for: .touchUpInside)
        return searchButton
    }()
    
    var cancelSearchButton: UIButton = {
        var cancelSearchButton = UIButton()
        cancelSearchButton.setImage(UIImage(named: "ClearButton"), for: .normal)
        cancelSearchButton.addTarget(self, action: #selector(cancelSearch), for: .touchUpInside)
        return cancelSearchButton
    }()
    
    var stackViewForSearch: UIStackView = {
        var stackview = UIStackView()
         stackview.axis = .horizontal
         stackview.spacing = 16
         return stackview
     }()
    
    var topLabel: UILabel = {
        var topLabel = UILabel()
        topLabel.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        topLabel.textColor = UIColor(named: "#111827 - #FFFFFF")
        return topLabel
    }()
    
    lazy var collectionView: UICollectionView = {
        var layout = LeftAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 24.0, bottom: 16.0, right: 24.0)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize.width = 120
        layout.estimatedItemSize.height = 34
        layout.scrollDirection = .vertical
        
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        tableView.isUserInteractionEnabled = true
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        view.addSubview(stackViewForSearch)
        stackViewForSearch.addArrangedSubview(searchTextField)
        stackViewForSearch.addArrangedSubview(searchButton)
        view.addSubview(cancelSearchButton)
        view.addSubview(topLabel)
        view.addSubview(collectionView)
        view.addSubview(tableView)
        cancelSearchButton.isHidden = true
        setupConstraints()
        downloadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        configureLanguages()
    }

    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.layer.cornerRadius = 8.0
        let categoryLabel = UILabel()
        categoryLabel.text = categories[indexPath.row].name
        categoryLabel.font = UIFont(name: "SFProDisplay-Bold", size: 12)
        cell.contentMode = .scaleAspectFit
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.backgroundColor = UIColor(named: "#F3F4F6 - #374151")
        cell.contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 16))
            make.centerY.equalToSuperview()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let categoryTableViewController =  CategoryTableViewController()
        categoryTableViewController.categoryID = categories[indexPath.row].id
        categoryTableViewController.navigationItem.title = categories[indexPath.row].name
        navigationController?.show(categoryTableViewController, sender: self)
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        
        cell.setData(movie: movies[indexPath.row])
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
          return 1
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let movieinfoVC = DetailViewController()
          movieinfoVC.movie  = movies[indexPath.row]
        navigationController?.show(movieinfoVC, sender: self)
        
      }
}
//MARK: - Extension
    extension SearchViewController {
    
    // MARK: - @objc funcs
    @objc func cancelSearch(){
        searchTextField.text = ""
        downloadSearchMovies()
    }
    
    @objc func startSearch(){
        downloadSearchMovies()
    }
    
    @objc func didBegin(){
           searchTextField.layer.borderColor = UIColor(named: "#9753F0")?.cgColor
           searchButton.setImage(UIImage(named: "SelectedSearch2"), for: .normal)
        if searchTextField.state.isEmpty{
            cancelSearchButton.isHidden = true
        }
        else{
            cancelSearchButton.isHidden = false
        }
           
       }
       @objc func didEnd(){
           searchTextField.layer.borderColor = UIColor(named: "#E5EBF0 - #374151")?.cgColor
           searchButton.setImage(UIImage(named: "searchButton"), for: .normal)
       }
       @objc func textFieldEditingChanged() {
           downloadSearchMovies()
       }
        
    // MARK: - Configure Languages, downoladSearchMovies
    func configureLanguages(){
        searchTextField.placeholder = "SEARCH".localized()
        topLabel.text = "CATEGORIES".localized()
        navigationItem.title = "SEARCH".localized()
    }
    func downloadSearchMovies(){
        
        if searchTextField.text!.isEmpty{
            topLabel.text = "CATEGORIES".localized()
            collectionView.isHidden = false
            tableView.snp.remakeConstraints { make in
                make.top.equalTo(collectionView.snp.bottom)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
            tableView.isHidden = true
            movies.removeAll()
            tableView.reloadData()
            cancelSearchButton.isHidden = true
            return
        }else{
            topLabel.text = "SEARCHING_RESULTS".localized()
            collectionView.isHidden = true
            tableView.snp.remakeConstraints { make in
                make.top.equalTo(topLabel.snp.bottom).offset(10)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
            tableView.isHidden = false
            cancelSearchButton.isHidden = false
        }
        
        SVProgressHUD.show()
        
        let parameters = ["search": searchTextField.text!]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        AF.request(Urls.SEARCH_MOVIES_URL, method: .get,parameters: parameters, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array{
                    self.movies.removeAll()
                    self.tableView.reloadData()
                    for item in array{
                        let movie = Movie(json: item)
                        self.movies.append(movie)
                    }
                    self.tableView.reloadData()
                }else{
                    var ErrorString = "CONNECTION_ERROR".localized()
                    if let sCode = response.response?.statusCode{
                        ErrorString = ErrorString + "\(sCode)"
                    }
                    ErrorString = ErrorString + "\(resultString)"
                    SVProgressHUD.showError(withStatus: "\(ErrorString)")
                }
            }
        }
        
    }
        
    // MARK: - downloadCategories, SetupConstraints
    func downloadCategories(){
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        AF.request(Urls.CATEGORIES_URL, method: .get, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array{
                    for item in array{
                        let category = Category(json: item)
                        self.categories.append(category)
                    }
                    self.collectionView.reloadData()
                }else{
                    var ErrorString = "CONNECTION_ERROR".localized()
                    if let sCode = response.response?.statusCode{
                        ErrorString = ErrorString + "\(sCode)"
                    }
                    ErrorString = ErrorString + "\(resultString)"
                    SVProgressHUD.showError(withStatus: "\(ErrorString)")
                }
            }
        }
    }
    
    func setupConstraints(){
        
        stackViewForSearch.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
            make.top.equalTo(view.safeAreaLayoutGuide).inset(adaptiveSize(for: 24))
        }
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(stackViewForSearch.snp.bottom).offset(adaptiveSize(for: 35))
            make.left.equalToSuperview().inset(adaptiveSize(for: 24))
        }
        cancelSearchButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchTextField)
            make.width.height.equalTo(56)
            make.right.equalTo(searchTextField.snp.right)
        }
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(adaptiveHeight(for: 400))
            make.top.equalTo(topLabel.snp.bottom)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
}


