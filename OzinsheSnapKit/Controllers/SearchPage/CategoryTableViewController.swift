//
//  CategoryTableViewController.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 02.03.2024.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Alamofire
import SnapKit
import Localize_Swift

class CategoryTableViewController: UITableViewController {
    var categoryAgeID = 0
    var categoryID = 0
    var genreID = 0
    var genreName = ""
    var categoryName = ""
    var movies:[Movie] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        self.title = categoryName
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        downlaodMoviesByCategory()
        downlaodMoviesByGenre()
        downlaodMoviesByAges()
        self.tabBarController?.tabBar.isHidden = true
        navigationItem.title = categoryName
    }
    
    // MARK: - tableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        
        cell.setData(movie: movies[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        153
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieinfoVC = DetailViewController()
        movieinfoVC.movie  = movies[indexPath.row]
        navigationController?.pushViewController(movieinfoVC, animated: true)
    }
}

// MARK: - Extension
extension CategoryTableViewController {
    
    //MARK: - downloadMoviesByCategory
    func downlaodMoviesByCategory(){
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        let parameters = ["categoryId": categoryID]
        
        AF.request(Urls.MOVIES_BY_CATEGORY_URL, method: .get, parameters: parameters, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if json["content"].exists(){
                    if let array = json["content"].array{
                        for item in array{
                            let movie = Movie(json: item)
                            self.movies.append(movie)
                        }
                        self.tableView.reloadData()
                    }
                }else{
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
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
    
    //MARK: - downloadMoviesByGenre
    func downlaodMoviesByGenre(){
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        let parameters = ["genreId": genreID, "name": genreName] as [String : Any]
        
        AF.request(Urls.MOVIES_BY_CATEGORY_URL, method: .get, parameters: parameters, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if json["content"].exists(){
                    if let array = json["content"].array{
                        for item in array{
                            let movie = Movie(json: item)
                            self.movies.append(movie)
                        }
                        self.tableView.reloadData()
                    }
                }else{
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
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
    //MARK: - downloadMoviesByAges
    func downlaodMoviesByAges(){
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        let parameters = ["categoryAgeId": categoryAgeID]
        
        AF.request(Urls.MOVIES_BY_CATEGORY_URL, method: .get, parameters: parameters, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if json["content"].exists(){
                    if let array = json["content"].array{
                        for item in array{
                            let movie = Movie(json: item)
                            self.movies.append(movie)
                        }
                        self.tableView.reloadData()
                    }
                }else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
                
                
            }else {
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
