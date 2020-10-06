//
//  SignUpController.swift
//  firebaseSocialLoginPractice
//
//  Created by 旌榮 凌 on 2020/9/30.
//  Copyright © 2020 com.dltic. All rights reserved.
//

import UIKit
import LBTATools
import Firebase
import FirebaseAuth
import JGProgressHUD
import FBSDKLoginKit
import TwitterKit
import GoogleSignIn

class WelcomeController : UIViewController, GIDSignInDelegate  {
    
    var twitterSession: TWTRSession?
    var provider = OAuthProvider (providerID: "twitter.com")
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()

    lazy var signInAnonymouslyButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Sign In Anonymously", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Service.buttonTitleFontSize)
        button.setTitleColor(Service.buttonTitleColor, for: .normal)
        button.backgroundColor = Service.buttonBackgrountColorSignInAnonymously
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Service.buttonCornerRadius
        button.frame = CGRect(x: 5, y: 100, width: 400, height: 50)
        button.addTarget(self, action: #selector(handleSignInAnonymouslyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSignInAnonymouslyButtonTapped(){
        hud.textLabel.text = "Signing In Anonymously..."
        hud.show(in: view, animated: true)
        Auth.auth().signInAnonymously{ (user, err) in
            if let err = err {
                self.hud.dismiss(animated: true)
                print("Failed to sign in anonymously with error", err)
                Service.showAlert(on: self, style: .alert, title: "Sign In Error", message: err.localizedDescription)
            }
            print("Successfully login as", user?.additionalUserInfo)
            self.hud.dismiss(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    lazy var signInWithFacebookButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Login with Facebook", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Service.buttonTitleFontSize)
        button.setTitleColor(Service.buttonTitleColor, for: .normal)
        button.backgroundColor = Service.buttonBackgrountColorSignInWithFacebook
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Service.buttonCornerRadius
        button.frame = CGRect(x: 5, y: 160, width: 400, height: 50)
        button.addTarget(self, action: #selector(handleSignInWithFacebookButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSignInWithFacebookButtonTapped(){
        hud.textLabel.text = "Logging In with Facebook..."
        hud.show(in: view, animated: true)
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(granted: _, declined: _, token: _):
                self.signIntoFirebase()
                print("Successfully logged in with Facebook.")
            case .failed(let err):
                Service.dismissHud(self.hud, text: "Error", detailText: "Failed to get facebook user with error: \(err)", delay: 3)
            
            case .cancelled:
                Service.dismissHud(self.hud, text: "Error", detailText: "Canceled getting facebook user...", delay: 3)
            }
        }
    }
    
    fileprivate func signIntoFirebase(){
        guard let accessTokenString = AccessToken.current?.tokenString else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credential) { (user, err) in
            if let err = err {
                Service.dismissHud(self.hud, text: "Sign up error", detailText: "Failed to sign up using facebook with error: \(err)", delay: 3)
                return
            }
            print("Successfully authenticated with Facebook.")
            self.hud.dismiss(animated: true)
            self.dismiss(animated: true, completion: nil)
            //self.fetchFacebookUser()
            
        }
    }
    
    lazy var signInWithTwitterButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Login with Twitter", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Service.buttonTitleFontSize)
        button.setTitleColor(Service.buttonTitleColor, for: .normal)
        button.backgroundColor = Service.buttonBackgrountColorSignInWithTwitter
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Service.buttonCornerRadius
        button.frame = CGRect(x: 5, y: 220, width: 400, height: 50)
        button.addTarget(self, action: #selector(handleSignInWithTwitterButtonTapped2), for: .touchUpInside)
        return button
    }()
    
    
//    @objc func handleSignInWithTwitterButtonTapped(){
//        hud.textLabel.text = "Logging In with Twitter..."
//        hud.show(in: view, animated: true)
//        TWTRTwitter.sharedInstance().logIn { (session, err) in
//            if let err = err {
//                Service.dismissHud(self.hud, text: "Error", detailText: "Failed to log in with Twitter with error: \(err)", delay: 10)
//                return
//            }
//            
//            guard let session = session else { return }
//            self.twitterSession = session
//            self.signIntoFirebaseWithTwitter()
//        }
//    }
//    
//    func signIntoFirebaseWithTwitter() {
//        guard let twitterSession = twitterSession else {return}
//        let credential = TwitterAuthProvider.credential(withToken: twitterSession.authToken, secret: twitterSession.authTokenSecret)
//        Auth.auth().signIn(with: credential) { (user, err) in
//            if let err = err {
//                print("Failed to create Firebase user:", err)
//                Service.dismissHud(self.hud, text: "Sign up error", detailText: err.localizedDescription, delay: 10)
//                return
//            }
//            print("Successfully created firebase user:", user?.user.uid ?? "" ) 
//        }
//    }
    
