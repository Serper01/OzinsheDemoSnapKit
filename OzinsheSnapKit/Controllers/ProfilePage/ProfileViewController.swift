//
//  ProfileViewController.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 23.02.2024.
//

import UIKit
import SnapKit
import Localize_Swift

class ProfileViewController: UIViewController, LanguageProtocol {
    
    //MARK: - UI Elements
    var avatarImageView: UIImageView = {
        var avatarImageView = UIImageView()
        avatarImageView.image = UIImage(named: "Avatar")
        avatarImageView.contentMode = .scaleAspectFill
        return avatarImageView
    }()
    
    var profileLabel: UILabel = {
        var profileLabel = UILabel()
        profileLabel.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        profileLabel.textColor = UIColor(named: "#111827 - #FFFFFF")
        profileLabel.textAlignment = .center
        return profileLabel
    }()
    
    var emailLabel: UILabel = {
        var emailLabel = UILabel()
        emailLabel.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        emailLabel.textColor = UIColor(named: "#9CA3AF")
        return emailLabel
    }()
    
    var buttonsView: UIView = {
        var buttonsView = UIView()
        buttonsView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        return buttonsView
    }()
    
    var personalDataButton: UIButton = {
        var personalDataButton = UIButton()
        personalDataButton.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        personalDataButton.contentHorizontalAlignment = .left
        personalDataButton.setTitleColor(UIColor (named: "#111827 - #FFFFFF"), for: .normal)
        personalDataButton.addTarget(self, action: #selector(changePersonalData), for: .touchUpInside)
        return personalDataButton
    }()
    
    var personalDataLabel: UILabel = {
        var personalDataLabel = UILabel()
        personalDataLabel.font = UIFont(name: "SFProDisplay-Semibold", size: 12)
        personalDataLabel.text = "CHANGE".localized()
        personalDataLabel.textColor = UIColor(named: "#9CA3AF")
        return personalDataLabel
    }()
    
    var arrowImage: UIImageView = {
        var arrowImage = UIImageView()
        arrowImage.image = UIImage(named: "arrow")
        arrowImage.contentMode = .scaleAspectFill
        return arrowImage
    }()
    
    var personalDataLineView: UIView = {
        var personalDataLineView = UIView()
        personalDataLineView.backgroundColor = UIColor(named: "#D1D5DB - #1C2431")
        return personalDataLineView
    }()
    
    var changePasswordButton: UIButton = {
        var changePasswordButton = UIButton()
        changePasswordButton.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        changePasswordButton.setTitleColor(UIColor (named: "#111827 - #FFFFFF"), for: .normal)
        changePasswordButton.contentHorizontalAlignment = .left
        changePasswordButton.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        return changePasswordButton
    }()
    
    var changePasswordArrowImage: UIImageView = {
        var changePasswordImageView = UIImageView()
        changePasswordImageView.image = UIImage(named: "arrow")
        changePasswordImageView.contentMode = .scaleAspectFill
        return changePasswordImageView
    }()
    var changePasswordLineView: UIView = {
        var changePasswordLineView = UIView()
        changePasswordLineView.backgroundColor = UIColor(named: "#D1D5DB - #1C2431")
        return changePasswordLineView
    }()
    
    var languageButton: UIButton = {
        var languageButton = UIButton()
        languageButton.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        languageButton.setTitleColor(UIColor (named: "#111827 - #FFFFFF"), for: .normal)
        languageButton.contentHorizontalAlignment = .left
        languageButton.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
        return languageButton
    }()
    
    var languageLabel: UILabel = {
        var languageLabel = UILabel()
        languageLabel.font = UIFont(name: "SFProDisplay-Semibold", size: 12)
        languageLabel.textColor = UIColor(named: "#9CA3AF")
        if Localize.currentLanguage() == "ru" {
            languageLabel.text = "Русский"
        }
        
        if Localize.currentLanguage() == "kk" {
            languageLabel.text = "Қазақша"
        }
        if Localize.currentLanguage() == "en" {
            languageLabel.text = "English"
        }
        return languageLabel
    }()
    
    var languageArrowImage: UIImageView = {
        var languageArrowImage = UIImageView()
        languageArrowImage.image = UIImage(named: "arrow")
        return languageArrowImage
    }()
    
    var languageLineView: UIView = {
        var languageLineView = UIView()
        languageLineView.backgroundColor = UIColor(named: "#D1D5DB - #1C2431")
        return languageLineView
    }()
    
    var darkModeButton: UIButton  = {
        var darkModeButton = UIButton()
        darkModeButton.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        darkModeButton.setTitleColor(UIColor (named: "#111827 - #FFFFFF"), for: .normal)
        darkModeButton.contentHorizontalAlignment = .left
        return darkModeButton
    }()
    
    var toggle: UISwitch = {
        var toggle = UISwitch()
        toggle.onTintColor = UIColor(named: "#B376F7")
        toggle.thumbTintColor = .white
        toggle.addTarget(self, action: #selector(changeTheme), for: .valueChanged)
        toggle.isOn = false
        return toggle
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let email = UserDefaults.standard.string(forKey: "email") {
           emailLabel.text = email
       }
        setupView()
        setupConstraints()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        configureLanguages()
    }
    
    // MARK: - @objc funcs
    
    @objc func logOut() {
        let logOutVC = LogOutViewController()
        logOutVC.modalPresentationStyle = .overFullScreen
               present(logOutVC, animated: true,completion: nil)
    }
    @objc func changePersonalData() {
    let personalinfoVC = PersonalInfoViewController()
        navigationController?.pushViewController(personalinfoVC, animated: true)
    }
    
    @objc func changePassword() {
        let changePasswordVC = ChangePasswordViewController()
            navigationController?.pushViewController(changePasswordVC, animated: true)
    }
    @objc func changeLanguage() {
        let languageVC = LanguageViewController()
            languageVC.modalPresentationStyle = .overFullScreen
            languageVC.delegate = self
            present(languageVC, animated: true,completion: nil)
    }
    @objc func changeTheme(_ sender: UISwitch) {
        if let window = view.window {
                window.overrideUserInterfaceStyle = sender.isOn ? .dark : .light
        }
    }

}
// MARK: - Extension
extension ProfileViewController {
    func setupView() {
        view.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        navigationItem.title = "TITLE".localized()
        view.addSubview(avatarImageView)
        view.addSubview(profileLabel)
        view.addSubview(emailLabel)
        view.addSubview(buttonsView)
        buttonsView.addSubview(personalDataButton)
        buttonsView.addSubview(personalDataLabel)
        buttonsView.addSubview(arrowImage)
        buttonsView.addSubview(personalDataLineView)
        buttonsView.addSubview(changePasswordButton)
        buttonsView.addSubview(changePasswordArrowImage)
        buttonsView.addSubview(changePasswordLineView)
        buttonsView.addSubview(languageButton)
        buttonsView.addSubview(languageLabel)
        buttonsView.addSubview(languageArrowImage)
        buttonsView.addSubview(languageLineView)
        buttonsView.addSubview(darkModeButton)
        buttonsView.addSubview(toggle)
        configureLanguages()
        
        let logOutButton = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(logOut))
        logOutButton.tintColor = UIColor(named: "#FF402B")
            self.navigationItem.rightBarButtonItem = logOutButton
       
    }
    
    func configureLanguages() {
        profileLabel.text = "MY_PROFILE".localized()
        personalDataButton.setTitle("PERSONAL_DATA".localized(), for: .normal)
        personalDataLabel.text = "CHANGE".localized()
        changePasswordButton.setTitle("CHANGE_PASSWORD".localized(), for: .normal)
        languageButton.setTitle("LANGUAGE".localized(), for: .normal)
        darkModeButton.setTitle("DARK_MODE".localized(), for: .normal)
        if Localize.currentLanguage() == "ru" {
            languageLabel.text = "Русский"
        }
        
        if Localize.currentLanguage() == "kk" {
            languageLabel.text = "Қазақша"
        }
        if Localize.currentLanguage() == "en" {
            languageLabel.text = "English"
        }
    }
    func languageDidChange() {
        configureLanguages()
    }
    
    func setupConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(104)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
        }
        profileLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom).offset(32)
        }
        emailLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileLabel.snp.bottom).offset(8)
        }
        buttonsView.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
       }
       personalDataButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(adaptiveHeight(for: 63))
       }
        personalDataLabel.snp.makeConstraints { make in
            make.centerY.equalTo(personalDataButton)
            make.right.equalToSuperview().inset(48)
        }
        arrowImage.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.size.equalTo(16)
            make.left.equalTo(personalDataLabel.snp.right).offset(8)
            make.centerY.equalTo(personalDataButton.snp.centerY)
        }
        personalDataLineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(1)
            make.top.equalTo(personalDataButton.snp.bottom)
        }
        changePasswordButton.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.top.equalTo(personalDataLineView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        changePasswordArrowImage.snp.makeConstraints { make in
            make.centerY.equalTo(changePasswordButton.snp.centerY)
            make.size.equalTo(16)
            make.right.equalToSuperview().inset(24)
        }
        changePasswordLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(changePasswordButton.snp.bottom)
        }
        languageButton.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.top.equalTo(changePasswordLineView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        languageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(languageButton)
            make.right.equalToSuperview().inset(48)
        }
        languageArrowImage.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.size.equalTo(16)
            make.left.equalTo(languageLabel.snp.right).offset(8)
            make.centerY.equalTo(languageButton.snp.centerY)
        }
        languageLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(languageButton.snp.bottom)
        }
        darkModeButton.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(languageLineView.snp.bottom)
        }
        toggle.snp.makeConstraints { make in
            make.centerY.equalTo(darkModeButton)
            make.right.equalToSuperview().inset(24)
        }
    }
    
}
