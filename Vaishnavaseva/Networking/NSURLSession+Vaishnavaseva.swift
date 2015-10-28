//
//  NSURLSession+Vaishnavaseva.swift
//  Networking

import Foundation

    extension NSURLSession {
        
        /// Just like sharedSession, this returns a shared singleton session object.
        class var sharedVaishnavasevaSession: NSURLSession {
            // The session is stored in a nested struct because you can't do a 'static let' singleton in a class extension.
            struct Instance {
                /// The singleton URL session, configured to use our custom config and delegate.
                static let session = NSURLSession(
                    configuration: NSURLSessionConfiguration.vaishnavasevaSessionConfiguration(),
                    delegate: VSURLSessionDelegate(), // Delegate is retained by the session.
                    delegateQueue: NSOperationQueue.mainQueue())
            }
            return Instance.session
        }
        
        /// Just like sharedSession, this returns a shared singleton session object.
//        class var sharedVaishnavasevaAuthenticatedSession: NSURLSession {
//            // The session is stored in a nested struct because you can't do a 'static let' singleton in a class extension.
//            struct Instance {
//                /// The singleton URL session, configured to use our custom config and delegate.
//                static let session = NSURLSession(
//                    configuration: NSURLSessionConfiguration.vaishnavasevaAuthenticationSessionConfiguration(),
//                    delegate: VSURLSessionDelegate(), // Delegate is retained by the session.
//                    delegateQueue: NSOperationQueue.mainQueue())
//            }
//            return Instance.session
//        }

        
    }
