//
//  LoginView.swift
//  TripPlanner
//
//  Created by Hunter on 11/3/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    @IBOutlet weak var imageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var centeringFrameBottomConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    var view: UIView!
    
    var delegate: LoginViewDelegate?
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "LoginView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        roundField(emailField, radius: 4)
        roundField(passwordField, radius: 4)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        return view
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
    
    @IBAction func loginButtonpressed(sender: AnyObject) {
        delegate?.doLogin(emailField.text!, password: passwordField.text!)
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        delegate?.doSignup(emailField.text!, password: passwordField.text!)
    }
    
    func lockForm() {
        emailField.enabled = false
        passwordField.enabled = false
        loginButton.enabled = false
        signupButton.enabled = false
    }
    
    func unlockForm() {
        emailField.enabled = true
        passwordField.enabled = true
        loginButton.enabled = true
        signupButton.enabled = true
    }
    
}

protocol LoginViewDelegate {
    
    func doLogin(email: String, password: String)
    func doSignup(email: String, password: String)
    
}