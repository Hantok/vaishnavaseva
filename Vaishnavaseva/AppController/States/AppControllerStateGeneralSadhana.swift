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
        "allSadhanaEntries".post(["items_per_page":"999999999"]) { response in
            print(response.responseJSON)
            MBProgressHUD.hideAllHUDsForView((self.viewController as! GeneralSadhanaViewController).navigationController?.view, animated: true)
            var json = JSON(response.responseJSON!)
            switch json.object {
            case _ as NSDictionary:
                let keys = (json.object as! NSDictionary).allKeys
                var success = false
                for key in keys {
                    if key as! String == "entries" {
                        (self.viewController as! GeneralSadhanaViewController).json = json[key as! String]
                        success = true
                        break
                    }
                }
                if !success {
                    self.showAlert()
                }
            default:
                self.showAlert()
            }
            (self.viewController as! GeneralSadhanaViewController).tableView.reloadData()
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Server error", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        (self.viewController as! GeneralSadhanaViewController).presentViewController(alert, animated: true, completion: nil)
    }
  }
