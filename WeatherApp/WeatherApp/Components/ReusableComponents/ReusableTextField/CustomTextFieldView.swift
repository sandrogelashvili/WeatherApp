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
        label.textColor = .neutralWhite
        return label
    }()
    
    private var reusableTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .neutralWhite
        textField.layer.borderColor = UIColor.grayPrimary.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6
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
        return stack
    }()
    
    
    init(type: TextFieldType = .username, labelText: String = .empty) {
        self.textFieldType = type
        super.init(frame: .zero)
        reusableLabel.text = labelText
        setUpUI()
        addVisibilityButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError(String.requiredError)
    }
    
    private func setUpUI() {
        addComponentsStackView()
        configureTextFieldForType()
    }
    
    private func addComponentsStackView() {
        addSubview(componentsStackView)
        componentsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureTextFieldForType() {
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.graLight2
        ]

        if textFieldType == .password {
            reusableTextField.isSecureTextEntry = true
            reusableTextField.attributedPlaceholder = NSAttributedString(
                string: String.passwordPlaceholder,
                attributes: placeholderAttributes
            )
            reusableTextField.rightViewMode = .always
            reusableTextField.rightView = visibilityIconButton
        } else if textFieldType == .username {
            reusableTextField.attributedPlaceholder = NSAttributedString(
                string: String.usernamePlaceholder,
                attributes: placeholderAttributes
            )
        }
    }
    
    private func addVisibilityButtonAction() {
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
