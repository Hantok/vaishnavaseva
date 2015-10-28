//
//  Deserializer.swift
//  Vaishnavaseva
//
//  Created by Roman Slysh on 10/27/15.
//  Copyright © 2015 007. All rights reserved.
//

import Foundation

class Deserialiser {
  
  private func getSadhanaEntry(dictionary: NSDictionary, callback: (SadhanaEntry) -> ()) {
    var sadhanaEntry = SadhanaEntry()
    
    sadhanaEntry.id = dictionary.objectForKey("id")?.integerValue
    sadhanaEntry.userId = dictionary.objectForKey("user_id")?.integerValue
    sadhanaEntry.date = dictionary.objectForKey("date") as? String
    sadhanaEntry.day = dictionary.objectForKey("day")?.integerValue
    sadhanaEntry.jCount730 = dictionary.objectForKey("jcount_730")?.integerValue
    sadhanaEntry.jCount1000 = dictionary.objectForKey("jcount_1000")?.integerValue
    sadhanaEntry.jCount1800 = dictionary.objectForKey("jcount_1800")?.integerValue
    sadhanaEntry.jCountAfter = dictionary.objectForKey("jcount_after")?.integerValue
    sadhanaEntry.reading = dictionary.objectForKey("reading")?.integerValue
    sadhanaEntry.kirtan = dictionary.objectForKey("kirtan")?.boolValue
    sadhanaEntry.sleepTime = dictionary.objectForKey("opt_sleep") as? String
    sadhanaEntry.wakeUpTime = dictionary.objectForKey("opt_wake_up") as? String
    sadhanaEntry.exerciseEnable = dictionary.objectForKey("opt_exercise")?.boolValue
    sadhanaEntry.serviceEnable = dictionary.objectForKey("opt_service")?.boolValue
    sadhanaEntry.lectionsEnable = dictionary.objectForKey("opt_lections")?.boolValue
    sadhanaEntry.sadhanaUser = dictionary.objectForKey("user") != nil ? getSadhanaUser(dictionary["user"] as! NSDictionary) : nil
    
    callback(sadhanaEntry)
  }
  
  func getSadhanaUser(dictionary: NSDictionary) -> SadhanaUser {
    var sadhanaUser = SadhanaUser()
    
    sadhanaUser.userId = dictionary.objectForKey("userid")?.integerValue
    sadhanaUser.userName = dictionary.objectForKey("user_name") as? String
    sadhanaUser.userNickname = dictionary.objectForKey("user_nicename") as? String
    sadhanaUser.isPublic = dictionary.objectForKey("cfg_public")?.boolValue
    sadhanaUser.showMore16 = dictionary.objectForKey("cfg_showmoresixteen")?.boolValue
    sadhanaUser.wakeUpEnable = dictionary.objectForKey("opt_wake")?.boolValue
    sadhanaUser.serviceEnable = dictionary.objectForKey("opt_service")?.boolValue
    sadhanaUser.exerciseEnable = dictionary.objectForKey("opt_exercise")?.boolValue
    sadhanaUser.lectionsEnable = dictionary.objectForKey("opt_lections")?.boolValue
    sadhanaUser.sleepEnable = dictionary.objectForKey("opt_sleep")?.boolValue
    sadhanaUser.avatarUrl = dictionary.objectForKey("avatar_url") as? String
    return sadhanaUser
  }
  
  func getArrayOfSadhanaEntry(array: NSArray) -> Array<SadhanaEntry> {
    var result = [SadhanaEntry]()
    for dict in array {
      getSadhanaEntry(dict as! NSDictionary) {newSadhanaEntry in
        result.append(newSadhanaEntry)
      }
    }
    return result
  }

}
