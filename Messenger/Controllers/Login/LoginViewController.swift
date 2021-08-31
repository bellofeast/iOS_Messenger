//
//  LoginViewController.swift
//  Messenger
//
//  Created by 김종서 on 2021/08/25.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import JGProgressHUD


class LoginViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .light)
    
    private let scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        
        scrollView.clipsToBounds = true
        
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "paperplane.circle.fill")
        imageView.tintColor = .systemBlue
        
        return imageView
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
    
    private let loginButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        
        return button
    }()
    
    private let facebookLoginButton: FBLoginButton = {
        
        let button = FBLoginButton()
        
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.permissions = ["email", "public_profile"]
        
        return button
    }()
    
    private let googleSignInButton: GIDSignInButton = {
        
        let button = GIDSignInButton()
        
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private var loginObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginObserver = NotificationCenter.default.addObserver(forName: Notification.Name.didLogInNotification,
                                                               object: nil,
                                                               queue: OperationQueue.main,
                                                               using: { [weak self] _ in
                                                                guard let strongSelf = self else {
                                                                    return
                                                                }
                                                                
                                                                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                                                               })
        
        title = "Login"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        facebookLoginButton.delegate = self
        
        GIDSignIn.sharedInstance().presentingViewController = self
        
        // Add subviews
        view.addSubview(scrollView)
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(facebookLoginButton)
        scrollView.addSubview(googleSignInButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        let size = scrollView.width / 4
        
        imageView.frame = CGRect(x: (scrollView.width - size) / 2,
                                 y: 44,
                                 width: size,
                                 height: size)
        
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom + 44,
                                  width: scrollView.width - 60,
                                  height: 52)
        
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom + 8,
                                     width: scrollView.width - 60,
                                     height: 52)
        
        loginButton.frame = CGRect(x: 30,
                                   y: passwordField.bottom + 16,
                                   width: scrollView.width - 60,
                                   height: 52)
        
        facebookLoginButton.frame = CGRect(x: 30,
                                           y: loginButton.bottom + 8,
                                           width: scrollView.width - 60,
                                           height: 52)
        
        googleSignInButton.frame = CGRect(x: 30,
                                          y: facebookLoginButton.bottom + 8,
                                          width: scrollView.width - 60,
                                          height: 52)
    }
    
    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    
    @objc private func didTapRegister() {
        
        let vc = RegisterViewController()
        
        vc.title = "Create Account"
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func loginButtonTapped() {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        spinner.show(in: view)
        
        // Firebase Log In
        FirebaseAuth.Auth.auth().signIn(withEmail: email,
                                        password: password,
                                        completion: { [weak self] authReuslt, error in
                                            
                                            guard let strongSelf = self else {
                                                return
                                            }
                                            
                                            DispatchQueue.main.async {
                                                strongSelf.spinner.dismiss()
                                            }
                                            
                                            guard let result = authReuslt, error == nil else {
                                                print("Failed to log in user with email: \(email)")
                                                return
                                            }
                                            
                                            let user = result.user
                                            
                                            print("Logged in User: \(user)")
                                            
                                            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                                        })
        
    }
    
    func alertUserLoginError() {
        
        let alert = UIAlertController(title: "Woops",
                                      message: "Please enter all information to log in.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginButtonTapped()
        }
        
        return true
    }
}


// Facebook Login
extension LoginViewController: LoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // no operation
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        guard let token = result?.token?.tokenString else {
            print("User failed to login with Facebook.")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields": "email, first_name, last_name, picture.type(large)"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)
        
        facebookRequest.start(completionHandler: { _, result, error in
            
            guard let result = result as? [String: Any], error == nil else {
                print("Failed to make Facebook graph request.")
                return
            }
            
            guard let firstName = result["first_name"] as? String,
                  let lastName = result["last_name"] as? String,
                  let email = result["email"] as? String,
                  let picture = result["picture"] as? [String: Any],
                  let data = picture["data"]as? [String: Any],
                  let pictureURL = data["url"] as? String else {
                print("Failed to get name and email from Facebook result.")
                return
            }
            
            
            DatabaseManager.shared.userExists(with: email, completion: { exists in
                
                if !exists {
                    
                    let chatUser = ChatAppUser(firstName: firstName,
                                               lastName: lastName,
                                               emailAddress: email)
                    
                    DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                        
                        if success {
                            
                            // Upload image
                            
                            guard let url = URL(string: pictureURL) else {
                                return
                            }
                            
                            print("Downloading data from Facebook image.")
                            
                            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                                
                                guard let data = data else {
                                    print("Failed to get profile picture from Facebook.")
                                    return
                                }
                                
                                print("Got data from Facebook, uploading ...")
                                
                                let fileName = chatUser.profilePictureFileName
                                
                                StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: { result in

                                    switch result {

                                    case .success(let downloadURL):
                                        UserDefaults.standard.setValue(downloadURL, forKey: "profile_picture_url")
                                        print(downloadURL)

                                    case .failure(let error):
                                        print("Storage manager error: \(error)")

                                    }
                                })
                            }).resume()
                        }
                    })
                }
            })
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult, error in
                
                guard let strongSelf = self else {
                    return
                }
                
                guard authResult != nil, error == nil else {
                    print("Facebook credential login failed, MFA may be needed.")
                    return
                }
                
                print("Successfully logeed user in.")
                
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
    }
}
