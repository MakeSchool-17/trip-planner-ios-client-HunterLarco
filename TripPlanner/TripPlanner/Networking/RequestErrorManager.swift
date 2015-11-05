//
//  APIManager.swift
//  TripPlanner
//
//  Created by Hunter on 11/3/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import Foundation

class RequestErrorManager {
    
    class func post(
        onSuccess: (json: NSDictionary) -> Void,
        onUnknownError: () -> Void,
        errorMap: Dictionary<Int, () -> ()>?,
        url: String,
        body: Dictionary<String, String>?,
        headers: Dictionary<String, String>?
    ){
        BasicRequestManager.post(
            onSuccess,
            onJSONParsingError: {(jsonStr: String?) in onUnknownError()},
            onResponseFailure: {(code: Int) in
                if let errorMap = errorMap, let val = errorMap[code] {
                    val()
                    return
                }
                onUnknownError()
            },
            url: url,
            body: body,
            headers: headers
        )
    }
    
    class func get(
        onSuccess: (json: NSDictionary) -> Void,
        onUnknownError: () -> Void,
        errorMap: Dictionary<Int, () -> ()>?,
        url: String,
        headers: Dictionary<String, String>?
    ){
        BasicRequestManager.get(
            onSuccess,
            onJSONParsingError: {(jsonStr: String?) in onUnknownError()},
            onResponseFailure: {(code: Int) in
                if let errorMap = errorMap, let val = errorMap[code] {
                    val()
                    return
                }
                onUnknownError()
            },
            url: url,
            headers: headers
        )
    }
    
}