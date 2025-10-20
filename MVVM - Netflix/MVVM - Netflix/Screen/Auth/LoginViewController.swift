//
//  LoginViewController.swift
//  MVVM - Netflix
//
//  Created by ÖMER  on 14.10.2025.
//

import UIKit

/*
 İyi bir mimaride, bir ViewController'ın görevi sadece kendi ekranını yönetmek ve kullanıcı etkileşimlerini (buton tıklaması gibi) dış dünyaya bildirmektir. Kimi, nasıl bildireceğini bilmemelidir. Sadece "Hey, kullanıcı giriş yaptı, benim işim bitti!" demelidir. Bu sinyali kimin dinlediği ve dinleyince ne yapacağı (ana ekrana geçmek gibi) onun sorumluluğunda olmamalıdır.
 */


// LoginViewController'ın dış dünyaya hangi mesajları gönderebileceğini tanımlayan bir protokol
// AnyObject kısıtlaması, bu protokolü sadece class'ların uygulayabilmesini sağlar ve delegate değişkenini weak olarak tanımlamamıza olanak tanır.
// Bu, hafıza sızıntılarını (retain cycle) önlemek için kritik bir adımdır.
protocol LoginViewControllerDelegate: AnyObject {
    func didFinishLogin() // Kullanıcı başarılı giriş yaptı
    func didTapRegister() // Kullanıcı kayıt ol butonuna bastı
}


class LoginViewController: UIViewController {
    
    // Şimdi LoginViewController'a, bu mesajları kime göndereceğini söyleyeceğimiz bir delegate özelliği ekleyelim.
    weak var delegate : LoginViewControllerDelegate?
    
    
    // MARK: UI Components
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private let registerButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to Register Page", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Get Started"
        label.font = .systemFont(ofSize: 35, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 25
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    // MARK: UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        //self.navigationItem.title = "Login"
        
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(emailTextField)
        view.addSubview(titleLabel)
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        
        // Auto Layout Constraints
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20),
            emailTextField.widthAnchor.constraint(equalToConstant: 300),
            emailTextField.heightAnchor.constraint(equalToConstant: 60),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    // LoginViewController artık tertemiz. SceneDelegate veya UIApplication hakkında hiçbir fikri yok.
    // Sadece görevini yapıyor ve delegate'ine haber veriyor.
    // SceneDelegate'e gidip bu protokolü uygulayacağını söyleyelim ve görevlerini yerine getirelim.
    @objc func didTapLoginButton(){
        delegate?.didFinishLogin()
    }
    
    @objc func didTapRegisterButton() {
        delegate?.didTapRegister()
    }


}
