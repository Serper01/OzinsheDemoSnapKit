//
//  ChangePasswordViewController.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 12.03.2024.
//

import UIKit
import Localize_Swift
import SnapKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class ChangePasswordViewController: UIViewController {
    
    // MARK: - UI Elements
    var passwordTextField: TextFieldView = {
       var passwordTextField = TextFieldView()
        passwordTextField.titleLabel.text = "PASSWORD".localized()
        passwordTextField.textField.placeholder = "YOUR_PASSWORD".localized()
        passwordTextField.textField.textContentType = .password
        passwordTextField.textField.isSecureTextEntry = true
        passwordTextField.textField.iconImageView.image = UIImage(named: "PasswordKey")
        passwordTextField.textField.autocapitalizationType = .none
        return passwordTextField
    }()
    
    var repeatPasswordTextField: TextFieldView = {
       var repeatPasswordTextField = TextFieldView()
        repeatPasswordTextField.titleLabel.text = "REPEAT_PASSWORD".localized()
        repeatPasswordTextField.textField.placeholder = "YOUR_PASSWORD".localized()
        repeatPasswordTextField.textField.textContentType = .password
        repeatPasswordTextField.textField.isSecureTextEntry = true
        repeatPasswordTextField.textField.iconImageView.image = UIImage(named: "PasswordKey")
        repeatPasswordTextField.textField.autocapitalizationType = .none
        return repeatPasswordTextField
    }()
    
    var saveButton: UIButton = {
       var saveButton = UIButton()
        saveButton.setTitle("SAVE_CHANGES".localized(), for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "SFProDisplay-Bold", size: 16)
        saveButton.layer.cornerRadius = 12
        saveButton.backgroundColor = UIColor(named: "#7E2DFC")
        saveButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        return saveButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

}

// MARK: - Extension, setupViews(), setupConstraints()
    extension ChangePasswordViewController {
    
    @objc func saveChanges() {
        let password = passwordTextField.textField.text!
        let confirmPassword = repeatPasswordTextField.textField.text!
        
        if password != confirmPassword {
            repeatPasswordTextField.error = "PASSWORDS_MISSMATCH!".localized()
            passwordTextField.textField.layer.borderColor = UIColor(named: "#FF402B")?.cgColor
            return
        }
        SVProgressHUD.show()
        
        let parameters = ["password": password]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]

        AF.request(Urls.CHANGE_PASSWORD_URL, method: .put, parameters: parameters,encoding: JSONEncoding.default, headers: headers).responseData { response in

            SVProgressHUD.dismiss()
            
            var resultString = ""
            
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200{
                let json = JSON(response.data!)
                print("JSON: \(json)")

                if let token = json["accessToken"].string{
                    Storage.sharedInstance.accessToken = token
                    self.startApp()
                    
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
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupView(){
        view.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        navigationItem.title = "CHANGE_PASSWORD".localized()
        view.addSubview(passwordTextField)
        view.addSubview(repeatPasswordTextField)
        view.addSubview(saveButton)
    }
    
    func setupConstraints() {
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(adaptiveSize(for: 21))
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
        }
        repeatPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(adaptiveSize(for: 21))
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
        }
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(adaptiveSize(for: 15))
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
            make.height.equalTo(adaptiveHeight(for: 56))
        }
    }
}
