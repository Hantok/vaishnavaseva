//
//  SadhanaEntry.swift
//  Vaishnavaseva
//
//  Created by Roman Slysh on 10/27/15.
//  Copyright © 2015 007. All rights reserved.
//

import Foundation

public struct SadhanaEntry {
  var id: Int?
  var userId: Int?
  var date: String?
  var day: Int?
  var jCount730: Int?
  var jCount1000: Int?
  var jCount1800: Int?
  var jCountAfter: Int?
  var reading: Int?
  var kirtan: Bool?
  var serviceEnable: Bool?
  var exerciseEnable: Bool?
  var lectionsEnable: Bool?
  var wakeUpTime: String?
  var sleepTime: String?
  var sadhanaUser: SadhanaUser?
}