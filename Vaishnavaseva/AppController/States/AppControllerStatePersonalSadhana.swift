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
            if ((self.viewController as! PersonalSadhanaViewController).json != JSON.null /*&& pageNum != 0*/)
            {
              (self.viewController as! PersonalSadhanaViewController).json.arrayObject?.appendContentsOf((json[key as! String].arrayObject!))
            }
            else
            {
              (self.viewController as! PersonalSadhanaViewController).sections = []
              (self.viewController as! PersonalSadhanaViewController).json = json[key as! String]
            }
            success = true
          }
        }
        if !success {
          (self.viewController as! PersonalSadhanaViewController).showErrorAlert()
        }
      default:
        (self.viewController as! PersonalSadhanaViewController).showErrorAlert()
      }
      //(self.viewController as! PersonalSadhanaViewController).tableView.reloadData()
    }
  }
}

