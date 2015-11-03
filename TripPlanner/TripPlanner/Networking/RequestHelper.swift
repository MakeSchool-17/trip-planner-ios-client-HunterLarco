//
//  RequestHelper.swift
//  TripPlanner
//
//  Created by Hunter on 11/2/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import Foundation


class RequestHelper {
    
    class func get(callback: RequestHelperResponseParser, url: String, headers: Dictionary<String, String>?){
        return globalRequest(callback, method: "GET", url: url, body: nil, headers: headers)
    }
    
    class func post(callback: RequestHelperResponseParser, url: String, body: Dictionary<String, String>?, headers: Dictionary<String, String>?){
        return globalRequest(callback, method: "POST", url: url, body: body, headers: headers)
    }
    
    private class func globalRequest(callback: RequestHelperResponseParser, method: String, url: String, var body: Dictionary<String, String>?, headers: Dictionary<String, String>?){
        
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
            if body == nil {
                body = Dictionary<String, String>()
            }
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
                        callback.onResponseSuccess(json)
                    }else{
                        callback.onResponseFailure(status)
                    }
                } else {
                    // No error thrown, but not NSDictionary
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String
                    callback.onJSONParsingError(jsonStr)
                }
            } catch {
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String
                callback.onJSONParsingError(jsonStr)
            }
        }
        
        task.resume()
    }
    
}


protocol RequestHelperResponseParser {
    
    func onJSONParsingError(jsonStr: String?)
    func onResponseFailure(code: Int)
    func onResponseSuccess(json: NSDictionary)
    
}