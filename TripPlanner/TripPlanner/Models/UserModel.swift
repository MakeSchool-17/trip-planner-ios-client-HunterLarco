//
//  UserModel.swift
//  TripPlanner
//
//  Created by Hunter on 11/2/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import Foundation

class UserModel {
    
    let basicAuth: BasicAuthString
    
    class func create(
        onSuccess: (user: UserModel) -> Void,
        onEmailTaken: () -> Void,
        onUnknownError: () -> Void,
        email: String,
        password: String
    ) {
        var body = Dictionary<String, String>()
        body["email"] = email
        body["password"] = password
        
        RequestErrorManager.post(
            {(json: NSDictionary) in
                // on response success
                let authString = BasicAuthString(username: email, password: password)
                onSuccess(user: UserModel(basicAuth: authString))
            },
            onUnknownError: onUnknownError,
            errorMap: [409: onEmailTaken],
            url: "http://10.0.1.68:8080/users/",
            body: body,
            headers: nil
        )
    }
    
    class func login(
        onSuccess: (user: UserModel) -> Void,
        onInvalidCredentials: () -> Void,
        onUnknownError: () -> Void,
        email: String,
        password: String
    ) {
        RequestErrorManager.get(
            {(json: NSDictionary) in
                // on response success
                let authString = BasicAuthString(username: email, password: password)
                onSuccess(user: UserModel(basicAuth: authString))
            },
            onUnknownError: onUnknownError,
            errorMap: [401: onInvalidCredentials],
            url: "http://10.0.1.68:8080/users/",
            headers: BasicAuthString(username: email, password: password).formHeader()
        )
    }
    
    init (basicAuth: BasicAuthString) {
        self.basicAuth = basicAuth
    }

}