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
    let userId = (personalSadhanaViewController.person["user"])["userid"]
    
    let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components([.Year, .Month], fromDate: date)
    var year = components.year
    var month = components.month + personalSadhanaViewController.month //personalSadhanaViewController.month <= 0
    
    //need to be finishing when tableView will be done
    if month == 0
    {
      month = 12
      --year
    }
    
    "userSadhanaEntries/\(userId)".post(["year": "\(year)", "month": "\(month)"]) { response in
      //print(response.responseJSON)
      MBProgressHUD.hideAllHUDsForView(self.viewController.navigationController?.view, animated: true)
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
                personalSadhanaViewController.totalFound = 0
                personalSadhanaViewController.tableView.infiniteScrollingView.enabled = false
                success = true
                break
              }
              if (personalSadhanaViewController.json != JSON.null)
              {
                var paths: Array<NSIndexPath> = []
                let countOfNewItems = json[key as! String].arrayObject!.count
                let countOfCurrentItems = personalSadhanaViewController.json.count
                personalSadhanaViewController.tableView.beginUpdates()
                personalSadhanaViewController.json.arrayObject?.appendContentsOf(json[key as! String].arrayObject!.reverse())
                for var i = 0; i < countOfNewItems; i++
                {
                  paths.append(NSIndexPath.init(forRow: countOfCurrentItems+i, inSection: 0))
                }
                personalSadhanaViewController.tableView.insertRowsAtIndexPaths(paths, withRowAnimation: UITableViewRowAnimation.Fade)
                personalSadhanaViewController.tableView.endUpdates()
              }
              else 
              {
                personalSadhanaViewController.json = JSON.init(json[key as! String].arrayObject!.reverse())
                personalSadhanaViewController.tableView.reloadData()
              }
              success = true
            }
          }
          if !success
          {
            self.viewController.showErrorAlert("Server error")
          }
        default:
          self.viewController.showErrorAlert("Server error")
        }
      personalSadhanaViewController.tableView.infiniteScrollingView.stopAnimating()
    }
  }
}

