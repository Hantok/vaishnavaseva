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
        self.viewControllerProtocol.setAction(Selector("allSadhanaEntries"), forTarget: self, forStateViewEvent: allSadhanaEntriesStateViewEvent)
    }
    
    func allSadhanaEntries() {
      let generalSadhanaViewController = self.viewController as! GeneralSadhanaViewController
      let pageNum = generalSadhanaViewController.pageNum
      let itemPerPage = generalSadhanaViewController.itemsPerPage
      "allSadhanaEntries".post(["page_num": "\(pageNum)", "items_per_page":"\(itemPerPage)"]) { response in
            //print(response.responseJSON)
            MBProgressHUD.hideAllHUDsForView(self.viewController.navigationController?.view, animated: true)
            var json = JSON(response.responseJSON!)
            switch json.object {
            case _ as NSDictionary:
                let keys = (json.object as! NSDictionary).allKeys
                var success = false
                for key in keys {
                    if key as! String == "entries"
                    {
                      if (generalSadhanaViewController.json != JSON.null && pageNum != 0)
                      {
                        generalSadhanaViewController.json.arrayObject?.appendContentsOf((json[key as! String].arrayObject!))
                      }
                      else
                      {
                        generalSadhanaViewController.sections = []
                        generalSadhanaViewController.json = json[key as! String]
                      }
                      success = true
                    }
                    else if key as! String == "total_found"
                    {
                      generalSadhanaViewController.totalFound = Int(json[key as! String].string!)!
                    }
                }
                if !success {
                    generalSadhanaViewController.showErrorAlert()
                }
            default:
                generalSadhanaViewController.showErrorAlert()
            }
            generalSadhanaViewController.tableView.infiniteScrollingView.stopAnimating()
            generalSadhanaViewController.tableView.reloadData()
        }
    }
  }
