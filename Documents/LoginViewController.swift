//
//  LoginViewController.swift
//  Documents
//
//  Created by Алексей Калинин on 25.07.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    enum State: String {
        case passwordDidNotCreated = "отсутствует"
        case passwordDidCreated = "установлен"
    }
    
    enum PasswordEntered {
        case initial
        case firstTimeEntered
    }
    
    var tmpPassword = ""
    var passwordEntered: PasswordEntered = .initial
    
    var state: State {
        get {
            if KeyChain.shared.keychain["password"] != nil {
                return .passwordDidCreated
            } else {
                return .passwordDidNotCreated
            }
        }
        set { }
    }
    
    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.placeholder = "Введите пароль"
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 10
        textField.layer.shadowRadius = 2
        textField.layer.shadowOpacity = 0.3
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var removeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.setTitle("Удалить пароль", for: .normal)
        button.addTarget(self, action: #selector(removeButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        constraints()
        setupButton()
        print("Наличие пароля: \(state.rawValue)")
    }
    
    func setupViews() {
        view.backgroundColor = .systemGray
        view.addSubview(contentView)
        contentView.addSubviews(passwordTextField, button, removeButton)
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            passwordTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: 230),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45),
            passwordTextField.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -16),
            
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 180),
            button.heightAnchor.constraint(equalToConstant: 45),
            
            removeButton.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 16),
            removeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            removeButton.widthAnchor.constraint(equalToConstant: 180),
            removeButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    func setupButton() {
        switch state {
        case .passwordDidCreated:
            button.setTitle("Войти", for: .normal)
        case .passwordDidNotCreated:
            button.setTitle("Создать пароль", for: .normal)
        }
    }
    
    func alert(_ errorText: String? = nil) {
        let alert = UIAlertController(title: "Уведомление", message: errorText, preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .cancel)
        alert.addAction(action)
        alert.view.tintColor = .black
        present(alert, animated: true)
    }
    
    @objc func buttonTap() {
        
        let password = passwordTextField.text!
        var errorText = ""
        
        guard password.count >= 4 else {
            switch passwordEntered {
            case .initial:
                errorText = "Пароль должен быть длиннее 4-х символов. Попробуйте еще раз"
            default:
                errorText = "Пароли не совпадают. Попробуйте еще раз"
            }
            
            passwordTextField.text = ""
            alert(errorText)
            return
        }
        
        switch state {
        case .passwordDidCreated:
            
            let savedPassword = KeyChain.shared.keychain["password"]
            if password != savedPassword  {
                errorText = "Неверный пароль. Попробуйте еще раз"
                passwordTextField.text = ""
                alert(errorText)
            } else {
                passwordTextField.text = ""
                navigationController?.pushViewController(tabBar(), animated: true)
            }
            
        case .passwordDidNotCreated:
            
            switch passwordEntered {
            case .initial:
                button.setTitle("Подтвердить пароль", for: .normal)
                passwordEntered = .firstTimeEntered
                passwordTextField.text = ""
                tmpPassword = password
            default:
                if password != tmpPassword {
                    errorText = "Пароли не совпадают. Попробуйте еще раз"
                    button.setTitle("Создать пароль", for: .normal)
                    passwordTextField.text = ""
                    passwordEntered = .initial
                    alert(errorText)
                } else {
                    state = .passwordDidCreated
                    button.setTitle("Войти", for: .normal)
                    KeyChain.shared.keychain["password"] = password
                    passwordTextField.text = ""
                    print("Наличие пароля: \(state.rawValue)")
                    navigationController?.pushViewController(tabBar(), animated: true)
                }
            }
        }
    }
    
    @objc func removeButtonTap() {
        
        if KeyChain.shared.keychain["password"] != nil {
            KeyChain.shared.keychain["password"] = nil
            alert("Пароль удален")
            print("Наличие пароля: \(state.rawValue)")
            button.setTitle("Создать пароль", for: .normal)
        } else {
            alert("Ошибка: пароль не установлен")
        }
    }
}

extension LoginViewController {
    
    func tabBar() -> UITabBarController {
        
        let tapBar = UITabBarController()
        
        let fileVC = FileViewController()
        let fileNC = UINavigationController(rootViewController: fileVC)
        
        let settingsNC = UINavigationController(rootViewController: SettingsViewController(delegate: fileVC))
        
        tapBar.viewControllers = [fileNC, settingsNC]
        tapBar.viewControllers?.first?.tabBarItem.title = "Documents"
        tapBar.viewControllers?.first?.tabBarItem.image = UIImage(systemName: "folder")
        tapBar.viewControllers?.last?.tabBarItem.title = "Settings"
        tapBar.viewControllers?.last?.tabBarItem.image = UIImage(systemName: "gear")
        return tapBar
    }
}
