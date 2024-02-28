//
//  LogInViewController.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 21.02.2024.
//

import UIKit
import SnapKit
import Alamofire
import SDWebImage
import SwiftyJSON
import Localize_Swift
import SVProgressHUD

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    
    let titleLabel: UILabel = {
        var titleLabel = UILabel()
        
        titleLabel.text = "ENTRY_HELLO_LABEL".localized()
        titleLabel.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        titleLabel.textColor = UIColor(named: "#111827 - #FFFFFF")
        
        return titleLabel
    }()
    
    let subTitleLabel: UILabel = {
        var subTitleLabel = UILabel()
        
        subTitleLabel.text = "ENTER_YOUR_ACCOUNT".localized()
        subTitleLabel.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        subTitleLabel.textColor = UIColor(named: "#6B7280 - #9CA3AF")
        
        return subTitleLabel
        
    }()
    
    lazy var formStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 16
        
        
        return stackView
    }()
    
    let emailTextField: TextFieldView = {
        var emailTextField = TextFieldView()
        emailTextField.titleLabel.text = "Email".localized()
        emailTextField.textField.placeholder = "YOUR_EMAIL".localized()
        emailTextField.textField.keyboardType = .emailAddress
        emailTextField.textField.textContentType = .emailAddress
        emailTextField.textField.iconImageView.image = UIImage(named: "EmailImage")
        emailTextField.textField.autocapitalizationType = .none
        
        return emailTextField
    }()
    
    let passwordTextField: TextFieldView = {
        var passwordTextField = TextFieldView()
        passwordTextField.titleLabel.text = "PASSWORD".localized()
        passwordTextField.textField.placeholder = "YOUR_PASSWORD".localized()
        passwordTextField.textField.iconImageView.image = UIImage(named: "PasswordKey")
        passwordTextField.textField.textContentType = .password
        passwordTextField.textField.showButton.isHidden = false
        passwordTextField.textField.isSecureTextEntry = true
        passwordTextField.textField.autocapitalizationType = .none
        
        return passwordTextField
    }()
    
    let forgotPasswordButton: UIButton = {
        var forgotPasswordButton = UIButton()
        
        forgotPasswordButton.setTitle("FORGOT_PASSWORD".localized(), for: .normal)
        forgotPasswordButton.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
        forgotPasswordButton.setTitleColor(UIColor(named: "#B376F7"), for: .normal)
        forgotPasswordButton.contentHorizontalAlignment = .trailing
        
        return forgotPasswordButton
    }()
    
    let loginButton: UIButton = {
        var loginButton = UIButton()
        
        loginButton.setTitle("SIGN_IN".localized(), for: .normal )
        loginButton.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        loginButton.layer.cornerRadius = 12
        loginButton.backgroundColor = UIColor(named: "#7E2DFC")
        loginButton.tintColor = .white
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        return loginButton
    }()
    let registerView: UIStackView = {
        let registerView = UIStackView()
        registerView.axis = .horizontal
        registerView.spacing = 4
        registerView.alignment = .center
        
        
        return registerView
    }()
    
    
    let registerLabel = {
        let registerLabel = UILabel()
        registerLabel.text = "CREATE_ACCOUNT".localized()
        registerLabel.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        registerLabel.textColor = UIColor(named: "#6B7280 - #9CA3AF")
        
        return registerLabel
    }()
    
    let registerButton = {
        let registerButton = UIButton()
        registerButton.setTitle("CREATE_ACCOUNT_BUTTON".localized(), for: .normal)
        registerButton.setTitleColor(UIColor(named: "#B376F7"), for: .normal)
        registerButton.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
        registerButton.addTarget(self, action: #selector(registration), for: .touchUpInside)
        
        return registerButton
    }()
    let label: UILabel = {
        var label = UILabel()
        label.text = "ELSE".localized()
        label.textColor = UIColor(named: "#9CA3AF")
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
        label.textAlignment = .center
        
        return label
    }()
    let button:UIButton = {
        var button = UIButton()
        button.setTitle("ENTER_WITH_APPLE".localized(), for: .normal)
        button.setTitleColor(UIColor(named: "#111827 - #FFFFFF"), for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
        button.backgroundColor = UIColor(named: "#FFFFFF - #4B5563")
        button.layer.borderColor = UIColor(named: "#E5EBF0 - #374151")?.cgColor
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1.0
        button.titleLabel?.textAlignment = .center
        return button
    }()
    let appleIconView:UIImageView = {
        var appleIcon = UIImageView()
        appleIcon.image = UIImage(named: "AppleLogo")
        return appleIcon
    }()
    
    let googleButton: UIButton = {
        var googleButton = UIButton()
        googleButton.setTitle("ENTER_WITH_GOOGLE".localized(), for: .normal)
        googleButton.setTitleColor(UIColor(named: "#111827 - #FFFFFF"), for: .normal)
        googleButton.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
        googleButton.backgroundColor = UIColor(named: "#FFFFFF - #4B5563")
        googleButton.layer.borderColor = UIColor(named: "#E5EBF0 - #374151")?.cgColor
        googleButton.layer.cornerRadius = 12
        googleButton.layer.borderWidth = 1.0
        googleButton.titleLabel?.textAlignment = .center
        
        return googleButton
    }()
    let googleImageView: UIImageView = {
        var googleImageVIew = UIImageView()
        googleImageVIew.image = UIImage(named: "GoogleLogo")
        return googleImageVIew
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(formStackView)
        formStackView.addArrangedSubview(emailTextField)
        formStackView.addArrangedSubview(passwordTextField)
        formStackView.addArrangedSubview(forgotPasswordButton)
        view.addSubview(loginButton)
        view.addSubview(registerView)
        registerView.addArrangedSubview(registerLabel)
        registerView.addArrangedSubview(registerButton)
        view.addSubview(label)
        view.addSubview(button)
        view.addSubview(appleIconView)
        view.addSubview(googleButton)
        view.addSubview(googleImageView)
        
        setupConstraints()
        
    }
    
        @objc func login() {
            let email = emailTextField.textField.text!
            let password = passwordTextField.textField.text!
            
            guard let email = emailTextField.textField.text,
                  !email.isEmpty else {
                emailTextField.error = "Қате формат"
                return
            }
            
            guard let password = passwordTextField.textField.text,
                  !password.isEmpty else {
                passwordTextField.error = "Қате формат"
                return
            }
            
            
            SVProgressHUD.show()
            
            
            let parameters = ["email": email,"password": password]
            AF.request(Urls.SIGN_IN_URL, method: .post, parameters: parameters,encoding: JSONEncoding.default).responseData{ [self] response in
                
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
                        UserDefaults.standard.set(email, forKey: "email")
                        startApp(self)
                        
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
    
    func startApp(_ viewController: UIViewController){
        let tabBarVC = TabBarController()
        tabBarVC.modalPresentationStyle = .fullScreen
        viewController.present(tabBarVC, animated: true)
    }
    
    @objc func registration() {
        let registrationVC = RegistrationViewController()
        navigationController?.pushViewController(registrationVC, animated: true)
    }
    
    
    
    
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.left.equalTo(view.safeAreaLayoutGuide).inset(24)
            
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(24)
            
        }
        formStackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(adaptiveSize(for: 32))
            make.horizontalEdges.equalToSuperview().inset(24)
            
        }
        //        emailTextField.snp.makeConstraints { make in
        //            make.top.equalTo(subTitleLabel.snp.bottom).offset(29)
        //            make.horizontalEdges.equalToSuperview().inset(24)
        //        }
        //        passwordTextField.snp.makeConstraints { make in
        //            make.top.equalTo(emailTextField.snp.bottom).offset(13)
        //            make.horizontalEdges.equalToSuperview().inset(24)
        //        }
        //
        //         forgotPasswordButton.snp.makeConstraints { make in
        //            make.right.equalToSuperview().inset(24)
        //            make.top.equalTo(formStackView.snp.bottom).offset(17)
        //        }
        //
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(formStackView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        registerView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(registerView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(24)
            
        }
        button.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.height.equalTo(56)
            make.horizontalEdges.equalToSuperview().inset(24)
            
        }
        appleIconView.snp.makeConstraints { make in
            make.left.equalTo(button).inset(69.5)
            make.centerY.equalTo(button)
            make.size.equalTo(16)
        }
        googleButton.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
            //            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(27)
        }
        googleImageView.snp.makeConstraints { make in
            make.left.equalTo(googleButton).inset(74)
            make.centerY.equalTo(googleButton)
            make.size.equalTo(16)
            //            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(27)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
