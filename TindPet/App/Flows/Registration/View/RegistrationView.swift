//
//  RegistrationView.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 21.06.2023.
//

import UIKit

protocol RegistrationViewDelegate: AnyObject {
    func regButtonAction()
    func loginButtonAction()
}

final class RegistrationView: UIView {
    
    weak var delegate: RegistrationViewDelegate?
    
    struct UIConstants {
        static let logotipViewWidth: CGFloat = 244
        static let logotipViewHeight: CGFloat = 50
        static let logoViewHeight: CGFloat = 114.0
        static let logoViewWidth: CGFloat = 117.0
        static let logoWhiteButtomWidthHeight: CGFloat = 136.0
        static let bottonWidth: CGFloat = 34
        static let textFieldHeight: CGFloat = 28
    }
    
    //MARK: - SubViews
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
    
    lazy var whiteButtomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 35
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        return view
    }()
    
    lazy var registrationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 36)
        label.textAlignment = .center
        label.text = "Новый аккаунт"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var nameLabel = makeLable(text: "Name")
    lazy var nameTFbuttomView = makeButtomTfView()
    lazy var nameTextField: UITextField = {
        let textF = UITextField()
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.borderStyle = .none
        textF.backgroundColor = .white
        textF.clearButtonMode = .whileEditing
        textF.autocapitalizationType = .none
        textF.keyboardType = .emailAddress
        textF.font = UIFont.boldSystemFont(ofSize: 16)
        return textF
    }()
    
    lazy var surnameLabel = makeLable(text: "Surname")
    lazy var surnameTFButtomView = makeButtomTfView()
    lazy var surnameTextField: UITextField = {
        let textF = UITextField()
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.borderStyle = .none
        textF.backgroundColor = .white
        textF.clearButtonMode = .whileEditing
        textF.keyboardType = .emailAddress
        textF.font = UIFont.boldSystemFont(ofSize: 16)
        return textF
    }()
    
    lazy var emailLabel = makeLable(text: "Email")
    lazy var emailTFButtomView = makeButtomTfView()
    lazy var emailTextField: UITextField = {
        let textF = UITextField()
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.borderStyle = .none
        textF.backgroundColor = .white
        textF.clearButtonMode = .whileEditing
        textF.keyboardType = .emailAddress
        textF.font = UIFont.boldSystemFont(ofSize: 16)
        return textF
    }()
    
    lazy var passwordLabel = makeLable(text: "Password")
    lazy var passwordButtomView = makeButtomTfView()
    lazy var passwordTextField: UITextField = {
        let textF = UITextField()
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.borderStyle = .none
        textF.backgroundColor = .white
        textF.clearButtonMode = .whileEditing
        textF.isSecureTextEntry = true
        return textF
    }()
    
    lazy var registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Зарегистрироваться", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.tintColor = .white
        button.backgroundColor = UIColor.brendGreen
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTabRegistrationButton), for: .touchUpInside)
        return button
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("У меня есть аккаунт", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tintColor = UIColor.topGradientColor
        button.addTarget(self, action: #selector(didTabLoginButton), for: .touchUpInside)
        return button
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = false
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    // MARK: - Functions
    @objc func didTabRegistrationButton() {
        delegate?.regButtonAction()
    }
    
    @objc func didTabLoginButton() {
        delegate?.loginButtonAction()
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    //MARK: - SetUI
    func configureUI() {
        backgroundColor = .clear
        addSubview(gradientView)
        addSubview(logotipView)
        addSubview(whiteButtomView)
        addSubview(registrationLabel)
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(nameTFbuttomView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameTextField)
        
        contentView.addSubview(surnameTFButtomView)
        contentView.addSubview(surnameLabel)
        contentView.addSubview(surnameTextField)
        
        contentView.addSubview(emailTFButtomView)
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailTextField)
        
        contentView.addSubview(passwordButtomView)
        contentView.addSubview(passwordLabel)
        contentView.addSubview(passwordTextField)
        
        contentView.addSubview(registrationButton)
        contentView.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.leftAnchor.constraint(equalTo: leftAnchor),
            gradientView.rightAnchor.constraint(equalTo: rightAnchor),
            gradientView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            
            logotipView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            logotipView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logotipView.heightAnchor.constraint(equalToConstant: UIConstants.logotipViewHeight),
            logotipView.widthAnchor.constraint(equalToConstant: UIConstants.logotipViewWidth),
            
            whiteButtomView.topAnchor.constraint(equalTo: logotipView.bottomAnchor, constant: 24),
            whiteButtomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            whiteButtomView.leftAnchor.constraint(equalTo: leftAnchor),
            whiteButtomView.rightAnchor.constraint(equalTo: rightAnchor),
            
            registrationLabel.topAnchor.constraint(equalTo: whiteButtomView.topAnchor, constant: 25),
            registrationLabel.centerXAnchor.constraint(equalTo: whiteButtomView.centerXAnchor),
            registrationLabel.leftAnchor.constraint(equalTo: whiteButtomView.leftAnchor, constant: 20),
            registrationLabel.rightAnchor.constraint(equalTo: whiteButtomView.rightAnchor, constant: -20),
            
            
            scrollView.topAnchor.constraint(equalTo: registrationLabel.bottomAnchor, constant: 26),
            scrollView.leftAnchor.constraint(equalTo: whiteButtomView.leftAnchor, constant: 40),
            scrollView.rightAnchor.constraint(equalTo: whiteButtomView.rightAnchor, constant: -40),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            nameTFbuttomView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameTFbuttomView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            nameTFbuttomView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            nameTFbuttomView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.centerYAnchor.constraint(equalTo: nameTFbuttomView.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: nameTFbuttomView.leftAnchor, constant: 5),
            nameLabel.widthAnchor.constraint(equalToConstant: 50),
            
            nameTextField.centerYAnchor.constraint(equalTo: nameTFbuttomView.centerYAnchor),
            nameTextField.leftAnchor.constraint(equalTo: nameTFbuttomView.leftAnchor, constant: 16),
            nameTextField.rightAnchor.constraint(equalTo: nameTFbuttomView.rightAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight),
            
            surnameTFButtomView.topAnchor.constraint(equalTo: nameTFbuttomView.bottomAnchor, constant: 26),
            surnameTFButtomView.leftAnchor.constraint(equalTo: nameTFbuttomView.leftAnchor),
            surnameTFButtomView.rightAnchor.constraint(equalTo: nameTFbuttomView.rightAnchor),
            surnameTFButtomView.heightAnchor.constraint(equalToConstant: 50),
            
            surnameLabel.centerYAnchor.constraint(equalTo: surnameTFButtomView.topAnchor),
            surnameLabel.leftAnchor.constraint(equalTo: surnameTFButtomView.leftAnchor, constant: 5),
            surnameLabel.widthAnchor.constraint(equalToConstant: 70),
            
            surnameTextField.centerYAnchor.constraint(equalTo: surnameTFButtomView.centerYAnchor),
            surnameTextField.leftAnchor.constraint(equalTo: surnameTFButtomView.leftAnchor, constant: 16),
            surnameTextField.rightAnchor.constraint(equalTo: surnameTFButtomView.rightAnchor, constant: -16),
            surnameTextField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight),
            
            emailTFButtomView.topAnchor.constraint(equalTo: surnameTFButtomView.bottomAnchor, constant: 26),
            emailTFButtomView.leftAnchor.constraint(equalTo: nameTFbuttomView.leftAnchor),
            emailTFButtomView.rightAnchor.constraint(equalTo: nameTFbuttomView.rightAnchor),
            emailTFButtomView.heightAnchor.constraint(equalToConstant: 50),
            
            emailLabel.centerYAnchor.constraint(equalTo: emailTFButtomView.topAnchor),
            emailLabel.leftAnchor.constraint(equalTo: emailTFButtomView.leftAnchor, constant: 5),
            emailLabel.widthAnchor.constraint(equalToConstant: 50),
            
            emailTextField.centerYAnchor.constraint(equalTo: emailTFButtomView.centerYAnchor),
            emailTextField.leftAnchor.constraint(equalTo: emailTFButtomView.leftAnchor, constant: 16),
            emailTextField.rightAnchor.constraint(equalTo: emailTFButtomView.rightAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight),
            
            passwordButtomView.topAnchor.constraint(equalTo: emailTFButtomView.bottomAnchor, constant: 26),
            passwordButtomView.leftAnchor.constraint(equalTo: nameTFbuttomView.leftAnchor),
            passwordButtomView.rightAnchor.constraint(equalTo: nameTFbuttomView.rightAnchor),
            passwordButtomView.heightAnchor.constraint(equalToConstant: 50),
            
            passwordLabel.centerYAnchor.constraint(equalTo: passwordButtomView.topAnchor),
            passwordLabel.leftAnchor.constraint(equalTo: passwordButtomView.leftAnchor, constant: 5),
            passwordLabel.widthAnchor.constraint(equalToConstant: 80),
            
            passwordTextField.centerYAnchor.constraint(equalTo: passwordButtomView.centerYAnchor),
            passwordTextField.leftAnchor.constraint(equalTo: passwordButtomView.leftAnchor, constant: 16),
            passwordTextField.rightAnchor.constraint(equalTo: passwordButtomView.rightAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight),
            
            registrationButton.topAnchor.constraint(equalTo: passwordButtomView.bottomAnchor, constant: 26),
            registrationButton.leftAnchor.constraint(equalTo: passwordButtomView.leftAnchor),
            registrationButton.rightAnchor.constraint(equalTo: passwordButtomView.rightAnchor),
            registrationButton.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.topAnchor.constraint(equalTo: registrationButton.bottomAnchor, constant: 20),
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            loginButton.centerXAnchor.constraint(equalTo: registrationButton.centerXAnchor)
        ])
    }
}

extension RegistrationView {
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
