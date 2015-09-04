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
            var json = JSON(response.responseJSON!)
            let keys = (json.object as! NSDictionary).allKeys
            for key in keys {
                if key as! String == "entries" {
                    (self.viewController as! GeneralSadhanaViewController).json = json[key as! String]
                    break
                }
            }
            (self.viewController as! GeneralSadhanaViewController).tableView.reloadData()
        }
    }
  }
