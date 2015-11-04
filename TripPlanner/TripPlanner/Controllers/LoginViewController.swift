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
        
        let user = ManagedUserModel.getCurrentUser()
        print(user)
        
        loginForm.delegate = self
    }
    
    func onLoginSignupSuccess(user: UserModel) {
        print(user)
        
        dispatch_async(dispatch_get_main_queue(),{
            self.performSegueWithIdentifier("transitionFromLogin", sender: self)
        })
    }
    
    private func showAlert(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        dispatch_async(dispatch_get_main_queue(),{
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    func onUnknownError() {
        loginForm.unlockForm()
        showAlert("Oh No! We're sorry, an unknown error occured. Please try whatever you were doing again.", title: "Unknown Error")
    }
    
    func onEmailTaken() {
        loginForm.unlockForm()
        showAlert("Looks like that email is already taken.", title: "Email Taken")
    }
    
    func onInvalidCredentials() {
        loginForm.unlockForm()
        showAlert("Your email and password combination doesn't correspond to any known users. Woops.", title: "Invalid Credentials")
    }

}

extension LoginViewController: LoginViewDelegate {
    
    func doLogin(email: String, password: String) {
        loginForm.lockForm()
        UserModel.login(onLoginSignupSuccess, onInvalidCredentials: onInvalidCredentials, onUnknownError: onUnknownError, email: email, password: password)
    }
    
    func doSignup(email: String, password: String) {
        loginForm.lockForm()
        ManagedUserModel.create(onLoginSignupSuccess, onEmailTaken: onEmailTaken, onUnknownError: onUnknownError, email: email, password: password)
    }
    
}