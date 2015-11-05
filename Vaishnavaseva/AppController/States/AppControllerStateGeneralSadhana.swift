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
        
        MBProgressHUD.hideAllHUDsForView(self.viewController.navigationController?.view, animated: true)
        if (response.data == nil) {
          self.viewController.showErrorAlert(NSLocalizedString("Server error", comment: "Alert title"))
          self.stopAnimations()
          generalSadhanaViewController.isBeforeResponseSucsess = false
          return
        }
        if response.error?.code != nil {
          generalSadhanaViewController.showErrorAlert(NSLocalizedString("No internet connection", comment: "Alert title"))
          self.stopAnimations()
          return
        }
        
        let dict = response.responseJSON as! NSDictionary
        let entriesDict = dict.objectForKey("entries") as! NSArray
        let entries = Deserialiser().getArrayOfSadhanaEntry(entriesDict)
        
        //init or append array
        if (generalSadhanaViewController.entries.count != 0 && pageNum != 0) {
          generalSadhanaViewController.entries.appendContentsOf(entries)
        }
        else {
          generalSadhanaViewController.sections = []
          generalSadhanaViewController.entries = entries
        }
        generalSadhanaViewController.isBeforeResponseSucsess = true
        generalSadhanaViewController.totalFound = (dict.objectForKey("total_found")?.integerValue)!
        self.stopAnimations()
        generalSadhanaViewController.tableView.reloadData()
      }
    }
  
    private func stopAnimations() {
      (self.viewController as! GeneralSadhanaViewController).refreshControl?.endRefreshing()
      (self.viewController as! GeneralSadhanaViewController).tableView.infiniteScrollingView.stopAnimating()
    }
  }
