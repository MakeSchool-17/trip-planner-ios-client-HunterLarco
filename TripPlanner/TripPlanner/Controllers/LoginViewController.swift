//
//  LoginViewController.swift
//  TripPlanner
//
//  Created by Hunter on 11/3/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginForm: LoginView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loginForm.delegate = self
    }
    
    func onLoginSignupSuccess(user: UserModel) {
        print(user)
        
        dispatch_async(dispatch_get_main_queue(),{
            self.performSegueWithIdentifier("transitionFromLogin", sender: self)
        })
    }
    
    func onUnknownError() {
        print("Unknown Error")
    }
    
    func onEmailTaken() {
        print("Email Taken")
    }
    
    func onInvalidCredentials() {
        print("Invalid Credentials")
    }

}

extension LoginViewController: LoginViewDelegate {
    
    func doLogin(email: String, password: String) {
        UserModel.login(onLoginSignupSuccess, onInvalidCredentials: onInvalidCredentials, onUnknownError: onUnknownError, email: email, password: password)
    }
    
    func doSignup(email: String, password: String) {
        UserModel.create(onLoginSignupSuccess, onEmailTaken: onEmailTaken, onUnknownError: onUnknownError, email: email, password: password)
    }
    
}