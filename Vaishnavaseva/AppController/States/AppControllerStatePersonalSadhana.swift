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
    let year = components.year
    let month = components.month
    
    //need to be finishing when tableView will be done
//    if month - 1 == 0
//    {
//      month = 1
//      --year
//    }
    
    "userSadhanaEntries/\(userId)".post(["year": "\(year)", "month": "\(month)"]) { response in
      //print(response.responseJSON)
      MBProgressHUD.hideAllHUDsForView(self.viewController.navigationController?.view, animated: true)
      let jsonTableViewController = self.viewControllerProtocol as! JSONTableViewController
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
              if (jsonTableViewController.json != JSON.null /*&& pageNum != 0*/)
                {
                jsonTableViewController.json.arrayObject?.appendContentsOf((json[key as! String].arrayObject!))
                }
              else
                {
                jsonTableViewController.sections = []
                jsonTableViewController.json = json[key as! String]
                }
              success = true
              }
            }
          if !success
            {
            self.viewController.showErrorAlert()
            }
        default:
          self.viewController.showErrorAlert()
        }
      jsonTableViewController.sections = jsonTableViewController.sections.reverse()
      personalSadhanaViewController.tableView.reloadData()
    }
  }
}

