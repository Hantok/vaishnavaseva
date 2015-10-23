import UIKit

class LogOutViewController: BaseViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func onLogOut(sender: AnyObject)
    {
      AppController.sharedAppController.isLoggedIn = false
      NSUserDefaults.standardUserDefaults().removeObjectForKey("me")
      performSegueWithIdentifier("BackFromAnyToAny", sender: nil)
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

