//
//  AddTripView.swift
//  TripPlanner
//
//  Created by Hunter on 10/13/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import UIKit
import CoreData

class AddTripView: UIViewController {

    @IBOutlet weak var input: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    @IBAction func addPressed(sender: UIBarButtonItem) {
        submitForm()
    }
    
    @IBAction func keyboardPressedGo(sender: AnyObject) {
        submitForm()
    }
    
    func submitForm(){
        let inputText = input.text!
        if inputText.isEmpty {
            handleEmptyText()
        }else{
            createTrip(inputText)
        }
    }
    
    func createTrip(inputText: String){
        print("Add Trip To Request Queue: " + inputText)
        
        input.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleEmptyText(){
        let alert = UIAlertController(title: "Friendly Reminder", message: "You must specify a trip name", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        input.resignFirstResponder()
    }

}