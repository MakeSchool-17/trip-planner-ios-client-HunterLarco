//
//  TripDetailViewController.swift
//  TripPlanner
//
//  Created by Hunter on 10/28/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import UIKit

class AddTripViewController: UIViewController {
    
    @IBOutlet weak var tripForm: AddTripView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tripForm.delegate = self
    }
    
    private func showAlert(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        dispatch_async(dispatch_get_main_queue(),{
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
}

extension AddTripViewController: AddTripViewDelegate {
    
    func formSubmitted(tripView: AddTripView, text: String) {
        ManagedTripModel.create(onTripCreated, onUnknownError: onUnknownError, author: ManagedUserModel.getCurrentUser()!.user, name: text)
    }
    
    private func onTripCreated(trip: TripModel){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onUnknownError() {
        showAlert("Oh No! We're sorry, an unknown error occured. Please try whatever you were doing again.", title: "Unknown Error")
    }
    
    func formCanceled(){
        dismissViewControllerAnimated(true, completion: nil)
    }

}