//
//  Constants.swift
//  Vaishnavaseva
//
//  Created by Roman Slysh on 10/20/15.
//  Copyright © 2015 007. All rights reserved.
//

import Foundation

struct Constants {
  /// This is the base URL for your requests.
  static let siteURL = "https://vaishnavaseva.net"
  static let baseURL = NSURL(string: "\(siteURL)/vs-api/v1/sadhana/")!
  static let authTokenURL = "\(siteURL)/?oauth=token"
  static let default_avatar_url = "/wp-content/themes/salient-child/img/default_avatar.gif"
  static let clientId = "IXndKqmEoXPTwu46f7nmTcoJ2CfIS6"
  static let clientSecret = "1A4oOPOatd8j6EOaL3i9pblOUnqa6j"
  static let grantTypePassword = "password"
  static let grantTypeRefreshToken = "refresh_token"
}
