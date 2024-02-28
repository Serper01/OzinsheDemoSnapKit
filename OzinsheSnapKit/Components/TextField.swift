//
//  TextField.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 21.02.2024.
//

import UIKit

class TextField: UITextField {
    
    override var isSecureTextEntry: Bool {
            didSet {
                showButton.isHidden = false
                insets.right = 52
            }
        }
        
//        var icon: UIImage? {
//            didSet {
//                iconImageView.image = icon
//            }
//        }
        
        var insets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 44, bottom: 16, right: 16)
        
        override var placeholder: String? {
            didSet {
                guard let placeholder else {
                    return
                }
                
                attributedPlaceholder = NSAttributedString(string: placeholder)
            }
        }
        
        // MARK: - UI Elements
        
         lazy var iconImageView: UIImageView = {
            let imageView = UIImageView()
            
            imageView.tintColor = UIColor(named: "#9CA3AF")
            imageView.contentMode = .scaleAspectFill
            
            return imageView
        }()
        
            lazy var showButton: UIButton = {
            let button = UIButton()
            
            button.setImage(UIImage(named: "ShowIcon"), for: .normal)
            button.tintColor = UIColor(named: "#E5EBF0 - #374151")
            button.isHidden = true
            
            button.addAction(UIAction(handler: { _ in
                self.isSecureTextEntry.toggle()
            }), for: .primaryActionTriggered)
            
            return button
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
            setupConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: insets)
        }
        
        override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: insets)
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: insets)
        }
    }

    extension TextField {
        private func setupView() {
            backgroundColor = UIColor(named: "FFFFFF - 1C2431")
            textColor = UIColor(named: "FFFFF-111827")
            layer.cornerRadius = 12
            layer.borderWidth = 1
            layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1).cgColor
            font = UIFont(name: "SFProDisplay-Semibold", size: 16)
            
            addSubview(iconImageView)
            addSubview(showButton)
            
            addTarget(self, action: #selector(editingBegin), for: .editingDidBegin)
            addTarget(self, action: #selector(editingEnd), for: .editingDidEnd)
        }
        
        private func setupConstraints() {
            iconImageView.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(16)
                make.size.equalTo(20)
                make.centerY.equalToSuperview()
            }
            
            showButton.snp.makeConstraints { make in
                make.verticalEdges.right.equalToSuperview()
                make.width.equalTo(52)
            }
        }
    }

    extension TextField {
        @objc
        private func editingBegin() {
            layer.borderColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1).cgColor
        }
        
        @objc
        private func editingEnd() {
            layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1).cgColor
        }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
