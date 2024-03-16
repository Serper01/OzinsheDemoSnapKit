//
//  PersonalDataViewController.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 12.03.2024.
//

import Localize_Swift
import Alamofire
import SwiftyJSON
import SVProgressHUD

class PersonalInfoViewController: UIViewController {
    
    // MARK: - UI Elements
    var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "YOUR_NAME".localized()
        nameLabel.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        nameLabel.textColor = UIColor(named: "#9CA3AF")
        return nameLabel
    }()
    
    var nameTextfield: UITextField = {
        var textfield = UITextField()
        textfield.borderStyle = .none
        textfield.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        return textfield
    }()
    
    var nameTextFieldLineView: UIView = {
        var nameTextFieldLineView = UIView()
        nameTextFieldLineView.backgroundColor = UIColor(named: "#D1D5DB - #1C2431")
        return nameTextFieldLineView
    }()
    
    var emailLabel: UILabel = {
        let emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        emailLabel.textColor = UIColor(named: "#9CA3AF")
        return emailLabel
    }()
    
    var emailTextField: UITextField = {
        var emailTextField = UITextField()
        emailTextField.borderStyle = .none
        emailTextField.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        return emailTextField
    }()
    
    var emailTextFieldLineView: UIView = {
        var emailTextFieldLineView = UIView()
        emailTextFieldLineView.backgroundColor = UIColor(named: "#D1D5DB - #1C2431")
        return emailTextFieldLineView
    }()
    
    var numberLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.text = "YOUR_PHONE_NUMBER".localized()
        numberLabel.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        numberLabel.textColor = UIColor(named: "#9CA3AF")
        return numberLabel
    }()
    
    var numberTextfield: UITextField = {
        var numberTextfield = UITextField()
        numberTextfield.borderStyle = .none
        numberTextfield.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        return numberTextfield
    }()
    
    var numberTextFieldLineView: UIView = {
        var numberTextFieldLineView = UIView()
        numberTextFieldLineView.backgroundColor = UIColor(named: "#D1D5DB - #1C2431")
        return numberTextFieldLineView
    }()
    
    var birthdayLabel: UILabel = {
        let birthdayLabel = UILabel()
        birthdayLabel.text = "BIRTH_DATE".localized()
        birthdayLabel.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        birthdayLabel.textColor = UIColor(named: "#9CA3AF")
        return birthdayLabel
    }()
    
    var birthdateTextfield: UITextField = {
        var birthdateTextfield = UITextField()
        birthdateTextfield.borderStyle = .none
        birthdateTextfield.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        return birthdateTextfield
    }()
    
    var birthdayLineView: UIView = {
        var birthdayLineView = UIView()
        birthdayLineView.backgroundColor = UIColor(named: "#D1D5DB - #1C2431")
        return birthdayLineView
    }()
    
    var saveChangesButton: UIButton = {
       var saveChangesButton = UIButton()
        saveChangesButton.setTitle("SAVE_CHANGES".localized(), for: .normal)
        saveChangesButton.titleLabel?.font = UIFont(name: "SFProDisplay-Bold", size: 16)
        saveChangesButton.backgroundColor = UIColor(named: "#7E2DFC")
        saveChangesButton.layer.cornerRadius = 12
        saveChangesButton.addTarget(self, action: #selector(saveInfo), for: .touchUpInside)
        return saveChangesButton
    }()
    
    lazy var datePiker: UIDatePicker = {
         let datePiker = UIDatePicker()
         datePiker.datePickerMode = .date
         datePiker.locale = .autoupdatingCurrent
         datePiker.preferredDatePickerStyle = .wheels
         datePiker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
         return datePiker
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        getInfo()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
}
 
// MARK: - Extension

    extension PersonalInfoViewController {
    
    @objc func datePickerChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        self.birthdateTextfield.text = dateFormatter.string(from: datePiker.date)
    }
    
    @objc func doneButtonAction() {
        birthdateTextfield.resignFirstResponder()
    }
    
    @objc func saveInfo() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let birthdate = dateFormatter.string(from: datePiker.date)
        
        let phoneNumber = numberTextfield.text ?? ""
        let name = nameTextfield.text ?? ""
        
        
        let parameters = ["name": name, "phoneNumber": phoneNumber, "birthDate": birthdate]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(Urls.PROFILE_UPDATE_URL, method: .put, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                self.nameTextfield.text = json["name"].string
                self.emailTextField.text = json["user"]["email"].string
                self.numberTextfield.text = json["phoneNumber"].string
                
            }else{
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode{
                    ErrorString = ErrorString + "\(sCode)"
                }
                ErrorString = ErrorString + "\(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
            
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func getInfo() {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(Urls.PROFILE_GET_URL, method: .get, encoding: JSONEncoding.default, headers: headers).responseData { response in
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let birthDate = json["birthDate"].string {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let date = dateFormatter.date(from: birthDate){
                        self.datePiker.date = date
                        dateFormatter.dateFormat = "dd MMM yyyy"
                        self.birthdateTextfield.text = dateFormatter.string(from: date)
                    }
                }
                self.nameTextfield.text = json["name"].string
                self.emailTextField.text = json["user"]["email"].string
                self.numberTextfield.text = json["phoneNumber"].string
                
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
    
    func setupView() {
        view.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        navigationItem.title = "PERSONAL_DATA".localized()
        view.addSubview(nameLabel)
        view.addSubview(nameTextfield)
        view.addSubview(nameTextFieldLineView)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailTextFieldLineView)
        view.addSubview(numberLabel)
        view.addSubview(numberTextfield)
        view.addSubview(numberTextFieldLineView)
        view.addSubview(birthdayLabel)
        view.addSubview(birthdateTextfield)
        view.addSubview(birthdayLineView)
        view.addSubview(saveChangesButton)
        birthdateTextfield.inputView = datePiker
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonAction))
        doneToolbar.items = [flexSpace, doneButton]
        
        birthdateTextfield.inputAccessoryView = doneToolbar
    }
    
    func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(adaptiveSize(for: 132))
            make.left.equalToSuperview().inset(adaptiveSize(for: 24))
        }
        nameTextfield.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
            make.height.equalTo(43)
            make.top.equalTo(nameLabel.snp.bottom)
        }
        nameTextFieldLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
            make.top.equalTo(nameTextfield.snp.bottom).inset(-2)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextFieldLineView.snp.bottom).offset(adaptiveSize(for: 24))
            make.left.equalToSuperview().inset(adaptiveSize(for: 24))
        }
        emailTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
            make.height.equalTo(43)
            make.top.equalTo(emailLabel.snp.bottom)
        }
        emailTextFieldLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
            make.top.equalTo(emailTextField.snp.bottom).inset(-2)
        }
        numberLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextFieldLineView.snp.bottom).offset(adaptiveSize(for: 24))
            make.left.equalToSuperview().inset(adaptiveSize(for: 24))
        }
        numberTextfield.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
            make.height.equalTo(43)
            make.top.equalTo(numberLabel.snp.bottom)
        }
        numberTextFieldLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
            make.top.equalTo(numberTextfield.snp.bottom).offset(2)
        }
        birthdayLabel.snp.makeConstraints { make in
            make.top.equalTo(numberTextFieldLineView.snp.bottom).offset(adaptiveSize(for: 24))
            make.left.equalToSuperview().inset(adaptiveSize(for: 24))
        }
        birthdateTextfield.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
            make.height.equalTo(43)
            make.top.equalTo(birthdayLabel.snp.bottom)
        }
        birthdayLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
            make.top.equalTo(birthdateTextfield.snp.bottom).offset(2)
        }
        saveChangesButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
            make.height.equalTo(adaptiveSize(for: 56))
        }
    }
}
