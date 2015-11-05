import UIKit

@objc class AppControllerStatePersonalSettings: AppControllerState {
  
  override func sceneDidBecomeCurrent() {
    super.sceneDidBecomeCurrent()
    self.viewControllerProtocol.setAction(Selector("onDone"), forTarget: self, forStateViewEvent: OnDoneSettingsStateViewEvent)
  }
  
  func onDone() {
    let personalSettingsViewController = self.viewController as! PersonalSettingsViewController
    let sadhanaUser = personalSettingsViewController.me
    let params = getPostParams(sadhanaUser)
    let authString = getAuthString()

    "options/\(sadhanaUser.userId!)/".post(params, headers: ["Authorization" : authString] ) { response in
      MBProgressHUD.hideAllHUDsForView(self.viewController.navigationController?.view, animated: true)
      if response.data == nil || response.HTTPResponse.statusCode != 200 {
        self.viewController.showErrorAlert(NSLocalizedString("Server error", comment: "Alert title"))
        return
      } else {
        let dict = response.responseJSON as! NSDictionary
        NSUserDefaults.standardUserDefaults().setValue(dict, forKey: "me")
        self.viewController.performSegueWithIdentifier("BackFromAnyToAny", sender: nil)
      }
    }
  }
  
  private func getPostParams(sadhanaUser: SadhanaUser) -> [String : String] {
    let params = ["user_id" : "\(sadhanaUser.userId!)",
      "userid" : "\(sadhanaUser.userId!)",
      "cfg_public" : "\(sadhanaUser.publicEnable!)",
      "cfg_showmoresixteen" : "\(sadhanaUser.showMore16!)",
      "opt_wake" : "\(sadhanaUser.wakeUpEnable!)",
      "opt_service" : "\(sadhanaUser.serviceEnable!)",
      "opt_exercise" : "\(sadhanaUser.exerciseEnable!)",
      "opt_lections" : "\(sadhanaUser.lectionsEnable!)",
      "opt_sleep" : "\(sadhanaUser.sleepEnable!)"]
    return params
  }
  
//  override func isEqualTo(other: EquatableBase) -> Bool
//    {
//    let otherDynamic = other as! AppControllerStateFirst
//    return  super.isEqualTo(other) &&
//            self.state == otherDynamic.state
//    }
  }
