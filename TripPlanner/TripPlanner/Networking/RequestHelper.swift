//
//  RequestHelper.swift
//  TripPlanner
//
//  Created by Hunter on 11/2/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import Foundation


class RequestHelper {
    
    class func get(
        onResponseSuccess: (json: NSDictionary) -> (),
        onJSONParsingError: (jsonStr: String?) -> (),
        onResponseFailure: (code: Int) -> (),
        url: String,
        headers: Dictionary<String, String>?
    ){
        return globalRequest(
            onResponseSuccess,
            onJSONParsingError: onJSONParsingError,
            onResponseFailure: onResponseFailure,
            method: "GET",
            url: url,
            body: nil,
            headers: headers
        )
    }
    
    class func post(
        onResponseSuccess: (json: NSDictionary) -> (),
        onJSONParsingError: (jsonStr: String?) -> (),
        onResponseFailure: (code: Int) -> (),
        url: String,
        body: Dictionary<String, String>?,
        headers: Dictionary<String, String>?
    ){
        return globalRequest(
            onResponseSuccess,
            onJSONParsingError: onJSONParsingError,
            onResponseFailure: onResponseFailure,
            method: "POST",
            url: url,
            body: body,
            headers: headers
        )
    }
    
    private class func globalRequest(
        onResponseSuccess: (json: NSDictionary) -> (),
        onJSONParsingError: (jsonStr: String?) -> (),
        onResponseFailure: (code: Int) -> (),
        method: String,
        url: String,
        var body: Dictionary<String, String>?,
        headers: Dictionary<String, String>?
    ){
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if method != "GET" {
            if body == nil { body = Dictionary<String, String>() }
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(body!, options: [])
        }
        
        let task = session.dataTaskWithRequest(request) {(data: NSData?, response: NSURLResponse?, error: NSError?) in
            guard data != nil else {
                print("no data found: \(error)")
                return
            }
            
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    let status = (response as! NSHTTPURLResponse).statusCode
                    if status == 200 {
                        onResponseSuccess(json: json)
                    }else{
                        onResponseFailure(code: status)
                    }
                } else {
                    // No error thrown, but not NSDictionary
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String
                    onJSONParsingError(jsonStr: jsonStr)
                }
            } catch {
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String
                onJSONParsingError(jsonStr: jsonStr)
            }
        }
        
        task.resume()
    }
    
}