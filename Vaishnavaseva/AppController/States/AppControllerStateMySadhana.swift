import UIKit

@objc class AppControllerStateMySadhana: AppControllerState
  {
//  override func isEqualTo(other: EquatableBase) -> Bool
//    {
//    let otherDynamic = other as! AppControllerStateSecond
//    return  super.isEqualTo(other) &&
//            self.state == otherDynamic.state
//    }
  override func sceneDidBecomeCurrent() {
    super.sceneDidBecomeCurrent()
    self.viewControllerProtocol.setAction(Selector("userSadhanaEntries"), forTarget: self, forStateViewEvent: (self.viewController as! MySadhanaViewController).mySadhanaEntriesStateViewEvent)
  }
  
  func userSadhanaEntries() {
    let mySadhanaViewController = self.viewController as! MySadhanaViewController
    let userId = mySadhanaViewController.me["userid"].stringValue
    
    let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components([.Year, .Month, .Day], fromDate: date)
    var year = components.year
    var month = components.month + mySadhanaViewController.month //mySadhanaViewController <= 0
    let today = components.day
    
    //year check change
    while month < 0
    {
      month = 12 + month
      if month == 0
      {
        month = 12
        --year
        break
      }
      else if month < 0
      {
        --year
      }
    }
    
    "userSadhanaEntries/\(userId)".post(["year": "\(year)", "month": "\(month)"]) { response in
      //print(response.responseJSON)
      MBProgressHUD.hideAllHUDsForView(self.viewController.navigationController?.view, animated: true)
      if (response.data == nil){
        self.viewController.showErrorAlert("Server error")
        mySadhanaViewController.tableView.infiniteScrollingView.stopAnimating()
        mySadhanaViewController.isBeforeResponseSucsess = false
        return
      }
      var json = JSON(response.responseJSON!)
      
      switch json.object
      {
      case _ as NSDictionary:
        let keys = (json.object as! NSDictionary).allKeys
        var success = false
        for key in keys
        {
          if key as! String == "entries"
          {
            if json[key as! String].arrayObject!.count == 0
            {
              mySadhanaViewController.json = JSON.init(self.addEmptyValues(JSON.init([]), today: today).arrayObject!.reverse())
              mySadhanaViewController.totalFound = 0
              mySadhanaViewController.tableView.infiniteScrollingView.enabled = false
              mySadhanaViewController.tableView.reloadData()
              success = true
              break
            }
            if (mySadhanaViewController.json != JSON.null)
            {
              var paths: Array<NSIndexPath> = []
              let countOfNewItems = json[key as! String].arrayObject!.count
              let countOfCurrentItems = mySadhanaViewController.json.count
              mySadhanaViewController.tableView.beginUpdates()
              mySadhanaViewController.json.arrayObject?.appendContentsOf(json[key as! String].arrayObject!.reverse())
              for var i = 0; i < countOfNewItems; i++
              {
                paths.append(NSIndexPath.init(forRow: countOfCurrentItems+i, inSection: 0))
              }
              mySadhanaViewController.tableView.insertRowsAtIndexPaths(paths, withRowAnimation: UITableViewRowAnimation.Fade)
              mySadhanaViewController.tableView.endUpdates()
            }
            else
            {
              mySadhanaViewController.json = JSON.init(self.addEmptyValues(json[key as! String], today: today).arrayObject!.reverse())
              mySadhanaViewController.tableView.reloadData()
            }
            success = true
            mySadhanaViewController.isBeforeResponseSucsess = true
          }
        }
        if !success
        {
          mySadhanaViewController.isBeforeResponseSucsess = false
          self.viewController.showErrorAlert("Server error")
        }
      default:
        self.viewController.showErrorAlert("Server error")
        mySadhanaViewController.isBeforeResponseSucsess = false
      }
      mySadhanaViewController.tableView.infiniteScrollingView.stopAnimating()
    }
  }
  
  /* 
    addEmptyValues method adds new elements to the array dataSource if needed
  */
  private func addEmptyValues(json: JSON, today: Int) -> JSON
  {
    let dateFormat: NSDateFormatter = NSDateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd"
    var startDate = NSDate().dateByAddingTimeInterval(NSTimeInterval.init(NSTimeZone.systemTimeZone().secondsFromGMT))
    var addNewCellToTableView = false
    if json.count == 0
    {
      let calendar = NSCalendar.currentCalendar()
      let components = calendar.components([.Year, .Month, .Day], fromDate: NSDate())
      
      components.day = 1
      startDate = calendar.dateFromComponents(components)!
      addNewCellToTableView = true
    }
    else
    {
      let lastObject = json.count - 1
      let tempDate = json.arrayObject?[lastObject]["date"] as! String
      
      //if today data already in DB, do change json
      addNewCellToTableView = startDate != dateFormat.dateFromString(tempDate)! ? false : true
    }
    
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components([.Year, .Month, .Day], fromDate: startDate)
    let startDay = components.day
    
    var jsonTemp = json
    for var day = (startDay <= today && addNewCellToTableView) ? startDay : startDay + 1; day <= today; day++
    {
      var value = JSON.init(Dictionary<String, String>())
      if (jsonTemp.count != 0)
      {
        startDate = startDate.dateByAddingTimeInterval(24*60*60)
        value.dictionaryObject?.updateValue(dateFormat.stringFromDate(startDate), forKey: "date")
      }
      else
      {
        value.dictionaryObject?.updateValue(dateFormat.stringFromDate(startDate), forKey: "date")
      }
      value.dictionaryObject?.updateValue("\(day)", forKey: "day")
      value.dictionaryObject?.updateValue("-1", forKey: "id")
      value.dictionaryObject?.updateValue("0", forKey: "jcount_1000")
      value.dictionaryObject?.updateValue("0", forKey: "jcount_1800")
      value.dictionaryObject?.updateValue("0", forKey: "jcount_730")
      value.dictionaryObject?.updateValue("0", forKey: "jcount_after")
      value.dictionaryObject?.updateValue("0", forKey: "kirtan")
      value.dictionaryObject?.updateValue("0", forKey: "opt_exercise")
      value.dictionaryObject?.updateValue("0", forKey: "opt_lections")
      value.dictionaryObject?.updateValue("0", forKey: "opt_service")
      value.dictionaryObject?.updateValue("00:00", forKey: "opt_sleep")
      value.dictionaryObject?.updateValue("00:00", forKey: "opt_wake_up")
      value.dictionaryObject?.updateValue("0", forKey: "reading")
      value.dictionaryObject?.updateValue((NSUserDefaults.standardUserDefaults().valueForKey("me")?["userid"])!, forKey: "user_id")
      jsonTemp.arrayObject?.append(value.dictionaryObject!)
    }
    
    return jsonTemp
  }
}