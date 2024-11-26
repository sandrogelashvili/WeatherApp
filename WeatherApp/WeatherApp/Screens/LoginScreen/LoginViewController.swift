//
//  ViewController.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 18.11.24.
//

import UIKit
import SnapKit

private enum Constants {
    static let customStackSpacing: CGFloat = 68
}

private enum LoginConstants {
    static let validUsername = "WeatherApp"
    static let validPassword = "WeatherApp123"
}

final class LoginViewController: UIViewController {
    
    private var loginImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage.loginImage
        return image
    }()
    
    private var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontConstants.headline1, weight: .regular)
        label.textColor = .white
        label.text = String.welcomeLabelText
        return label
    }()
    
    private var enterDetailsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontConstants.subtitle, weight: .regular)
        label.textColor = .neutralWhite
        label.text = String.detailsLabelText
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [welcomeLabel, enterDetailsLabel])
        stackView.axis = .vertical
        stackView.spacing = Space.m
        stackView.alignment = .fill
        return stackView
    }()
    
    private var usernameTextFieldView: CustomTextFieldView = CustomTextFieldView(
        type: .username,
        labelText: String.usernameLabelText
    )
    
    private var passwordTextFieldView: CustomTextFieldView = CustomTextFieldView(
        type: .password,
        labelText: String.passwordLabelText
    )
    
    private lazy var textFieldsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [usernameTextFieldView, passwordTextFieldView])
        stackView.axis = .vertical
        stackView.spacing = Space.l
        stackView.alignment = .fill
        return stackView
    }()
    
    private var loginButton: CustomButton = {
        let button = CustomButton(
            title: String.loginButtonTitle
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .neutralWhite
        navigationItem.hidesBackButton = true
        setUpUI()
        configureButtonAction()
        addTapGestureToDismissKeyboard()
    }
    
    private func setUpUI() {
        addStackView()
        addTextFieldsStackView()
        addLoginButton()
        addLoginImageView()
    }
    
    private func addLoginImageView() {
        view.insertSubview(loginImageView, at: .zero)
        loginImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addStackView() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(Space.m)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-Space.m)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.customStackSpacing)
        }
    }
    
    private func addTextFieldsStackView() {
        view.addSubview(textFieldsStackView)
        textFieldsStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(Space.m)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-Space.m)
            make.top.equalTo(stackView.snp.bottom).offset(Space.xl5)
        }
    }
    
    private func addLoginButton() {
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Space.m)
            make.trailing.equalToSuperview().offset(-Space.m)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-Space.xl3)
            make.height.equalTo(Size.xl6.height)
        }
    }
    
    private func configureButtonAction() {
        loginButton.setAction { [weak self] in
            self?.handleLoginButton()
        }
    }
    
    private func handleLoginButton() {
        let username = usernameTextFieldView.getTextField().text ?? .empty
        let password = passwordTextFieldView.getTextField().text ?? .empty
        var isValid = true
    
        if username != LoginConstants.validUsername {
            usernameTextFieldView.showErrorMessage(String.usernameError)
            isValid = false
        } else {
            usernameTextFieldView.hideErrorMessage()
        }
        
        if password != LoginConstants.validPassword {
            passwordTextFieldView.showErrorMessage(String.passwordError)
            isValid = false
        } else {
            passwordTextFieldView.hideErrorMessage()
        }
        
        if isValid {
            let mainPageView = MainPageViewController()
            navigationController?.pushViewController(mainPageView, animated: true)
            navigationController?.viewControllers.removeAll { $0 is LoginViewController }
        }
    }
    
    private func addTapGestureToDismissKeyboard() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func dismissKeyboard() {
        usernameTextFieldView.getTextField().resignFirstResponder()
        passwordTextFieldView.getTextField().resignFirstResponder()
    }
}
