import UIKit

let LogInStateViewEvent = "LogInStateViewEvent"

class LogInViewController: BaseViewController {

  @IBOutlet weak var loginTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  var me = SadhanaUser()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewDidDisappear(animated: Bool)
    {
    //This is a hack to remove the LogInViewController from the stack so when we go back there is no SignIn screen any more, see also removal of the AppControllerStateLogIn from the stack in LogInToMy.perform()
    if AppController.sharedAppController.isLoggedIn
      {
      let myIndex = navigationController!.viewControllers.count - 2
      assert(self == navigationController!.viewControllers[myIndex])
      navigationController!.viewControllers.removeAtIndex(myIndex)
      }
    }
  
  override func didMoveToParentViewController(parent: UIViewController?)
    {
    //This is a hack: when we remove the LogInViewController from the stack (see viewDidDisappear() above, this method is called which then removes the last element from  AppController.previousStates like if a back button is pressed => crash, let's prevent this:
    if !AppController.sharedAppController.isLoggedIn
      {
      super.didMoveToParentViewController(parent)
      }
    }
  
  override func prepareForSegue(storyboardSegue: UIStoryboardSegue, sender: AnyObject?)
  {
    super.prepareForSegue(storyboardSegue, sender: sender)
    if (storyboardSegue.identifier == "LogInToMy")
    {
      (storyboardSegue.destinationViewController as! MySadhanaViewController).sadhanaUser = self.me
    }

  }

  @IBAction func onLogIn(sender: AnyObject)
    {
      if self.loginTextField.text == "" {
        self.loginTextField.becomeFirstResponder()
        self.showErrorAlert(NSLocalizedString("Enter login please", comment: "Alert title"))
        return
      } else if self.passwordTextField.text == "" {
        self.passwordTextField.becomeFirstResponder()
        self.showErrorAlert(NSLocalizedString("Enter password please", comment: "Alert title"))
        return
      }
      UIApplication.sharedApplication().networkActivityIndicatorVisible = true
      let spiningActivity = MBProgressHUD.showHUDAddedTo(navigationController?.view, animated: true)
      spiningActivity.labelText = NSLocalizedString("Loading", comment: "Activity indicator text")
        
      sendActionForStateViewEvent(LogInStateViewEvent)
    }
  
  @IBAction func onSignUp(sender: AnyObject) {
    let registerURL = NSURL(string: "\(Constants.siteURL)/registration")
    UIApplication.sharedApplication().openURL(registerURL!)
  }
  
  @IBAction func hideKeyboard(sender: AnyObject) {
    self.view.endEditing(true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

