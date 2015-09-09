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
    self.viewController.setAction(Selector("userSadhanaEntries"), forTarget: self, forStateViewEvent: userSadhanaEntriesStateViewEvent)
  }

  func userSadhanaEntries() {
    let userId = ((self.viewController as! PersonalSadhanaViewController).person["user"])["userid"]
    
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
      print(response.responseJSON)
      MBProgressHUD.hideAllHUDsForView((self.viewController as! PersonalSadhanaViewController).navigationController?.view, animated: true)
      var json = JSON(response.responseJSON!)
      switch json.object {
      case _ as NSDictionary:
        let keys = (json.object as! NSDictionary).allKeys
        var success = false
        for key in keys {
          if key as! String == "entries"
          {
            if (self.viewController.json != JSON.null /*&& pageNum != 0*/)
            {
              self.viewController.json.arrayObject?.appendContentsOf((json[key as! String].arrayObject!))
            }
            else
            {
              self.viewController.sections = []
              self.viewController.json = json[key as! String]
            }
            success = true
          }
        }
        if !success {
          self.viewController.showErrorAlert()
        }
      default:
        self.viewController.showErrorAlert()
      }
      self.viewController.sections = self.viewController.sections.reverse()
      (self.viewController as! PersonalSadhanaViewController).tableView.reloadData()
    }
  }
}

