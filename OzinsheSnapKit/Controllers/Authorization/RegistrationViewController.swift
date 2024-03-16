//
//  RegistrationViewController.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 24.02.2024.
//

import UIKit
import SnapKit
import Localize_Swift
import Alamofire
import SDWebImage
import SVProgressHUD
import SwiftyJSON

class RegistrationViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "CREATE_ACCOUNT_BUTTON".localized()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        label.textColor = UIColor(named: "#111827 - #FFFFFF")
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "FILL_IN_DETAILS".localized()
        label.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        label.textColor = UIColor(named: "#6B7280 - #9CA3AF")
        return label
    }()
    
    let emailTextField: TextFieldView = {
        let emailTextField = TextFieldView()
        emailTextField.titleLabel.text = "Email".localized()
        emailTextField.textField.placeholder = "YOUR_EMAIL".localized()
        emailTextField.textField.keyboardType = .emailAddress
        emailTextField.textField.textContentType = .emailAddress
        emailTextField.textField.iconImageView.image = UIImage(named: "EmailImage")
        return emailTextField
    }()
    
    let passwordTextField: TextFieldView = {
        var passwordTextField = TextFieldView()
        passwordTextField.titleLabel.text = "YOUR_PASSWORD".localized()
        passwordTextField.textField.placeholder = "YOUR_PASSWORD".localized()
        passwordTextField.textField.iconImageView.image = UIImage(named: "PasswordKey")
        passwordTextField.textField.textContentType = .password
        passwordTextField.textField.showButton.isHidden = false
        passwordTextField.textField.isSecureTextEntry = true
        return passwordTextField
    }()
    
    let confirmPasswordTextField: TextFieldView = {
        let confirmPasswordTextField = TextFieldView()
        confirmPasswordTextField.titleLabel.text = "REPEAT_PASSWORD".localized()
        confirmPasswordTextField.textField.placeholder = "YOUR_PASSWORD".localized()
        confirmPasswordTextField.textField.textContentType = .password
        confirmPasswordTextField.textField.iconImageView.image = UIImage(named: "PasswordKey")
        confirmPasswordTextField.textField.showButton.isHidden = false
        confirmPasswordTextField.textField.isSecureTextEntry = true
        return confirmPasswordTextField
    }()
    
    let registrationButton: UIButton = {
        let registrationButton = UIButton()
        registrationButton.setTitle("CREATE_ACCOUNT_BUTTON".localized(), for: .normal )
        registrationButton.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        registrationButton.layer.cornerRadius = 12
        registrationButton.backgroundColor = UIColor(named: "#7E2DFC")
        registrationButton.titleLabel?.textColor = UIColor(named: "#111827 - #FFFFFF")
        registrationButton.addTarget(self, action: #selector(registration), for: .touchUpInside)
        return registrationButton
    }()
    
   let stackView: UIStackView = {
       let stackView = UIStackView()
       let registerLabel = {
           let registerLabel = UILabel()
           registerLabel.text = "CREATE_ACCOUNT".localized()
           registerLabel.font = UIFont(name: "SFProDisplay-Regular", size: 14)
           registerLabel.textColor = UIColor(named: "#6B7280 - #9CA3AF")
           return registerLabel
       }
       
    let registerButton = {
           let registerButton = UIButton()
           registerButton.setTitle("SIGN_IN".localized(), for: .normal)
           registerButton.setTitleColor(UIColor(named: "#B376F7"), for: .normal)
           registerButton.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
           registerButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
           return registerButton
       }
       stackView.axis = .horizontal
       stackView.spacing = 4
       stackView.alignment = .center
       stackView.addArrangedSubview(registerLabel())
       stackView.addArrangedSubview(registerButton())
       return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(registrationButton)
        view.addSubview(stackView)
        setupConstraints()
    }

}

// MARK: - Extension, @objc func, setupConstraints
extension RegistrationViewController{
    
    @objc private func logIn() {
        let logInVC = LogInViewController()
        navigationController?.pushViewController(logInVC, animated: true)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func registration(){
        
        let email = emailTextField.textField.text!
        let password = passwordTextField.textField.text!
        let confirmPassword = confirmPasswordTextField.textField.text!
        
        if password != confirmPassword {
            confirmPasswordTextField.textField.font = UIFont(name: "SFProDisplay-Regular", size: 14)
            confirmPasswordTextField.error = "PASSWORDS_MISSMATCH!".localized()
            passwordTextField.textField.layer.borderColor = UIColor(named: "#FF402B")?.cgColor
            return
        }
        
        SVProgressHUD.show()
        let parameters = ["email": email,"password": password]
        AF.request(Urls.SIGN_UP_URL, method: .post, parameters: parameters,encoding: JSONEncoding.default).responseData{ response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data:data,encoding: .utf8)!
                print (resultString)
            }
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print ("JSON: \(json)")
                
                if let token = json["accessToken"].string {
                    Storage.sharedInstance.accessToken = token
                    UserDefaults.standard.set(token,forKey: "accessToken")
                    self.startApp()
                }
                else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
            } else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response .response?.statusCode {
                    ErrorString = ErrorString + "\(sCode)"
                }
                ErrorString = ErrorString + "\(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }

    private func setupConstraints() {
            titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            }
            subtitleLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(4)
                make.horizontalEdges.equalToSuperview().inset(24)
            }
            emailTextField.snp.makeConstraints { make in
                make.top.equalTo(subtitleLabel.snp.bottom).offset(29)
                make.horizontalEdges.equalToSuperview().inset(24)
            }
            passwordTextField.snp.makeConstraints { make in
                make.top.equalTo(emailTextField.snp.bottom).offset(13)
                make.horizontalEdges.equalToSuperview().inset(24)
            }
            confirmPasswordTextField.snp.makeConstraints { make in
                make.top.equalTo(passwordTextField.snp.bottom).offset(13)
                make.horizontalEdges.equalToSuperview().inset(24)
            }
            registrationButton.snp.makeConstraints { make in
                make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(40)
                make.horizontalEdges.equalToSuperview().inset(24)
                make.height.equalTo(56)
            }
            stackView.snp.makeConstraints { make in
                make.top.equalTo(registrationButton.snp.bottom).offset(24)
                make.centerX.equalToSuperview()
            }
        }
    }
