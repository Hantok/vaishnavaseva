import UIKit

@objc class AppControllerStateGeneralSadhana: AppControllerState
  {
//  override func isEqualTo(other: EquatableBase) -> Bool
//    {
//    let otherDynamic = other as! AppControllerStateFirst
//    return  super.isEqualTo(other) &&
//            self.state == otherDynamic.state
//    }
    override func sceneDidBecomeCurrent() {
        super.sceneDidBecomeCurrent()
        self.viewController.setAction(Selector("allSadhanaEntries"), forTarget: self, forStateViewEvent: allSadhanaEntriesStateViewEvent)
    }
    
    func allSadhanaEntries() {
      let pageNum = (self.viewController as! GeneralSadhanaViewController).pageNum
      let itemPerPage = (self.viewController as! GeneralSadhanaViewController).itemsPerPage
      "allSadhanaEntries".post(["page_num": "\(pageNum)", "items_per_page":"\(itemPerPage)"]) { response in
            print(response.responseJSON)
            MBProgressHUD.hideAllHUDsForView((self.viewController as! GeneralSadhanaViewController).navigationController?.view, animated: true)
            var json = JSON(response.responseJSON!)
            switch json.object {
            case _ as NSDictionary:
                let keys = (json.object as! NSDictionary).allKeys
                var success = false
                for key in keys {
                    if key as! String == "entries"
                    {
                      if ((self.viewController as! GeneralSadhanaViewController).json != JSON.null && pageNum != 0)
                      {
                        (self.viewController as! GeneralSadhanaViewController).json.arrayObject?.appendContentsOf((json[key as! String].arrayObject!))
                      }
                      else
                      {
                        (self.viewController as! GeneralSadhanaViewController).sections = []
                        (self.viewController as! GeneralSadhanaViewController).json = json[key as! String]
                      }
                      success = true
                    }
                    else if key as! String == "total_found"
                    {
                      (self.viewController as! GeneralSadhanaViewController).totalFound = Int(json[key as! String].string!)!
                    }
                }
                if !success {
                    (self.viewController as! GeneralSadhanaViewController).showErrorAlert()
                }
            default:
                (self.viewController as! GeneralSadhanaViewController).showErrorAlert()
            }
            (self.viewController as! GeneralSadhanaViewController).tableView.reloadData()
        }
    }
  }