    @objc func handleSignInWithTwitterButtonTapped2(){
        self.signInWithTwitter()
    }
    
    func signInWithTwitter () {
        provider.getCredentialWith (nil) {credential, error in
            if let error = error {
                Service.dismissHud(self.hud, text: "Error", detailText: "Failed to log in with Twitter with error: \(error)", delay: 3)
                return
            }
            if credential != nil {
                Auth.auth().signIn(with: credential!) { AuthResult, err in
                    if let err = err {
                        print("Failed to create Firebase user:", err)
                        Service.dismissHud(self.hud, text: "Sign up error", detailText: err.localizedDescription, delay: 3)
                        return
                    }
                    print("Successfully created firebase user:", AuthResult?.user.uid ?? "" )
                    self.hud.dismiss(animated: true)
                    self.dismiss(animated: true, completion: nil)
              // User is signed in.
              // IdP data available in authResult.additionalUserInfo.profile.
              // Twitter OAuth access token can also be retrieved by:
              // authResult.credential.accessToken
              // Twitter OAuth ID token can be retrieved by calling:
              // authResult.credential.idToken
              // Twitter OAuth secret can be retrieved by calling:
              // authResult.credential.secret
            }
          }
        }
    }
    
//    fileprivate func fetchFacebookUser() {
//        let graphRequestConnection = GraphRequestConnection()
//        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields" : "id, email, name, picture.type(large)"], tokenString: AccessToken.current?.tokenString, version: Settings.defaultGraphAPIVersion , httpMethod: .get)
//
//        graphRequestConnection.add(graphRequest) { (httpResponse, result, err) in
//            if (err != nil){
//                guard let err = err else {
//                    return
//                }
//                print(err)
//            }
//            else{
//                print("the access token is \(AccessToken.current?.tokenString)")
//
//                var accessToken = AccessToken.current?.tokenString
//                var userID = result.
//
//            }
//        }
//    }
    
    lazy var signInWithGoogleButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Login with Google", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Service.buttonTitleFontSize)
        button.setTitleColor(Service.buttonTitleColor, for: .normal)
        button.backgroundColor = Service.buttonBackgrountColorSignInWithGoogle
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Service.buttonCornerRadius
        button.frame = CGRect(x: 5, y: 280, width: 400, height: 50)
        button.addTarget(self, action: #selector(handleSignInWithGoogleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSignInWithGoogleButtonTapped(){
        hud.textLabel.text = "Logging In with Google..."
        hud.show(in: view, animated: true)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            Service.dismissHud(self.hud, text: "Error", detailText: "Failed to log in with Google with error: \(error)", delay: 3)
            return
        }
        
        if let autentication = user.authentication {
            let credential = GoogleAuthProvider.credential(withIDToken: autentication.idToken, accessToken: autentication.accessToken)
            Auth.auth().signIn(with: credential) { AuthResult, err in
                if let err = err {
                    Service.dismissHud(self.hud, text: "Sign up error", detailText: err.localizedDescription, delay: 3)
                    return
                }
                print("Successfully created firebase user:", AuthResult?.user.uid ?? "" )
                self.hud.dismiss(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Welcome"
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        setupViews()
    }
    
    fileprivate func setupViews(){
        self.view.addSubview(signInAnonymouslyButton)
        self.view.addSubview(signInWithFacebookButton)
        self.view.addSubview(signInWithTwitterButton)
        self.view.addSubview(signInWithGoogleButton)
    }
}
