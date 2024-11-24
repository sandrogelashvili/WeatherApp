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

final class LoginViewController: UIViewController {
    
    private var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontConstants.headline3, weight: .semibold)
        label.textColor = .neutralBlack
        label.text = String.welcomeLabelText
        return label
    }()
    
    private var enterDetailsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontConstants.body1, weight: .regular)
        label.textColor = .neutralBlack
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
        addUsernameTextField()
        addPasswordTextField()
        addLoginButton()
    }
    
    private func addStackView() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(Space.m)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-Space.m)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.customStackSpacing)
        }
    }
    
    private func addUsernameTextField() {
        view.addSubview(usernameTextFieldView)
        usernameTextFieldView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(Space.m)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-Space.m)
            make.top.equalTo(stackView.snp.bottom).offset(Space.xl4)
        }
    }
    
    private func addPasswordTextField() {
        view.addSubview(passwordTextFieldView)
        passwordTextFieldView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(Space.m)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-Space.m)
            make.top.equalTo(usernameTextFieldView.snp.bottom).offset(Space.l)
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
        let mainPageView = MainPageView()
        navigationController?.pushViewController(mainPageView, animated: true)
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
