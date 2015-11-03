//
//  BasicAuth.swift
//  TripPlanner
//
//  Created by Hunter on 11/2/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import Foundation


class BasicAuthString {
    
    let username: String
    let password: String
    
    init (username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    func getAuthString() -> String {
        let userPasswordString = "\(username):\(password)"
        let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        return "Basic \(base64EncodedCredential)"
    }
    
    func formHeader() -> Dictionary<String, String> {
        var headers = Dictionary<String, String>()
        headers["Authorization"] = getAuthString()
        return headers
    }
    
}