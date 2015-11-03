//
//  TripDetailViewController.swift
//  TripPlanner
//
//  Created by Hunter on 10/28/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import UIKit

class TripDetailViewController: UIViewController {
    
    @IBOutlet weak var tripForm: AddTripView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tripForm.delegate = self
    }
    
}

extension TripDetailViewController: TripViewDelegate {
    
    func formSubmitted(tripView: AddTripView, text: String) {
        let authToken = BasicAuthString(username: "jane@doe.com", password: "secrestpassword")
        let user = UserModel(basicAuth: authToken)
        
        user.getTrips(onTripsResponse, onJSONParsingError: onJSONParsingError, onResponseFailure: onTripsFailure)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onTripsResponse(json: NSDictionary) {
        print("trips recieved")
    }
    
    func onJSONParsingError(jsonStr: String?) {
        print("json parsing error: \(jsonStr)")
    }
    
    func onTripsFailure(code: Int) {
        print("grab trips error")
    }
    
    func formCanceled(){
        dismissViewControllerAnimated(true, completion: nil)
    }

}