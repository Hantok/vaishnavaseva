//
//  NSURLRequest+Vaishnavaseva.swift
//  Networking

import Foundation

extension NSURLRequest {
    
    /// Helper for making a URL request. This is to be used internally by the string extension
    /// in vaishnavaseva, not by the rest of your app.
    /// JSON encodes parameters if any are provided. You may want to change this if your server uses, say, XML.
    /// Adds any headers specific to only this request too if provided. Any headers you use all the time should be in
    /// NSURLSessionConfiguration.vaishnavasevaSessionConfiguration.
    /// You may want to extend this if your requests need any further customising, eg timeouts etc.
    class func requestWithURL(URL: NSURL, method: String, queryParameters: [String: String]?, bodyParameters: NSDictionary?, headers: [String: String]?) -> NSURLRequest {

        // If there's a querystring, append it to the URL.
        let actualURL: NSURL
        if let queryParameters = queryParameters {
            let components = NSURLComponents(URL: URL, resolvingAgainstBaseURL: true)!
            if #available(iOS 8.0, *) {
                components.queryItems = queryParameters.map { (key, value) in NSURLQueryItem(name: key, value: value) }
            } else {
                // Fallback on earlier versions
            }
            actualURL = components.URL!
        } else {
            actualURL = URL
        }
        
        // Make the request for the given method.
        let request = NSMutableURLRequest(URL: actualURL)
        request.HTTPMethod = method
        
        // Add any body JSON params (for POSTs).
        if let bodyParameters = bodyParameters {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(bodyParameters, options: [])
        }
        
        // Add any extra headers if given.
        if let headers = headers {
            for (field, value) in headers {
                request.addValue(value, forHTTPHeaderField: field)
            }
        }
        
        return request
    }
    
}
