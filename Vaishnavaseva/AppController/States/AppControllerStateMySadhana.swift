import UIKit

@objc class AppControllerStateMySadhana: AppControllerStateAbstractUserSadhana
  {
//  override func isEqualTo(other: EquatableBase) -> Bool
//    {
//    let otherDynamic = other as! AppControllerStateSecond
//    return  super.isEqualTo(other) &&
//            self.state == otherDynamic.state
//    }
  override func sceneDidBecomeCurrent() {
    super.sceneDidBecomeCurrent()
    self.viewControllerProtocol.setAction(#selector(AppControllerStateMySadhana.getAvailableMonths), forTarget: self, forStateViewEvent: mySadhanaEntriesStateViewEvent)
    self.viewControllerProtocol.setAction(#selector(AppControllerStateMySadhana.updateAcceessToken), forTarget: self, forStateViewEvent: updateAceessTokenStateViewEvent)
  }
  
  override func userSadhanaEntries(month:String) {
    let mySadhanaViewController = self.viewController as! MySadhanaViewController
    let userId = mySadhanaViewController.sadhanaUser.userId!
    let components = NSCalendar.currentCalendar().components([.Day], fromDate: NSDate())
    let today = components.day
    
    "userSadhanaEntries/\(userId)".post(["year": "\(mySadhanaViewController.year)", "month": "\(month)"]) { response in

      MBProgressHUD.hideAllHUDsForView(self.viewController.navigationController?.view, animated: true)
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      if (response.data == nil){
        self.viewController.showErrorAlert(NSLocalizedString("Server error", comment: "Alert title"))
        mySadhanaViewController.tableView.infiniteScrollingView.stopAnimating()
        mySadhanaViewController.isBeforeResponseSucsess = false
        return
      }
      if response.error?.code != nil {
        mySadhanaViewController.showErrorAlert(NSLocalizedString("No internet connection", comment: "Alert title"))
        mySadhanaViewController.tableView.infiniteScrollingView.stopAnimating()
        mySadhanaViewController.isBeforeResponseSucsess = false
        return
      }
      let dict = response.responseJSON as! NSDictionary
      let entriesDict = dict.objectForKey("entries") as! NSArray
      if entriesDict.count == 0 {
        if mySadhanaViewController.entries.count == 0 {
          mySadhanaViewController.entries = self.createEmptySadhanaEntries(today, entries: []).reverse()
        } else {
          mySadhanaViewController.tableView.infiniteScrollingView.enabled = false
        }
        mySadhanaViewController.isBeforeResponseSucsess = true
        mySadhanaViewController.tableView.infiniteScrollingView.stopAnimating()
        mySadhanaViewController.tableView.reloadData()
        return
      }
      
      let entries = Deserialiser().getArrayOfSadhanaEntry(entriesDict)
      
      //init or append array
      if mySadhanaViewController.entries.count != 0 {
        var paths: Array<NSIndexPath> = []
        let countOfNewItems = entries.count
        let countOfCurrentItems = mySadhanaViewController.entries.count
        mySadhanaViewController.tableView.beginUpdates()
        mySadhanaViewController.entries.appendContentsOf(entries.reverse())
        for i in 0 ..< countOfNewItems
        {
          paths.append(NSIndexPath.init(forRow: countOfCurrentItems+i, inSection: 0))
        }
        mySadhanaViewController.tableView.insertRowsAtIndexPaths(paths, withRowAnimation: UITableViewRowAnimation.Fade)
        mySadhanaViewController.tableView.endUpdates()
      } else {
        mySadhanaViewController.entries = self.createEmptySadhanaEntries(today, entries: entries).reverse()
        mySadhanaViewController.tableView.reloadData()
      }
      mySadhanaViewController.isBeforeResponseSucsess = true
      mySadhanaViewController.tableView.infiniteScrollingView.stopAnimating()
    }
    
    updateUserSettings()
  }
  
  /* 
    method adds new elements to the array dataSource if needed
  */
  private func createEmptySadhanaEntries(today: Int, entries: Array<SadhanaEntry>) -> Array<SadhanaEntry> {
    var date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components([.Year, .Month, .Day], fromDate: date)
    var day = 1
    var result: Array<SadhanaEntry> = []
    for sadhanaEntry in entries {
      while day < sadhanaEntry.day {
        components.day = day
        date = calendar.dateFromComponents(components)!
        date = date.dateByAddingTimeInterval(NSTimeInterval.init(NSTimeZone.systemTimeZone().secondsFromGMT))
        result.append(createEmptySadhanaEntryForDate(date))
        day += 1
      }
      result.append(sadhanaEntry)
      day += 1
    }
    
    while day <= today {
      components.day = day
      date = calendar.dateFromComponents(components)!
      date = date.dateByAddingTimeInterval(NSTimeInterval.init(NSTimeZone.systemTimeZone().secondsFromGMT))
      result.append(createEmptySadhanaEntryForDate(date))
      day += 1
    }
    
    return result
  }
  
  func createEmptySadhanaEntryForDate(date: NSDate) -> SadhanaEntry {
    let dateFormat: NSDateFormatter = NSDateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd"
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components([.Day], fromDate: date)

    var sadhanaEntry = SadhanaEntry()
    sadhanaEntry.date = dateFormat.stringFromDate(date) as String
    sadhanaEntry.day = components.day
    sadhanaEntry.id = -1
    sadhanaEntry.userId = -1
    sadhanaEntry.jCount730 = 0
    sadhanaEntry.jCount1000 = 0
    sadhanaEntry.jCount1800 = 0
    sadhanaEntry.jCountAfter = 0
    sadhanaEntry.kirtan = false
    sadhanaEntry.reading = 0
    sadhanaEntry.exerciseEnable = false
    sadhanaEntry.lectionsEnable = false
    sadhanaEntry.serviceEnable = false
    sadhanaEntry.sleepTime = "00:00"
    sadhanaEntry.wakeUpTime = "00:00"
    return sadhanaEntry
  }
  
  func updateUserSettings() {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      let dict = Locksmith.loadDataForUserAccount("OAuthToken")!
      let oAuthToken = OAuthToken(dict: dict)
      "me".get(headers: ["Authorization" : "\(oAuthToken.tokenType) \(oAuthToken.accessToken)"]) { response in
        if response.data == nil || response.HTTPResponse.statusCode != 200 {
          print("Update user settings error.")
          return
        } else {
          let dict = response.responseJSON as! NSDictionary
          (self.viewController as! MySadhanaViewController).sadhanaUser = Deserialiser().getSadhanaUser(dict)
          NSUserDefaults.standardUserDefaults().setValue(dict, forKey: "me")
        }
      }
    }
  }
  
  func updateAcceessToken() {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    let dict = Locksmith.loadDataForUserAccount("myUserAccount")
    let login = (dict?.keys.first)!
    let pass = dict?.values.first as! String
    let params = getLoginPostParams(login, password: pass, refreshToken: true)
    Constants.authTokenURL.post(params) { response in
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      MBProgressHUD.hideAllHUDsForView(self.viewController.navigationController?.view, animated: true)
      if response.data == nil {
        print("Error for connecting the server")
      } else if response.HTTPResponse.statusCode != 200 {
        let dict = response.responseJSON
        print(dict!["error_description"])
        //logout and go to login screen
        dispatch_async(dispatch_get_main_queue()) {
          self.viewController.performSegueWithIdentifier("BackFromAnyToLogin", sender: nil)
        }
      } else {
        let responseDict = response.responseJSON as! NSDictionary
        NSUserDefaults.standardUserDefaults().setObject(NSDate().timeIntervalSince1970, forKey: "lastDate")
        do {
          // update user credentials in keychain
          try Locksmith.updateData(responseDict as! [String : AnyObject], forUserAccount: "OAuthToken")
          print("Access token updeted")
        } catch {
          print(error)
        }
      }
    }
  }
}