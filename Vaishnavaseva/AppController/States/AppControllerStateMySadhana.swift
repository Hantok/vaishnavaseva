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
    let components = calendar.components([.Year, .Month], fromDate: date)
    var year = components.year
    var month = components.month + mySadhanaViewController.month //mySadhanaViewController <= 0
    
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
              mySadhanaViewController.totalFound = 0
              mySadhanaViewController.tableView.infiniteScrollingView.enabled = false
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
              mySadhanaViewController.json = JSON.init(json[key as! String].arrayObject!.reverse())
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
}