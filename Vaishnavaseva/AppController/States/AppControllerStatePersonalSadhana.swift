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
    self.viewControllerProtocol.setAction(Selector("userSadhanaEntries"), forTarget: self, forStateViewEvent: userSadhanaEntriesStateViewEvent)
  }

  func userSadhanaEntries() {
    let personalSadhanaViewController = self.viewController as! PersonalSadhanaViewController
    let userId = personalSadhanaViewController.sadhanaUser.userId!
    
    let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components([.Year, .Month], fromDate: date)
    var year = components.year
    var month = components.month + personalSadhanaViewController.month //personalSadhanaViewController.month <= 0
    
    //year check change
    while month < 1
    {
      --year
      month = 12 + month
    }
    
    "userSadhanaEntries/\(userId)".post(["year": "\(year)", "month": "\(month)"]) { response in
      //print(response.responseJSON)
      MBProgressHUD.hideAllHUDsForView(self.viewController.navigationController?.view, animated: true)
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      if (response.data == nil) {
        self.viewController.showErrorAlert(NSLocalizedString("Server error", comment: "Alert title"))
        personalSadhanaViewController.tableView.infiniteScrollingView.stopAnimating()
        personalSadhanaViewController.isBeforeResponseSucsess = false
        return
      }
      if response.error?.code != nil {
        personalSadhanaViewController.showErrorAlert(NSLocalizedString("No internet connection", comment: "Alert title"))
        personalSadhanaViewController.tableView.infiniteScrollingView.stopAnimating()
        personalSadhanaViewController.isBeforeResponseSucsess = false
        return
      }
      
      let dict = response.responseJSON as! NSDictionary
      let entriesDict = dict.objectForKey("entries") as! NSArray
      if entriesDict.count == 0 {
        personalSadhanaViewController.totalFound = 0
        personalSadhanaViewController.isBeforeResponseSucsess = true
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
      personalSadhanaViewController.tableView.infiniteScrollingView.stopAnimating()
    }
  }
}

