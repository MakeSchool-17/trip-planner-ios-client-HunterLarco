//
//  ManagedUserModel.swift
//  TripPlanner
//
//  Created by Hunter on 11/3/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import Foundation

class ManagedUserModel {
    
    let user: UserModel
    
    class func getCurrentUser() -> ManagedUserModel? {
        if let authString = getUserAuthString() {
            let basicAuth = BasicAuthString(authString: authString)
            return ManagedUserModel(basicAuth: basicAuth)
        }
        return nil
    }
    
    class func create(
        onSuccess: (user: UserModel) -> Void,
        onEmailTaken: () -> Void,
        onUnknownError: () -> Void,
        email: String,
        password: String
    ) {
        UserModel.create(
            {(user: UserModel) in
                setUserAuthString(user)
                onSuccess(user: user)
            },
            onEmailTaken: onEmailTaken,
            onUnknownError: onUnknownError,
            email: email,
            password: password
        )
    }
    
    class func login(
        onSuccess: (user: UserModel) -> Void,
        onInvalidCredentials: () -> Void,
        onUnknownError: () -> Void,
        email: String,
        password: String
    ) {
        UserModel.login(
            {(user: UserModel) in
                setUserAuthString(user)
                onSuccess(user: user)
            },
            onInvalidCredentials: onInvalidCredentials,
            onUnknownError: onUnknownError,
            email: email,
            password: password
        )
    }
    
    init(basicAuth: BasicAuthString) {
        user = UserModel(basicAuth: basicAuth)
    }
    
    private class func getUserAuthString() -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.stringForKey("userAuthString")
    }
    
    private class func setUserAuthString(user: UserModel) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(user.basicAuth.getAuthString(), forKey: "userAuthString")
    }
    
}