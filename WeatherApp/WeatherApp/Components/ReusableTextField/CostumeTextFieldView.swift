//
//  CostumeTextFieldView.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 19.11.24.
//

import UIKit
import SnapKit

enum TextFieldType {
    case username, password
}

class CostumeTextFieldView: UIView {
    private var textFieldType: TextFieldType
    private var isPasswordVisible = false
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .neutralBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter Username"
        return textField
    }()
    
    private var visibilityIconButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .grayPrimary
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [label, textField])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    init(type: TextFieldType = .username, labelText: String = "") {
        self.textFieldType = type
        super.init(frame: .zero)
        
        label.text = labelText
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if textFieldType == .password {
            textField.placeholder = "Enter password"
            textField.isSecureTextEntry = true
            textField.rightViewMode = .always
            textField.rightView = visibilityIconButton
        }
        visibilityIconButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
    }
    
    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        textField.isSecureTextEntry = !isPasswordVisible
        let iconName = isPasswordVisible ? "eye" : "eye.slash"
        visibilityIconButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
    
    func getTextField() -> UITextField {
        return textField
    }
    
    func getLabel() -> UILabel {
        return label
    }
}
