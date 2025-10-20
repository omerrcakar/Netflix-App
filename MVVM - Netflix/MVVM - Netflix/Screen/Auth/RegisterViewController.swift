//
//  RegisterViewController.swift
//  MVVM - Netflix
//
//  Created by ÖMER  on 14.10.2025.
//

import UIKit

protocol RegisterViewControllerDelegate: AnyObject {
    func didFinishRegister()
}

class RegisterViewController: UIViewController {
    
    
    weak var delegate : RegisterViewControllerDelegate?
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Let's Meet!"
        label.font = .systemFont(ofSize: 35, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI(){
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(registerButton)
        
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            registerButton.widthAnchor.constraint(equalToConstant: 200),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    @objc private func didTapRegisterButton(){
        delegate?.didFinishRegister()
    }
    

}
