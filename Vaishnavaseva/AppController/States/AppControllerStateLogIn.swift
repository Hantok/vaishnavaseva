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
        let userPasswordString = "\(login):\(password)"
        let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        let authString = "Basic \(base64EncodedCredential)"
        
        "me".get(headers: ["Authorization" : authString]) { response in
            MBProgressHUD.hideAllHUDsForView(self.viewController.navigationController?.view, animated: true)
            if (response.data == nil){
              self.viewController.showErrorAlert("Server error")
              return
            }
            if response.HTTPResponse.statusCode != 200
            {
              logInViewController.passwordTextField.text = ""
              logInViewController.passwordTextField.becomeFirstResponder()
              logInViewController.showErrorAlert("Authorization error!")
            }
            else
            {
              do {
                // update user credentials in keychain
                try Locksmith.updateData([login: password], forUserAccount: "myUserAccount")
                let dict = response.responseJSON as! NSDictionary
                let sadhanaUser = Deserialiser().getSadhanaUser(dict)
                logInViewController.me = sadhanaUser
                //save me
                NSUserDefaults.standardUserDefaults().setValue(dict, forKey: "me")
              } catch {
                  print(error)
              }
              AppController.sharedAppController.isLoggedIn = true
              self.viewController.performSegueWithIdentifier("LogInToMy", sender: nil)
            }
        }
    }

  }
