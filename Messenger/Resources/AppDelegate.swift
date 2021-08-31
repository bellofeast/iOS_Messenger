//
//  AppDelegate.swift
//  Messenger
//
//  Created by 김종서 on 2021/08/25.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn


@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        // Facebook Log In
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        // Google Sign In
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        // Facebook Log In
        ApplicationDelegate.shared.application(app,
                                               open: url,
                                               sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                               annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        // Google Sign In
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    // Google Sign In
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        guard error == nil else {
            if let error = error {
                print("Failed to sign in with Google: \(error)")
            }
            return
        }
        
        guard let email = user.profile.email,
              let firstName = user.profile.givenName,
              let lastName = user.profile.familyName else {
            return
        }
        
        DatabaseManager.shared.userExists(with: email, completion: { exists in
            
            if !exists {
                // Insert to database
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName,
                                                                    lastName: lastName,
                                                                    emailAddress: email))
            }
        })
        
        guard let authentication = user.authentication else {
            print("Missing auth object off of Google user.")
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult, error in
            
            guard authResult != nil, error == nil else {
                print("Failed to sign in with Google credential.")
                return
            }
            
            print("Successfully signed in with Google credential")
            
            NotificationCenter.default.post(name: Notification.Name.didLogInNotification, object: nil)
        })
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        print("Google user was disconnected.")
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
}
