//
//  UserModel.swift
//  TripPlanner
//
//  Created by Hunter on 11/2/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import Foundation

class UserModel {
    
    private let basicAuth: BasicAuthString
    
    class func create(
        onResponseSuccess: (json: NSDictionary) -> (),
        onJSONParsingError: (jsonStr: String?) -> (),
        onResponseFailure: (code: Int) -> (),
        email: String,
        password: String
    ) {
        var body = Dictionary<String, String>()
        body["email"] = email
        body["password"] = password
        
        RequestHelper.post(
            onResponseSuccess,
            onJSONParsingError: onJSONParsingError,
            onResponseFailure: onResponseFailure,
            url: "http://localhost:8080/trips/",
            body: body,
            headers: nil
        )
    }
    
    init (basicAuth: BasicAuthString) {
        self.basicAuth = basicAuth
    }
    
    func getTrips(
        onResponseSuccess: (json: NSDictionary) -> (),
        onJSONParsingError: (jsonStr: String?) -> (),
        onResponseFailure: (code: Int) -> ()
    ) {
        RequestHelper.get(
            onResponseSuccess,
            onJSONParsingError: onJSONParsingError,
            onResponseFailure: onResponseFailure,
            url: "http://localhost:8080/trips/",
            headers: basicAuth.formHeader()
        )
    }
    
    func getEmail() -> String {
        return basicAuth.username
    }
    
}