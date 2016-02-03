import UIKit

@objc class AppControllerStatePersonalSadhana: AppControllerState
  {
//  override func isEqualTo(other: EquatableBase) -> Bool
//    {
//    let otherDynamic = other as! AppControllerStateSecond
//    return  super.isEqualTo(other) &&
//            self.state == otherDynamic.state
//    }
  
  override func sceneDidBecomeCurrent() {
    super.sceneDidBecomeCurrent()
    self.viewControllerProtocol.setAction(Selector("getAvailableMonths"), forTarget: self, forStateViewEvent: userSadhanaEntriesStateViewEvent)
  }
  
  func getAvailableMonths() {
    let personalSadhanaViewController = self.viewController as! PersonalSadhanaViewController
    let userId = personalSadhanaViewController.sadhanaUser.userId!
    if (personalSadhanaViewController.year != 0 && personalSadhanaViewController.year < 2015) {
      personalSadhanaViewController.totalFound = 0
      personalSadhanaViewController.isBeforeResponseSucsess = true
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      personalSadhanaViewController.tableView.infiniteScrollingView.stopAnimating()
      personalSadhanaViewController.tableView.infiniteScrollingView.enabled = false
      return
    }
    
    if personalSadhanaViewController.dates[personalSadhanaViewController.year] == nil {
      "months/\(userId)/\(personalSadhanaViewController.year)".get()  { response in
        
        if (response.data == nil) {
          self.viewController.showErrorAlert(NSLocalizedString("Server error", comment: "Alert title"))
          UIApplication.sharedApplication().networkActivityIndicatorVisible = false
          personalSadhanaViewController.tableView.infiniteScrollingView.stopAnimating()
          return
        }
        if response.error?.code != nil {
          personalSadhanaViewController.showErrorAlert(NSLocalizedString("No internet connection", comment: "Alert title"))
          UIApplication.sharedApplication().networkActivityIndicatorVisible = false
          personalSadhanaViewController.tableView.infiniteScrollingView.stopAnimating()
          return
        }
        
        let months = (response.responseJSON as! NSArray).reverse()
        if (months.count == 0) {
          personalSadhanaViewController.totalFound = 0
          personalSadhanaViewController.isBeforeResponseSucsess = true
          UIApplication.sharedApplication().networkActivityIndicatorVisible = false
          personalSadhanaViewController.tableView.infiniteScrollingView.stopAnimating()
          personalSadhanaViewController.tableView.infiniteScrollingView.enabled = false
        }
        personalSadhanaViewController.dates[personalSadhanaViewController.year] = months
        self.getEntries(months)
      }
    } else {
      let months = personalSadhanaViewController.dates[personalSadhanaViewController.year]
      self.getEntries(months!)
    }
  }
  
  func getEntries(months:NSArray) {
    let personalSadhanaViewController = self.viewController as! PersonalSadhanaViewController
    if personalSadhanaViewController.monthIndex < months.count {
      self.userSadhanaEntries(months[personalSadhanaViewController.monthIndex] as! String)
    } else {
      personalSadhanaViewController.monthIndex = 0
      --personalSadhanaViewController.year
      getAvailableMonths()
    }
  }
  
  func userSadhanaEntries(month:String) {
    let personalSadhanaViewController = self.viewController as! PersonalSadhanaViewController
    let userId = personalSadhanaViewController.sadhanaUser.userId!
    
    "userSadhanaEntries/\(userId)".post(["year": "\(personalSadhanaViewController.year)", "month": "\(month)"]) { response in
      //print(response.responseJSON)
      MBProgressHUD.hideAllHUDsForView(self.viewController.navigationController?.view, animated: true)
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      if (response.data == nil) {
        self.viewController.showErrorAlert(NSLocalizedString("Server error", comment: "Alert title"))
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        personalSadhanaViewController.tableView.infiniteScrollingView.stopAnimating()
        personalSadhanaViewController.isBeforeResponseSucsess = false
        return
      }
      if response.error?.code != nil {
        personalSadhanaViewController.showErrorAlert(NSLocalizedString("No internet connection", comment: "Alert title"))
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        personalSadhanaViewController.tableView.infiniteScrollingView.stopAnimating()
        personalSadhanaViewController.isBeforeResponseSucsess = false
        return
      }
      
      let dict = response.responseJSON as! NSDictionary
      let entriesDict = dict.objectForKey("entries") as! NSArray
      if entriesDict.count == 0 {
        personalSadhanaViewController.totalFound = 0
        personalSadhanaViewController.isBeforeResponseSucsess = true
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        personalSadhanaViewController.tableView.infiniteScrollingView.stopAnimating()
        personalSadhanaViewController.tableView.infiniteScrollingView.enabled = false
        return
      }
      
      let entries = Deserialiser().getArrayOfSadhanaEntry(entriesDict)
      
      //init or append array
      if personalSadhanaViewController.entries.count != 0 {
        var paths: Array<NSIndexPath> = []
        let countOfNewItems = entries.count
        let countOfCurrentItems = personalSadhanaViewController.entries.count
        personalSadhanaViewController.tableView.beginUpdates()
        personalSadhanaViewController.entries.appendContentsOf(entries.reverse())
        for var i = 0; i < countOfNewItems; i++
        {
          paths.append(NSIndexPath.init(forRow: countOfCurrentItems+i, inSection: 0))
        }
        personalSadhanaViewController.tableView.insertRowsAtIndexPaths(paths, withRowAnimation: UITableViewRowAnimation.Fade)
        personalSadhanaViewController.tableView.endUpdates()
      } else {
        personalSadhanaViewController.entries = entries.reverse()
        personalSadhanaViewController.tableView.reloadData()
      }
      personalSadhanaViewController.isBeforeResponseSucsess = true
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      personalSadhanaViewController.tableView.infiniteScrollingView.stopAnimating()
    }
  }
}

