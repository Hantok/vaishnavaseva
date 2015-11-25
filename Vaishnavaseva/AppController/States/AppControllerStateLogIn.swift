import UIKit

@objc class AppControllerStateLogIn: AppControllerState
  {
//  override func isEqualTo(other: EquatableBase) -> Bool
//    {
//    let otherDynamic = other as! AppControllerStateFirst
//    return  super.isEqualTo(other) &&
//            self.state == otherDynamic.state
//    }
    override func sceneDidBecomeCurrent() {
        super.sceneDidBecomeCurrent()
        self.viewControllerProtocol.setAction(Selector("onLogIn"), forTarget: self, forStateViewEvent: LogInStateViewEvent)
    }
    
    func onLogIn() {
      let logInViewController = self.viewController as! LogInViewController
      let login = logInViewController.loginTextField.text!
      let password = logInViewController.passwordTextField.text!
      let params = getLoginPostParams(login, password: password, refreshToken: false)
      
      Constants.authTokenURL.post(params) { response in
        if (response.data == nil) {
          self.viewController.showErrorAlert(NSLocalizedString("Server error", comment: "Alert title"))
          MBProgressHUD.hideAllHUDsForView(self.viewController.navigationController?.view, animated: true)
          return
        }
        if response.HTTPResponse.statusCode != 200 {
          MBProgressHUD.hideAllHUDsForView(self.viewController.navigationController?.view, animated: true)
          logInViewController.passwordTextField.text = ""
          logInViewController.passwordTextField.becomeFirstResponder()
          logInViewController.showErrorAlert(NSLocalizedString("Authorization error!", comment: "Alert title"))
        }
        else {
          let dict = response.responseJSON as! NSDictionary
          do {
            // update user credentials in keychain
            try Locksmith.updateData([login: password], forUserAccount: "myUserAccount")
            try Locksmith.updateData(dict as! [String : AnyObject], forUserAccount: "OAuthToken")
          } catch {
            print(error)
          }
          let downloadQueue = dispatch_queue_create("isckon.vaishnavaseva.downloadMe", nil)
          dispatch_async(downloadQueue) {
            let oAuthToken = OAuthToken(dict: dict)
            self.getMe(oAuthToken)
          }
        }
      }
    }
  
  private func getMe(oAuthToken: OAuthToken) {
    "me".get(headers: ["Authorization" : "\(oAuthToken.tokenType) \(oAuthToken.accessToken)"]) { response in
      MBProgressHUD.hideAllHUDsForView(self.viewController.navigationController?.view, animated: true)
      if (response.data == nil || response.HTTPResponse.statusCode != 200){
        self.viewController.showErrorAlert(NSLocalizedString("Server error", comment: "Alert title"))
        return
      } else {
        let dict = response.responseJSON as! NSDictionary
        let sadhanaUser = Deserialiser().getSadhanaUser(dict)
        (self.viewController as! LogInViewController).me = sadhanaUser
        //save me
        NSUserDefaults.standardUserDefaults().setValue(dict, forKey: "me")
        AppController.sharedAppController.isLoggedIn = true
        self.viewController.performSegueWithIdentifier("LogInToMy", sender: nil)
      }
    }
  }
}
