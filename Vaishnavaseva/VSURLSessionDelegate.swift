//
//  VSURLSessionDelegate.swift
//  Networking

import Foundation

class VSURLSessionDelegate: NSObject, NSURLSessionDelegate {
    
    // MARK: - NSURLSessionDelegate

    func URLSession(session: NSURLSession,
        didReceiveChallenge challenge: NSURLAuthenticationChallenge,
        completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
     
        // For example, you may want to override this to accept some self-signed certs here.
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            // Allow the self-signed cert.
            let credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
            completionHandler(.UseCredential, credential)
        } else {
            // You *have* to call completionHandler either way, so call it to do the default action.
            completionHandler(.PerformDefaultHandling, nil)
        }
    }
}