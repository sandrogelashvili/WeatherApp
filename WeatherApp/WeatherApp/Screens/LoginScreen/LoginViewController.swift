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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .neutralWhite
        navigationItem.hidesBackButton = true
        setUpUI()
        addTextFieldViews()
        addTapGestureToDismissKeyboard()
    }
    
    private func setUpUI() {
        addStackView()
    }
    
    private func addStackView() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(Space.m)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-Space.m)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.customStackSpacing)
        }
    }
    
    private func addTextFieldViews() {
        view.addSubview(usernameTextFieldView)
        view.addSubview(passwordTextFieldView)
        
        usernameTextFieldView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(Space.m)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-Space.m)
            make.top.equalTo(stackView.snp.bottom).offset(Space.xl4)
        }
        
        passwordTextFieldView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(Space.m)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-Space.m)
            make.top.equalTo(usernameTextFieldView.snp.bottom).offset(Space.l)
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
