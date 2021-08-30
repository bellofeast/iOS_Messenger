//
//  ViewController.swift
//  Messenger
//
//  Created by 김종서 on 2021/08/25.
//

import UIKit
import FirebaseAuth


class ConversationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        validateAuth()
    }
    
    private func validateAuth() {
        
        if FirebaseAuth.Auth.auth().currentUser  == nil {
            
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            
            nav.modalPresentationStyle = .fullScreen
            
            present(nav, animated: false)
        }
        
    }
    
    
    
    
}

