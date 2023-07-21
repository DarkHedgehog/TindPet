//
//  LoginView.swift
//  TindPet
//
//  Created by Артур Кондратьев on 06.07.2023.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func loginButtonAction()
    func registrationButtonaction()
}

class LoginView: UIView {
    weak var delegate: LoginViewDelegate?
    
    // MARK: - SubViews
    lazy var gradientView: UIView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var logotipView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.image = UIImage(named: "Logo")
        return view
    }()
    
    lazy var logoView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.image = UIImage(named: "paw")
        return view
    }()
    
    lazy var logoWhiteButtomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = UIConstants.logoWhiteButtomWidthHeight / 2
        return view
    }()
    
    lazy var whiteButtomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 35
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 36)
        label.text = "Добро пожаловать!"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var emailLabel = makeLable(text: "Email")
    lazy var passwordLabel = makeLable(text: "Password")
    lazy var loginButtomView = makeButtomTfView()
    lazy var passwordButtomView = makeButtomTfView()
    
    lazy var loginTextField: UITextField = {
        let textF = UITextField()
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.borderStyle = .none
        textF.backgroundColor = .white
        textF.clearButtonMode = .whileEditing
        textF.keyboardType = .emailAddress
        textF.textContentType = .emailAddress
        textF.autocapitalizationType = .none
        textF.font = UIFont.boldSystemFont(ofSize: 16)
        return textF
    }()
    
    lazy var passwordTextField: UITextField = {
        let textF = UITextField()
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.borderStyle = .none
        textF.backgroundColor = .white
        textF.clearButtonMode = .whileEditing
        textF.isSecureTextEntry = true
        textF.textContentType = .oneTimeCode
        return textF
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.tintColor = .white
        button.backgroundColor = UIColor.brendGreen
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTabLoginButton), for: .touchUpInside)
        return button
    }()
    
    lazy var registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Зарегистрироваться", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tintColor = UIColor.topGradientColor
        button.addTarget(self, action: #selector(didTabRegistrationButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - UIConstants
    enum UIConstants {
        static let logotipViewWidth: CGFloat = 244
        static let logotipViewHeight: CGFloat = 50
        static let logoViewHeight: CGFloat = 114.0
        static let logoViewWidth: CGFloat = 117.0
        static let logoWhiteButtomWidthHeight: CGFloat = 136.0
        static let bottonWidth: CGFloat = 34
        static let textFieldHeight: CGFloat = 28
    }
    
    // MARK: - Constraints
    var whiteButtomTopConstraint1 = NSLayoutConstraint()
    var whiteButtomTopConstraint2 = NSLayoutConstraint()
    
    // MARK: - Functions
    func startEditTextFild() {
        whiteButtomTopConstraint1.isActive = false
        whiteButtomTopConstraint2.isActive = true
        UIView.animate(withDuration: 1.0) {
            self.logoView.alpha = 0
            self.logoWhiteButtomView.alpha = 0
            self.layoutIfNeeded()
        }
    }
    
    func endEditTextFild() {
        whiteButtomTopConstraint1.isActive = true
        whiteButtomTopConstraint2.isActive = false
        UIView.animate(withDuration: 1.0) {
            self.logoView.alpha = 1
            self.logoWhiteButtomView.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    @objc func didTabLoginButton() {
        delegate?.loginButtonAction()
    }
    
    @objc func didTabRegistrationButton() {
        delegate?.registrationButtonaction()
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    // MARK: - SetUI
    func configureUI() {
        backgroundColor = .clear
        addSubview(gradientView)
        addSubview(logotipView)
        addSubview(logoWhiteButtomView)
        addSubview(logoView)
        addSubview(whiteButtomView)
        addSubview(welcomeLabel)
        
        addSubview(loginButtomView)
        addSubview(emailLabel)
        addSubview(passwordButtomView)
        
        addSubview(loginTextField)
        addSubview(passwordLabel)
        addSubview(passwordTextField)
        
        addSubview(loginButton)
        addSubview(registrationButton)
        
        whiteButtomTopConstraint1 = whiteButtomView.topAnchor.constraint(equalTo: logoWhiteButtomView.bottomAnchor, constant: 28)
        whiteButtomTopConstraint2 = whiteButtomView.topAnchor.constraint(equalTo: logotipView.bottomAnchor, constant: 28)
        whiteButtomTopConstraint1.isActive = true
        
        whiteButtomView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        whiteButtomView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        whiteButtomView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.leftAnchor.constraint(equalTo: leftAnchor),
            gradientView.rightAnchor.constraint(equalTo: rightAnchor),
            gradientView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            
            logotipView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            logotipView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logotipView.heightAnchor.constraint(equalToConstant: UIConstants.logotipViewHeight),
            logotipView.widthAnchor.constraint(equalToConstant: UIConstants.logotipViewWidth),
            
            logoWhiteButtomView.topAnchor.constraint(equalTo: logotipView.bottomAnchor, constant: 24),
            logoWhiteButtomView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoWhiteButtomView.heightAnchor.constraint(equalToConstant: UIConstants.logoWhiteButtomWidthHeight),
            logoWhiteButtomView.widthAnchor.constraint(equalToConstant: UIConstants.logoWhiteButtomWidthHeight),
            
            logoView.centerYAnchor.constraint(equalTo: logoWhiteButtomView.centerYAnchor),
            logoView.centerXAnchor.constraint(equalTo: logoWhiteButtomView.centerXAnchor),
            logoView.heightAnchor.constraint(equalToConstant: UIConstants.logoViewHeight),
            logoView.widthAnchor.constraint(equalToConstant: UIConstants.logoViewWidth),
            
            welcomeLabel.topAnchor.constraint(equalTo: whiteButtomView.topAnchor, constant: 25),
            welcomeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            welcomeLabel.leftAnchor.constraint(equalTo: whiteButtomView.leftAnchor, constant: 20),
            welcomeLabel.rightAnchor.constraint(equalTo: whiteButtomView.rightAnchor, constant: -20),
            
            loginButtomView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 28),
            loginButtomView.leftAnchor.constraint(equalTo: whiteButtomView.leftAnchor, constant: 40),
            loginButtomView.rightAnchor.constraint(equalTo: whiteButtomView.rightAnchor, constant: -40),
            loginButtomView.heightAnchor.constraint(equalToConstant: 50),
            
            emailLabel.centerYAnchor.constraint(equalTo: loginButtomView.topAnchor),
            emailLabel.leftAnchor.constraint(equalTo: loginButtomView.leftAnchor, constant: 5),
            emailLabel.widthAnchor.constraint(equalToConstant: 70),
            
            loginTextField.centerYAnchor.constraint(equalTo: loginButtomView.centerYAnchor),
            loginTextField.leftAnchor.constraint(equalTo: loginButtomView.leftAnchor, constant: 16),
            loginTextField.rightAnchor.constraint(equalTo: loginButtomView.rightAnchor, constant: -16),
            loginTextField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight),
            
            passwordButtomView.topAnchor.constraint(equalTo: loginButtomView.bottomAnchor, constant: 26),
            passwordButtomView.leftAnchor.constraint(equalTo: loginButtomView.leftAnchor),
            passwordButtomView.rightAnchor.constraint(equalTo: loginButtomView.rightAnchor),
            passwordButtomView.heightAnchor.constraint(equalToConstant: 50),
            
            passwordLabel.centerYAnchor.constraint(equalTo: passwordButtomView.topAnchor),
            passwordLabel.leftAnchor.constraint(equalTo: passwordButtomView.leftAnchor, constant: 5),
            passwordLabel.widthAnchor.constraint(equalToConstant: 90),
            
            passwordTextField.centerYAnchor.constraint(equalTo: passwordButtomView.centerYAnchor),
            passwordTextField.leftAnchor.constraint(equalTo: passwordButtomView.leftAnchor, constant: 16),
            passwordTextField.rightAnchor.constraint(equalTo: passwordButtomView.rightAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight),
            
            loginButton.topAnchor.constraint(equalTo: passwordButtomView.bottomAnchor, constant: 20),
            loginButton.leftAnchor.constraint(equalTo: passwordButtomView.leftAnchor),
            loginButton.rightAnchor.constraint(equalTo: passwordButtomView.rightAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            registrationButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registrationButton.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor)
        ])
    }
}

extension LoginView {
    private func makeLable(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textAlignment = .center
        label.text = text
        label.textColor = .systemGray3
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }
    
    private func makeButtomTfView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.layer.borderWidth = 2
        return view
    }
}
