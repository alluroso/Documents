//
//  ChangePassViewController.swift
//  Documents
//
//  Created by Алексей Калинин on 25.07.2023.
//

import UIKit

class ChangePassViewController: UIViewController {
    
    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    let oldPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.placeholder = "Старый пароль"
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 10
        textField.layer.shadowRadius = 2
        textField.layer.shadowOpacity = 0.3
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let newPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.placeholder = "Новый пароль"
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 10
        textField.layer.shadowRadius = 2
        textField.layer.shadowOpacity = 0.3
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.placeholder = "Повторите новый пароль"
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
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Сменить пароль", for: .normal)
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        constraints()
    }
    
    func setupViews() {
        view.backgroundColor = .systemFill
        view.addSubview(contentView)
        contentView.addSubviews(oldPasswordTextField, newPasswordTextField, confirmPasswordTextField, button)
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            oldPasswordTextField.centerXAnchor.constraint(equalTo: newPasswordTextField.centerXAnchor),
            oldPasswordTextField.bottomAnchor.constraint(equalTo: newPasswordTextField.topAnchor, constant: -16),
            oldPasswordTextField.widthAnchor.constraint(equalToConstant: 230),
            oldPasswordTextField.heightAnchor.constraint(equalToConstant: 45),
            
            newPasswordTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            newPasswordTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            newPasswordTextField.widthAnchor.constraint(equalToConstant: 230),
            newPasswordTextField.heightAnchor.constraint(equalToConstant: 45),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 16),
            confirmPasswordTextField.centerXAnchor.constraint(equalTo: newPasswordTextField.centerXAnchor),
            confirmPasswordTextField.widthAnchor.constraint(equalToConstant: 230),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 45),
            
            button.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 16),
            button.centerXAnchor.constraint(equalTo: newPasswordTextField.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 180),
            button.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    func alert(_ message: String? = nil) {
        let alert = UIAlertController(title: "Уведомление", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .cancel)
        alert.addAction(action)
        alert.view.tintColor = .black
        present(alert, animated: true)
    }
}

extension ChangePassViewController {
    
    @objc func buttonTap() {
        
        let oldPassword = oldPasswordTextField.text!
        let newPassword = newPasswordTextField.text!
        let confirmPassword = confirmPasswordTextField.text!
        var message = ""
        
        if oldPassword == "" || newPassword == "" || confirmPassword == "" {
            message = "Все поля должны быть заполнены. Попробуйте еще раз"
            deleteText()
            alert(message)
            return
        }
        
        guard oldPassword.count >= 4 && newPassword.count >= 4 && confirmPassword.count >= 4 else {
            message = "Пароль должен быть длиннее 4-х символов. Попробуйте еще раз"
            deleteText()
            alert(message)
            return
        }
        
        guard oldPassword == KeyChain.shared.keychain["password"] else {
            message = "Неверный пароль. Попробуйте еще раз"
            deleteText()
            alert(message)
            return
        }
        
        guard newPassword == confirmPassword else {
            message = "Пароли не совпадают. Попробуйте еще раз"
            deleteText()
            alert(message)
            return
        }
        
        guard newPassword != oldPassword else {
            message = "Новый пароль не должен совпадать со старым паролем. Попробуйте еще раз"
            deleteText()
            alert(message)
            return
        }
        
        deleteText()
        KeyChain.shared.keychain["password"] = newPassword
        message = "Пароль успешно изменен"
        alert(message)
    }
    
    func deleteText() {
        oldPasswordTextField.text = ""
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
    }
}
