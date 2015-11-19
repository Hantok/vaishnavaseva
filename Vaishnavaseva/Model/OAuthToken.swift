//
//  OAuthToken.swift
//  Vaishnavaseva
//
//  Created by Roman Slysh on 11/19/15.
//  Copyright © 2015 007. All rights reserved.
//

import Foundation

public struct OAuthToken {
  var accessToken: String
  var expiresIn: Int
  var tokenType: String
  var scope: String
  var refreshToken: String
  
  init(accessToken: String, expiresIn: Int, tokenType: String, scope: String, refreshToken: String) {
    self.accessToken = accessToken
    self.expiresIn = expiresIn
    self.tokenType = tokenType
    self.scope = scope
    self.refreshToken = refreshToken
  }
  
  init(dict: NSDictionary) {
    accessToken = dict["access_token"] as! String
    expiresIn = dict["expires_in"] as! Int
    tokenType = dict["token_type"] as! String
    scope = dict["scope"] as! String
    refreshToken = dict["refresh_token"] as! String
  }
}