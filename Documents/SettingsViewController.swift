//
//  SettingsViewController.swift
//  Documents
//
//  Created by Алексей Калинин on 25.07.2023.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func sortTableView()
}

class SettingsViewController: UIViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    
    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Сортировка"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBackground
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitle("Сменить пароль", for: .normal)
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.setOn(true, animated: true)
        switcher.addTarget(self, action: #selector(switchTap), for: .touchUpInside)
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    
    let chevron: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "chevron.right")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    init(delegate: FileViewController) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(contentView)
        contentView.addSubviews(label, switcher, button, chevron)
        
        constraints()
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.widthAnchor.constraint(equalToConstant: 220),
            label.heightAnchor.constraint(equalToConstant: 30),
            
            switcher.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switcher.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 3),
            
            button.topAnchor.constraint(equalTo: label.bottomAnchor
                                        , constant: 16),
            button.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: switcher.trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 30),
            
            chevron.centerXAnchor.constraint(equalTo: switcher.centerXAnchor),
            chevron.centerYAnchor.constraint(equalTo: button.centerYAnchor),
        ])
    }
    
    @objc func switchTap() {
        delegate?.sortTableView()
    }
    
    @objc func buttonTap() {
        present(ChangePassViewController(), animated: true)
    }
}
