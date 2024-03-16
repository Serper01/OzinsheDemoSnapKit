//
//  LogOutViewController.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 12.03.2024.
//

import UIKit
import Localize_Swift

class LogOutViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    // MARK: - UI Elements
    var backgroundView: UIView = {
        var backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: "#F8EEFF - #1C2431")
        backgroundView.layer.cornerRadius = 32
        backgroundView.clipsToBounds = true
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return backgroundView
    }()
    
    var shortView: UIView = {
        var shortView = UIView()
        shortView.backgroundColor = UIColor(named: "#D1D5D8 - #6B7280")
        return shortView
    }()
    
    var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.text = "EXIT".localized()
        titleLabel.font =  UIFont(name: "SFProDisplay-Bold", size: 24)
        titleLabel.textColor = UIColor(named: "#111827 - #FFFFFF")
        return titleLabel
    }()
    
    var subtitleLabel: UILabel = {
        var subtitleLabel = UILabel()
        subtitleLabel.text = "EXIT_CONFIRMATION".localized()
        subtitleLabel.font =  UIFont(name: "SFProDisplay-Regular", size: 16)
        subtitleLabel.textColor = UIColor(named: "#9CA3AF")
        return subtitleLabel
    }()
    
    var yesButton: UIButton = {
       var yesButton = UIButton()
        yesButton.setTitle("YES".localized(), for: .normal)
        yesButton.titleLabel?.font = UIFont(name: "SFProDisplay-Bold", size: 16)
        yesButton.layer.cornerRadius = 12
        yesButton.backgroundColor = UIColor(named: "#7E2DFC")
        yesButton.addTarget(self, action: #selector(logoutYes), for: .touchUpInside)
        return yesButton
    }()
    
    var noButton: UIButton = {
       var noButton = UIButton()
        noButton.setTitle("NO".localized(), for: .normal)
        noButton.titleLabel?.font = UIFont(name: "SFProDisplay-Bold", size: 16)
        noButton.layer.cornerRadius = 12
        noButton.backgroundColor = .clear
        noButton.setTitleColor(UIColor(named: "#5415C6 - #B376F7"), for: .normal)
        noButton.addTarget(self, action: #selector(cancelNoButton), for: .touchUpInside)
        return noButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
}

// MARK: - Extension
extension LogOutViewController {
    
    func setupViews() {
        view.backgroundColor = UIColor(named: "#000000")
        view.addSubview(backgroundView)
        backgroundView.addSubview(shortView)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(subtitleLabel)
        backgroundView.addSubview(yesButton)
        backgroundView.addSubview(noButton)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    // MARK: - @objc funcs
    @objc func handleDismiss(sender: UIPanGestureRecognizer){
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1,options: .curveEaseOut, animations: {
                self.backgroundView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        case .ended:
            if viewTranslation.y < 100{
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.backgroundView.transform = .identity
                })
            }else{
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    @objc func dismissView() {
         self.dismiss(animated: true,completion: nil)
    }
    
    @objc func logoutYes() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first else {
           return
         }
        let rootViewController = CustomNavigationController(rootViewController: OnboadringViewController())
         window.rootViewController = rootViewController
    }
    
    @objc func cancelNoButton() {
        dismissView()
    }
    // MARK: - GestureRecognizer
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
         if (touch.view?.isDescendant(of: backgroundView))!{
         return false
    }
         return true
    }
    // MARK: - SetupConstraints
    func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(adaptiveHeight(for: 303))
        }
        shortView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(adaptiveSize(for: 21))
            make.height.equalTo(5)
            make.width.equalTo(adaptiveSize(for: 64))
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(adaptiveSize(for: 24))
            make.top.equalTo(shortView.snp.bottom).offset(24)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(adaptiveSize(for: 8))
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
        }
        yesButton.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(adaptiveSize(for: 32))
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
            make.height.equalTo(adaptiveHeight(for: 56))
        }
        noButton.snp.makeConstraints { make in
            make.top.equalTo(yesButton.snp.bottom).offset(adaptiveSize(for: 8))
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
            make.height.equalTo(adaptiveHeight(for: 56))
        }
    }
}
