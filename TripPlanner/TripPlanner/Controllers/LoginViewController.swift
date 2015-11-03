//
//  LoginViewController.swift
//  TripPlanner
//
//  Created by Hunter on 11/3/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    
    @IBOutlet weak var imageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var centeringFrameBottomConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func emailFieldNextButtonPressed(sender: AnyObject){
        passwordField.becomeFirstResponder()
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject){
        UserModel.login(onUserLogin, onInvalidCredentials: onInvalidCredentials, onUnknownError: onUnknownError, email: emailField.text!, password: passwordField.text!)
    }
    
    func onUserLogin(user: UserModel){
        print(user)
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("transitionFromLogin", sender: nil)
        })
    }
    
    func onInvalidCredentials(){
        print("invalid credentials")
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject){
        UserModel.create(onUserSignup, onEmailTaken: onEmailTaken, onUnknownError: onUnknownError, email: emailField.text!, password: passwordField.text!)
    }
    
    func onUserSignup(user: UserModel){
        print(user)
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("transitionFromLogin", sender: nil)
        })
    }
    
    func onEmailTaken(){
        print("email taken")
    }
    
    func onUnknownError(){
        print("unknown error")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        roundField(emailField, radius: 4)
        roundField(passwordField, radius: 4)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    func roundField(field: UITextField, radius: CGFloat){
        field.layer.cornerRadius = radius;
        field.clipsToBounds = true;
    }
    
    func keyboardWillShow(notification: NSNotification){
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            animateKeyboardView(notification, size:endFrame?.size.height ?? 0.0)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        animateKeyboardView(notification, size:0)
    }
    
    func animateKeyboardView(notification: NSNotification, size: CGFloat) {
        if let userInfo = notification.userInfo {
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            imageBottomConstraint?.constant = size/2.9
            centeringFrameBottomConstrain?.constant = size
            UIView.animateWithDuration(duration,
                delay: NSTimeInterval(0),
                options: animationCurve,
                animations: { self.view.layoutIfNeeded() },
                completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

}