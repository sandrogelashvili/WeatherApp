//
//  CustomTextFieldView.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 19.11.24.
//

import UIKit
import SnapKit

enum TextFieldType {
    case username, password
}

final class CustomTextFieldView: UIView {
    private var textFieldType: TextFieldType
    private var isPasswordVisible = false
    
    private var reusableLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: FontConstants.body2, weight: .medium)
        label.textColor = .neutralBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var reusableTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = String.usernamePlaceholder
        return textField
    }()
    
    private var visibilityIconButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.invisibleIcon, for: .normal)
        button.tintColor = .grayPrimary
        return button
    }()
    
    private lazy var componentsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [reusableLabel, reusableTextField])
        stack.axis = .vertical
        stack.spacing = Space.xs
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    init(type: TextFieldType = .username, labelText: String = .empty) {
        self.textFieldType = type
        super.init(frame: .zero)
        reusableLabel.text = labelText
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError(String.requiredErrorText)
    }
    
    private func setUpUI() {
        addSubview(componentsStackView)
        componentsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if textFieldType == .password {
            reusableTextField.placeholder = String.passwordPlaceholder
            reusableTextField.isSecureTextEntry = true
            reusableTextField.rightViewMode = .always
            reusableTextField.rightView = visibilityIconButton
        }
        visibilityIconButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
    }
    
    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        reusableTextField.isSecureTextEntry = !isPasswordVisible
        visibilityIconButton.setImage(
            isPasswordVisible ? UIImage.visibleIcon : UIImage.invisibleIcon,
            for: .normal
        )
    }
    
    func getTextField() -> UITextField {
        return reusableTextField
    }
    
    func getLabel() -> UILabel {
        return reusableLabel
    }
}
