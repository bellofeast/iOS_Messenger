//
//  RegisterViewController.swift
//  Messenger
//
//  Created by 김종서 on 2021/08/25.
//

import UIKit


class RegisterViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        
        scrollView.clipsToBounds = true
        
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .systemGray
        
        return imageView
    }()
    
    private let firstName: UITextField = {
        
        let field = UITextField()
        
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemGray.cgColor
        field.placeholder = "First Name ..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
    }()
    
    private let lastName: UITextField = {
        
        let field = UITextField()
        
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemGray.cgColor
        field.placeholder = "Last Name ..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
    }()
    
    private let emailField: UITextField = {
        
        let field = UITextField()
        
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemGray.cgColor
        field.placeholder = "Email Address ..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
    }()
    
    private let passwordField: UITextField = {
        
        let field = UITextField()
        
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemGray.cgColor
        field.placeholder = "Password ..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        
        return field
    }()
    
    private let registerButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        
        registerButton.addTarget(self,
                                 action: #selector(registerButtonTapped),
                                 for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        // Add subviews
        view.addSubview(scrollView)
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstName)
        scrollView.addSubview(lastName)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapChangeProfilePic))
                
        imageView.addGestureRecognizer(gesture)
    }
    
    @objc private func didTapChangeProfilePic() {
        
        print("Change pic called")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        let size = scrollView.width / 4
        
        imageView.frame = CGRect(x: (scrollView.width - size) / 2,
                                 y: 44,
                                 width: size,
                                 height: size)
        
        firstName.frame = CGRect(x: 30,
                                 y: imageView.bottom + 44,
                                 width: scrollView.width - 60,
                                 height: 52)
        
        lastName.frame = CGRect(x: 30,
                                y: firstName.bottom + 8,
                                width: scrollView.width - 60,
                                height: 52)
        
        emailField.frame = CGRect(x: 30,
                                  y: lastName.bottom + 8,
                                  width: scrollView.width - 60,
                                  height: 52)
        
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom + 8,
                                     width: scrollView.width - 60,
                                     height: 52)
        
        registerButton.frame = CGRect(x: 30,
                                      y: passwordField.bottom + 16,
                                      width: scrollView.width - 60,
                                      height: 52)
    }
    
    
    @objc private func didTapRegister() {
        
        let vc = RegisterViewController()
        
        vc.title = "Create Account"
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func registerButtonTapped() {
        
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let firstName = firstName.text,
              let lastName = lastName.text,
              let email = emailField.text,
              let password = passwordField.text,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else {
            
            alertUserLoginError()
            
            return
        }
        
        // Firebase Log In
        
    }
    
    func alertUserLoginError() {
        
        let alert = UIAlertController(title: "Woops",
                                      message: "Please enter all information to create a new account.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}


extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            registerButtonTapped()
        }
        
        return true
    }
}
