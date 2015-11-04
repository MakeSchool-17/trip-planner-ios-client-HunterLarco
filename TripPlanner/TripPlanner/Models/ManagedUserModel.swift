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
        let users = DBManager.getUsers()
        if users.count == 0 { return nil }
        let firstuser = users[0]
        let authString = firstuser.valueForKey("authstring") as! String
        let basicAuth = BasicAuthString(authString: authString)
        return ManagedUserModel(basicAuth: basicAuth)
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
                DBManager.save(user)
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
        
    }
    
    init(basicAuth: BasicAuthString) {
        user = UserModel(basicAuth: basicAuth)
    }
    
}