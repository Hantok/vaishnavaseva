import UIKit

let LogInStateViewEvent = "LogInStateViewEvent"

class LogInViewController: BaseViewController {

  @IBOutlet weak var loginTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loginTextField.text = "roman"
    passwordTextField.text = "Ubuntu108"
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

  @IBAction func onLogIn(sender: AnyObject)
    {
        let spiningActivity = MBProgressHUD.showHUDAddedTo(navigationController?.view, animated: true)
        spiningActivity.labelText = "Loading"
        
        sendActionForStateViewEvent(LogInStateViewEvent)
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

