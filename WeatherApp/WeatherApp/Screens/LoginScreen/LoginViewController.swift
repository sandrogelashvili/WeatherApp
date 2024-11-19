//
//  ViewController.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 18.11.24.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    private var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .neutralBlack
        label.text = "Welcome!"
        return label
    }()
    
    private var enterDetailsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .neutralBlack
        label.text = "Please enter your details below"
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [welcomeLabel, enterDetailsLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        return stackView
    }()
    
    private var emailTextFieldView: CostumeTextFieldView = CostumeTextFieldView(
        type: .username,
        labelText: "Username"
    )
    
    private var passwordTextFieldView: CostumeTextFieldView = CostumeTextFieldView(
        type: .password,
        labelText: "Password"
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
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(68)
        }
    }
    
    private func addTextFieldViews() {
        view.addSubview(emailTextFieldView)
        view.addSubview(passwordTextFieldView)
        
        emailTextFieldView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.top.equalTo(stackView.snp.bottom).offset(40)
        }
        
        passwordTextFieldView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.top.equalTo(emailTextFieldView.snp.bottom).offset(20)
        }
    }
    
    private func addTapGestureToDismissKeyboard() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func dismissKeyboard() {
        emailTextFieldView.getTextField().resignFirstResponder()
        passwordTextFieldView.getTextField().resignFirstResponder()
    }
}
