import UIKit

@objc class AppControllerStateEditSadhana: AppControllerState
  {
  override func sceneDidBecomeCurrent()
    {
    super.sceneDidBecomeCurrent()
    self.viewControllerProtocol.setAction(#selector(AppControllerStateEditSadhana.onDone), forTarget: self, forStateViewEvent: OnDoneStateViewEvent)
    }

  func onDone() {
    let editViewController = self.viewController as! EditSadhanaViewController
    let sadhanaEntry = editViewController.sadhanaEntry
    let sadhanaUser = Deserialiser().getSadhanaUser(NSUserDefaults.standardUserDefaults().objectForKey("me") as! NSDictionary)
    let params = getPostParams(sadhanaEntry, sadhanaUser: sadhanaUser)
    let dict = Locksmith.loadDataForUserAccount("OAuthToken")
    let oAuthToken = OAuthToken(dict: dict!)
    let entryId = sadhanaEntry.id! == -1 ? "" : "\(sadhanaEntry.id!)"
    
    "sadhanaEntry/\(sadhanaUser.userId!)/\(entryId)".post(params, headers: ["Authorization" : "\(oAuthToken.tokenType) \(oAuthToken.accessToken)"]) { response in
      MBProgressHUD.hideAllHUDsForView(self.viewController.navigationController?.view, animated: true)
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      if response.data == nil {
        self.viewController.showErrorAlert(NSLocalizedString("Server error", comment: "Alert title"))
        return
      } else if response.HTTPResponse.statusCode == 200 {
        if (response.responseJSON as! NSDictionary).objectForKey("entry_id")?.integerValue != nil {
          editViewController.sadhanaEntry.id = (response.responseJSON as! NSDictionary).objectForKey("entry_id")!.integerValue
        } else {
          editViewController.sadhanaEntry.id = -1
        }
        self.viewController.performSegueWithIdentifier("BackFromEditToMy", sender: nil)
      } else {
        print(response.responseJSON)
        //logout and go to login screen
        self.viewController.performSegueWithIdentifier("BackFromAnyToLogin", sender: nil)
        return
      }
  }

    //TODO:
    //Here:
    // - Show activity indicator
    // - Show network activity indicator
    // - Try to write data to server in a separate queue.
    //On response:
    // - Hide both indicators
    // - performSegueWithIdentifier("BackFromAnyToAny", sender: nil)
    //On error:
    // - Hide both indicators
    // - Report an error
    }
  
  private func getPostParams(sadhanaEntry: SadhanaEntry, sadhanaUser: SadhanaUser) -> [String : String] {
    var params =
     [/*"id" : "\(sadhanaEntry.id!)",*/
      "user_id" : "\(sadhanaUser.userId!)",
      "date" : "\(sadhanaEntry.date!)",
      "jcount_730" : "\(sadhanaEntry.jCount730!)",
      "jcount_1000" : "\(sadhanaEntry.jCount1000!)",
      "jcount_1800" : "\(sadhanaEntry.jCount1800!)",
      "jcount_after" : "\(sadhanaEntry.jCountAfter!)",
      "reading" : "\(sadhanaEntry.reading!)",
      "kirtan" : "\(sadhanaEntry.kirtan!)",
      "opt_sleep" : "\(sadhanaEntry.sleepTime!)",
      "opt_wake_up" : "\(sadhanaEntry.wakeUpTime!)",
      "opt_exercise" : "\(sadhanaEntry.exerciseEnable!)",
      "opt_service" : "\(sadhanaEntry.serviceEnable!)",
      "opt_lections" : "\(sadhanaEntry.lectionsEnable!)"]
    
    //if set SadhanaEntry
    if sadhanaEntry.id != -1 || sadhanaEntry.id != nil {
      params.updateValue("\(sadhanaEntry.id!)", forKey: "id")
    }

    return params
  }
  
  

//  override func isEqualTo(other: EquatableBase) -> Bool
//    {
//    let otherDynamic = other as! AppControllerStateSecond
//    return  super.isEqualTo(other) &&
//            self.state == otherDynamic.state
//    }
  }
