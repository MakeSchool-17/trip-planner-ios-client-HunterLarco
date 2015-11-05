//
//  TripModel.swift
//  TripPlanner
//
//  Created by Hunter on 11/2/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import Foundation

class TripModel {
    
    let id: String
    let name: String
    let author: UserModel
    
    class func getTrips(
        onSuccess: (trips: [TripModel]) -> Void,
        onUnknownError: () -> Void,
        author: UserModel
    ) {
        RequestErrorManager.get(
            {(json: NSDictionary) in
                var result = [TripModel]()
                let rawlist = json["trips"] as! NSArray
                for rawtrip in rawlist {
                    let name = rawtrip["name"] as! String
                    let id = rawtrip["id"] as! String
                    result.append(TripModel(id: id, name: name, author: author))
                }
                onSuccess(trips: result)
            },
            onUnknownError: onUnknownError,
            errorMap: nil,
            url: "http://10.0.1.68:8080/trips/",
            headers: author.basicAuth.formHeader()
        )
    }
    
    class func create(
        onSuccess: (trip: TripModel) -> Void,
        onUnknownError: () -> Void,
        author: UserModel,
        name: String
    ) {
        var body = Dictionary<String, String>()
        body["name"] = name
        
        RequestErrorManager.post(
            {(json: NSDictionary) in
                // on response success
                let id = json["id"] as! String
                let name = json["name"] as! String
                onSuccess(trip: TripModel(id: id, name: name, author: author))
            },
            onUnknownError: onUnknownError,
            errorMap: nil,
            url: "http://10.0.1.68:8080/trips/",
            body: body,
            headers: author.basicAuth.formHeader()
        )
    }
    
    init(id: String, name: String, author: UserModel){
        self.id = id
        self.name = name
        self.author = author
    }
    
}