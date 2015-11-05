//
//  TripView.swift
//  TripPlanner
//
//  Created by Hunter on 10/28/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import UIKit

protocol AddTripViewDelegate {
    
    func formSubmitted(tripView: AddTripView, text: String)
    func formCanceled()
    
}

class AddTripView: UIView {
    
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var centeredViewConstraint: NSLayoutConstraint!
    
    var delegate: AddTripViewDelegate?
    
    var view: UIView!
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        textField.resignFirstResponder()
        delegate?.formSubmitted(self, text: textField.text!)
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        textField.resignFirstResponder()
        delegate?.formCanceled()
    }
    
    @IBAction func textFieldSubmitted(sender: AnyObject) {
        textField.resignFirstResponder()
        delegate?.formSubmitted(self, text: textField.text!)
    }
    
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
        let nib = UINib(nibName: "AddTripView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

        hideNavBarBackground()

        return view
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    func hideNavBarBackground(){
        navbar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navbar.shadowImage = UIImage()
        navbar.translucent = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
    func keyboardWillShow(notification: NSNotification){
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            animateKeyboardView(notification, size:(endFrame?.size.height ?? 0.0)/2)
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
            bottomConstraint?.constant = size
            UIView.animateWithDuration(duration,
                delay: NSTimeInterval(0),
                options: animationCurve,
                animations: { self.view.layoutIfNeeded() },
                completion: nil)
        }
    }
    
    
}