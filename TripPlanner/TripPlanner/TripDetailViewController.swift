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
        var body = Dictionary<String, String>()
        body["name"] = "My iOS Trip"
        body["author"] = "testauthor"
        
        var headers = Dictionary<String, String>()
        headers["Authorization"] = BasicAuthString(username: "jane@doe.com", password: "secretpassword").getAuthString()
        
        RequestHelper.post(self, url: "http://localhost:8080/trips/", body:body, headers:headers)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func formCanceled(){
        dismissViewControllerAnimated(true, completion: nil)
    }

}

extension TripDetailViewController: RequestHelperResponseParser {
    
    func onJSONParsingError(jsonStr: String?){
        print("Server replied with invalid JSON '\(jsonStr)'")
    }
    func onResponseFailure(code: Int) {
        print("failure")
        print(code)
    }
    func onResponseSuccess(json: NSDictionary) {
        print("success")
        print(json)
    }
    
}