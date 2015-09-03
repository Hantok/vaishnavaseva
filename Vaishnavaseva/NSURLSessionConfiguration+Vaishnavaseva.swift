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
        
        //need to check
        let creadentials = Locksmith.loadDataForUserAccount("myUserAccount")
        if (creadentials != nil)
        {
            let login = creadentials!.allKeys[0].description
            let password = creadentials!.objectForKey(login)!.description
            let userPasswordString = login + ":" + password
            let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
            let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            let authString = "Basic \(base64EncodedCredential)"
            config.HTTPAdditionalHeaders = ["Authorization" : authString]
        }
        else
        {
            print("User not authorised!")
        }
        
        return config
    }
}
