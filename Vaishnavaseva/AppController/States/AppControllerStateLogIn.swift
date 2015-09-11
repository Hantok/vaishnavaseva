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
        let userPasswordString = login + ":" + password
        let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        let authString = "Basic \(base64EncodedCredential)"
        
        "me".get(headers: ["Authorization" : authString]) { response in
            //print(response.responseJSON)
            //print(JSON(response.responseJSON!))
            // logInViewController.spiningActivity.hide(true)
            MBProgressHUD.hideAllHUDsForView(self.viewController.navigationController?.view, animated: true)
            if response.HTTPResponse.statusCode != 200
            {
                let alert = UIAlertController(title: "Authorization error!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                logInViewController.presentViewController(alert, animated: true, completion: nil)
                logInViewController.passwordTextField.text = ""
                logInViewController.passwordTextField.becomeFirstResponder()
            }
            else
            {
                do {
                    // update user credentials in keychain
                    try Locksmith.updateData([login: password], forUserAccount: "myUserAccount")
                } catch {
                    print(error)
                }
                AppController.sharedAppController.isLoggedIn = true
                self.viewController.performSegueWithIdentifier("LogInToMy", sender: nil)
            }
        }
    }

  }
