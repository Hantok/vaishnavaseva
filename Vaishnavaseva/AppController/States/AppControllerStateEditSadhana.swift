import UIKit

@objc class AppControllerStateEditSadhana: AppControllerState
  {
  override func sceneDidBecomeCurrent()
    {
    super.sceneDidBecomeCurrent()
    self.viewControllerProtocol.setAction(Selector("onDone"), forTarget: self, forStateViewEvent: OnDoneStateViewEvent)
    }

  func onDone()
    {
      let editViewController = self.viewController as! EditSadhanaViewController
      let sadhanaEntry = editViewController.sadhanaEntry
      let sadhanaUser = Deserialiser().getSadhanaUser(NSUserDefaults.standardUserDefaults().objectForKey("me") as! NSDictionary)
      let params = getPostParams(sadhanaEntry, sadhanaUser: sadhanaUser)
      let authString = getAuthString()
      let entryId = sadhanaEntry.id! == -1 ? "" : "\(sadhanaEntry.id!)"
      "sadhanaEntry/\(sadhanaUser.userId!)/\(entryId)".post(params, headers: ["Authorization" : authString] ) { response in
        MBProgressHUD.hideAllHUDsForView(self.viewController.navigationController?.view, animated: true)
        if response.data == nil || response.HTTPResponse.statusCode != 200 {
          self.viewController.showErrorAlert("Server error")
          return
        } else {
          self.viewController.performSegueWithIdentifier("BackFromEditToMy", sender: nil)
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
    if sadhanaEntry.id != -1 {
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
