//
//  TextFieldView.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 21.02.2024.
//

import UIKit
import Foundation
import SnapKit

class TextFieldView: UIView {
    
    var error: String? {
        didSet {
            errorLabel.text = error
            setupError()
        }
    }
    
    // MARK: - UI Elements
    var  titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        titleLabel.textColor = UIColor(named: "111827 - FFFFFF")
        
        return titleLabel
    }()
    
   let textField: TextField = {
        let textField = TextField()
    
        return textField
    }()
    
   let  errorLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        label.textColor = UIColor(named: "#FF402B")
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextFieldView {
    private func setupViews() {
        
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(errorLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupError() {
        if error != nil {
            textField.layer.borderColor = UIColor(named: "#E5EBF0 - #374151")?.cgColor
            
            errorLabel.snp.remakeConstraints { make in
                make.top.equalTo(textField.snp.bottom).offset(16)
                make.bottom.equalToSuperview()
            }
        } else {
            textField.layer.borderColor = UIColor(named: "#FF402B")?.cgColor
            
            errorLabel.snp.remakeConstraints { make in
                make.top.equalTo(textField.snp.bottom)
                make.bottom.equalToSuperview()
            }
        }
    }
}

//extension TextFieldView {
//    @objc
//    private func editingChanged() {
//        error = nil
//    }
//}
/*
// Only override draw() if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
override func draw(_ rect: CGRect) {
    // Drawing code
}
*/


