//
//  NSURLSessionConfiguration+Vaishnavaseva.swift
//  Networking

import Foundation

extension NSURLSessionConfiguration {
    
    /// Just like defaultSessionConfiguration, returns a newly created session configuration object, customised
    /// from the default to your requirements.
    class func vaishnavasevaSessionConfiguration() -> NSURLSessionConfiguration {
        let config = defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 20 // Make things timeout quickly.
        config.HTTPAdditionalHeaders = ["MyResponseType": "JSON"] // My web service needs to be explicitly asked for JSON.
        config.HTTPShouldUsePipelining = true // Might speed things up if your server supports it.
        return config
    }
}
