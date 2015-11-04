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
    
    init (authString: String) {
        let base64 = authString.characters.split{$0 == " "}.map(String.init)[1]
        let decodedData = NSData(base64EncodedString: base64, options: NSDataBase64DecodingOptions(rawValue: 0))
        let decodedString = NSString(data: decodedData!, encoding: NSUTF8StringEncoding)
        let userpass = (decodedString as! String).characters.split{$0 == ":"}.map(String.init)
        username = userpass[0]
        password = userpass[1]
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